import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import '../models/message_models.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'messages';

  String _getChatId(String userId, String expertId) {
    final ids = [userId, expertId]..sort();
    return ids.join('_');
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    try {
      final authService = AuthService();
      final senderId = authService.currentUser?.uid;
      if (senderId == null) throw 'Usuario no autenticado';

      final chatId = _getChatId(senderId, receiverId);
      final docRef = _firestore
          .collection(_collection)
          .doc(chatId)
          .collection('chat')
          .doc();

      final message = MessageModel(
        id: docRef.id,
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await docRef.set(message.toMap());
    } catch (e) {
      throw 'Error al enviar el mensaje';
    }
  }

  // Stream de mensajes en tiempo real
  Stream<List<MessageModel>> getMessages(String expertId) {
    final authService = AuthService();
    final userId = authService.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    final chatId = _getChatId(userId, expertId);

    return _firestore
        .collection(_collection)
        .doc(chatId)
        .collection('chat')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
