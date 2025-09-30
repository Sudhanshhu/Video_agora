class Participant {
  final int uid;
  final bool isLocal;
  final bool isMuted;
  final bool isScreenSharing;

  Participant({
    required this.uid,
    required this.isLocal,
    this.isMuted = false,
    this.isScreenSharing = false,
  });

  Participant copyWith({
    bool? isMuted,
    bool? isScreenSharing,
  }) {
    return Participant(
      uid: uid,
      isLocal: isLocal,
      isMuted: isMuted ?? this.isMuted,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }
}
