// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:ecommerce/core/toast.dart';

// import '../../../core/services/agora_service.dart';

// class CallController {
//   final AgoraService _agoraService = AgoraService();

//   bool isMuted = false;
//   bool isVideoEnabled = true;
//   bool isScreenSharing = false;

//   Future<void> joinCall(String token, String channelName, int uid,
//   {
//     required Function(int localUid) onLocalJoin,
//     required Function(int remoteUid) onUserJoined,
//     required Function(int remoteUid) onUserLeft,}
//   ) async {
//     try {
//       await _agoraService.initialize();
//       await _agoraService.engine.joinChannel(
//         token: token,
//         channelId: channelName,
//         uid: uid,
//         options: const ChannelMediaOptions(),
//       );
//     } catch (e) {
//       fToast("Token may have expired please update the token",
//           type: AlertType.failure);
//       print(e.toString());
//     }
//   }

//   Future<void> leaveCall() async {
//     await _agoraService.engine.leaveChannel();
//   }

//   Future<void> toggleMute() async {
//     isMuted = !isMuted;
//     await _agoraService.engine.muteLocalAudioStream(isMuted);
//   }

//   Future<void> toggleVideo() async {
//     isVideoEnabled = !isVideoEnabled;
//     await _agoraService.engine.muteLocalVideoStream(!isVideoEnabled);
//   }

//   Future<void> startScreenShare(String token, String channelName) async {
//     const int screenShareUid = 201;

//     await _agoraService.engine.startScreenCapture(
//       const ScreenCaptureParameters2(
//         captureAudio: true,
//         captureVideo: true,
//         videoParams: ScreenVideoParameters(
//           dimensions: VideoDimensions(width: 1280, height: 720),
//           frameRate: 30,
//           bitrate: 4000,
//         ),
//       ),
//     );

//     await _agoraService.engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: screenShareUid,
//       options: const ChannelMediaOptions(
//         publishScreenTrack: true,
//         publishCameraTrack: false,
//       ),
//     );

//     isScreenSharing = true;
//   }

//   Future<void> stopScreenShare() async {
//     await _agoraService.engine.stopScreenCapture();
//     isScreenSharing = false;
//   }
// }
