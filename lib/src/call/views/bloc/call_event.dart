import '../../models/participants.dart';

abstract class CallEvent {}

class InitializeCallEvent extends CallEvent {
  final String token;
  final String channelName;
  final String appId;

  InitializeCallEvent({
    required this.token,
    required this.channelName,
    required this.appId,
  });
}

class UserJoinedEvent extends CallEvent {
  final Participant participant;
  UserJoinedEvent(this.participant);
}

class UserLeftEvent extends CallEvent {
  final int uid;
  UserLeftEvent(this.uid);
}

class ToggleMuteEvent extends CallEvent {}

class ToggleScreenShareEvent extends CallEvent {}

class EndCallEvent extends CallEvent {}

class ErrorEvent extends CallEvent {
  final String message;
  ErrorEvent(this.message);
}

class SwitchCameraEvent extends CallEvent {}
