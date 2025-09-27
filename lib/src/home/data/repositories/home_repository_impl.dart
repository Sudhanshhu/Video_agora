import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<EventEntity>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => EventEntity.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Future<void> createEvent(String title, String description, DateTime startTime,
      String userId) async {
    final event = EventEntity(
      id: '',
      title: title,
      description: description,
      startTime: startTime,
      isStreaming: false,
      createdBy: userId,
    );
    await _firestore.collection('events').add(event.toMap());
  }

  @override
  Future<void> increaseCredits(String userId, int amount) async {
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore.collection('users').doc(userId);
      final snapshot = await transaction.get(userRef);

      final currentCredits = snapshot['credits'] ?? 0;
      transaction.update(userRef, {
        'credits': currentCredits + amount,
      });
    });
  }

  @override
  Stream<bool> listenToStreamingStatus() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.any((doc) => doc.data()['isStreaming'] == true);
    });
  }
}
