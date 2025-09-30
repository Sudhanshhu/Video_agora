import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ecommerce/core/constants/app_config.dart';
import 'package:ecommerce/core/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/participants.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  // Keep track of screen share UID separately
  // static const int _screenShareUid = 2001;

  late String _channelName;
  late String _token;
  late int _localUid;
  late final RtcEngineEx _engine;

  CallBloc() : super(const CallState()) {
    on<InitializeCallEvent>(_onInitializeCall);
    on<UserJoinedEvent>(_onUserJoined);
    on<UserLeftEvent>(_onUserLeft);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleScreenShareEvent>(_onToggleScreenShare);
    on<EndCallEvent>(_onEndCall);
    on<ErrorEvent>((event, emit) {
      emit(state.copyWith(errorMessage: event.message));
    });
    on<SwitchCameraEvent>((event, emit) async {
      _switchCamera();
    });
  }

  /// Initialize Agora and join the channel
  Future<void> _onInitializeCall(
    InitializeCallEvent event,
    Emitter<CallState> emit,
  ) async {
    _token = event.token;
    _channelName = event.channelName;
    // _localUid = event.localUid;

    await [Permission.camera, Permission.microphone].request();

    if (await (Permission.camera.isDenied) ||
        await Permission.microphone.isDenied) {
      return emit(state.copyWith(errorMessage: "Please give permission"));
    }

    // Create Agora engine
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(appId: event.appId));

    // Enable video
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(onJoinChannelSuccess: (connection, elapsed) {
        fToast(
            "joined successfully  ${connection.localUid} Channel $_channelName",
            type: AlertType.success);
        add(UserJoinedEvent(
            Participant(uid: connection.localUid ?? _localUid, isLocal: true)));
      }, onUserJoined: (connection, remoteUid, elapsed) {
        fToast("Remote user id $remoteUid");
        add(UserJoinedEvent(Participant(uid: remoteUid, isLocal: false)));
      }, onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        fToast("Left $remoteUid");
        add(UserLeftEvent(remoteUid));
      }, onError: (err, msg) {
        fToast("Agora Error: $err - $msg", type: AlertType.failure);
        emit(state.copyWith(errorMessage: err.name));
      }, onLocalVideoStateChanged: (VideoSourceType source,
          LocalVideoStreamState state, LocalVideoStreamReason error) {
        fToast(
            '[onLocalVideoStateChanged] source: $source, state: $state, error: $error');
        if (!(source == VideoSourceType.videoSourceScreen ||
            source == VideoSourceType.videoSourceScreenPrimary)) {
          return;
        }

        switch (state) {
          case LocalVideoStreamState.localVideoStreamStateEncoding:
            fToast("Screen sharing TRUE", type: AlertType.success);
            break;
          case LocalVideoStreamState.localVideoStreamStateFailed:
            fToast("Screen sharing FALSE", type: AlertType.success);
            break;
          default:
            break;
        }
      }),
    );

    // Start preview before joining
    await _engine.startPreview();

    final randomUid = Random().nextInt(100000);

    await _engine.joinChannel(
      token: _token,
      channelId: _channelName,
      uid: randomUid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      ),
    );
    emit(state.copyWith(isCallActive: true, rtcEngine: _engine));
  }

  void _onUserJoined(UserJoinedEvent event, Emitter<CallState> emit) {
    final updatedList = List<Participant>.from(state.participants)
      ..add(event.participant);
    emit(state.copyWith(participants: updatedList));
  }

  void _onUserLeft(UserLeftEvent event, Emitter<CallState> emit) {
    final updatedList =
        state.participants.where((p) => p.uid != event.uid).toList();
    emit(state.copyWith(participants: updatedList));
  }

  /// Toggle mute/unmute local audio
  Future<void> _onToggleMute(
      ToggleMuteEvent event, Emitter<CallState> emit) async {
    final newMutedState = !state.isMuted;
    await _engine.muteLocalAudioStream(newMutedState);
    emit(state.copyWith(isMuted: newMutedState));
  }

  /// Start or stop screen sharing
  Future<void> _onToggleScreenShare(
    ToggleScreenShareEvent event,
    Emitter<CallState> emit,
  ) async {
    final currentlySharing = state.isScreenSharing;

    if (currentlySharing) {
      // Stop local screen capture
      await _engine.stopScreenCapture();

      // Leave the screen share connection
      await _engine.leaveChannelEx(
        connection: RtcConnection(
          channelId: _channelName,
          localUid: AppConfig().screenShareUid,
        ),
      );

      emit(state.copyWith(isScreenSharing: false));
      add(UserLeftEvent(AppConfig().screenShareUid));
    } else {
      // 1. Start screen capture
      await _engine.startScreenCapture(
        const ScreenCaptureParameters2(
          captureAudio: true,
          captureVideo: true,
          audioParams: ScreenAudioParameters(
            sampleRate: 44100,
            channels: 2,
          ),
          videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: 30,
            bitrate: 4000,
          ),
        ),
      );

      // 2. Join the channel with a second UID specifically for screen sharing
      await _engine.joinChannelEx(
        token: _token,
        connection: RtcConnection(
          channelId: _channelName,
          localUid: AppConfig().screenShareUid,
        ),
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishScreenTrack: true,
          publishSecondaryScreenTrack: false,
          publishCameraTrack: false,
          publishMicrophoneTrack: false,
          publishScreenCaptureAudio: true,
          publishScreenCaptureVideo: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      emit(state.copyWith(isScreenSharing: true));

      // Add screen share participant to UI
      add(
        UserJoinedEvent(
          Participant(
              uid: AppConfig().screenShareUid,
              isLocal: true,
              isScreenSharing: true),
        ),
      );
    }
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
  }

  /// End the call and cleanup
  Future<void> _onEndCall(EndCallEvent event, Emitter<CallState> emit) async {
    _engine.leaveChannel();
    _engine.release();
    emit(const CallState(participants: [], isCallActive: false));
  }
}
