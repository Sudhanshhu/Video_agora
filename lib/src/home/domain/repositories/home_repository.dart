import '../entities/event_entity.dart';

abstract class HomeRepository {
  Stream<List<EventEntity>> getEventsStream();
  Future<void> createEvent(
      String title, String description, DateTime startTime, String userId);
  Future<void> increaseCredits(String userId, int amount);
  Stream<bool> listenToStreamingStatus();
}
