import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../models/participants.dart';

class CallState {
  final List<Participant> participants;
  final bool isCallActive;
  final bool isMuted;
  final bool isScreenSharing;
  final RtcEngine? rtcEngine;

  /// Field to track errors in the call
  final String? errorMessage;

  const CallState({
    this.participants = const [],
    this.isCallActive = false,
    this.isMuted = false,
    this.isScreenSharing = false,
    this.rtcEngine,
    this.errorMessage,
  });

  /// CopyWith for immutability
  CallState copyWith({
    List<Participant>? participants,
    bool? isCallActive,
    bool? isMuted,
    bool? isScreenSharing,
    RtcEngine? rtcEngine,
    String? errorMessage,
    bool clearError = false, // optional flag to clear errors easily
  }) {
    return CallState(
      participants: participants ?? this.participants,
      isCallActive: isCallActive ?? this.isCallActive,
      isMuted: isMuted ?? this.isMuted,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      rtcEngine: rtcEngine ?? this.rtcEngine,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
