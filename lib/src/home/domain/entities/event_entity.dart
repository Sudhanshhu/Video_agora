class EventEntity {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final bool isStreaming;
  final String createdBy;

  EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.isStreaming,
    required this.createdBy,
  });

  factory EventEntity.fromMap(Map<String, dynamic> map, String id) {
    return EventEntity(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startTime: (map['startTime']).toDate(),
      isStreaming: map['isStreaming'] ?? false,
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime,
      'isStreaming': isStreaming,
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
    };
  }
}
