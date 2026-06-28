import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============== CHAT OPERATIONS ==============

  // Create new chat
  Future<Chat> createChat(String userId, String title) async {
    try {
      final chatRef = await _firestore.collection('chats').add({
        'userId': userId,
        'title': title,
        'lastMessage': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isPinned': false,
        'messageCount': 0,
      });

      return Chat(
        id: chatRef.id,
        userId: userId,
        title: title,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
  }

  // Get all chats for user
  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
        });
  }

  // Get single chat
  Future<Chat?> getChat(String chatId) async {
    try {
      final doc = await _firestore.collection('chats').doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting chat: $e');
      return null;
    }
  }

  // Update chat title
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'title': newTitle,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating chat title: $e');
      rethrow;
    }
  }

  // Toggle pin chat
  Future<void> togglePinChat(String chatId, bool isPinned) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'isPinned': !isPinned,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error toggling pin: $e');
      rethrow;
    }
  }

  // Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      // Delete all messages in this chat
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the chat itself
      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat: $e');
      rethrow;
    }
  }

  // Search chats
  Future<List<Chat>> searchChats(String userId, String query) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Chat.fromFirestore(doc))
          .where(
            (chat) =>
                chat.title.toLowerCase().contains(query.toLowerCase()) ||
                (chat.lastMessage?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    } catch (e) {
      print('Error searching chats: $e');
      return [];
    }
  }

  // ============== MESSAGE OPERATIONS ==============

  // Add message
  Future<Message> addMessage(
    String chatId,
    String userId,
    String content,
    String sender,
  ) async {
    try {
      final messageRef = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'chatId': chatId,
            'userId': userId,
            'content': content,
            'sender': sender,
            'createdAt': FieldValue.serverTimestamp(),
            'isFavorite': false,
          });

      // Update chat's last message and message count
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      final chat = Chat.fromFirestore(chatDoc);

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': content.length > 100
            ? content.substring(0, 100) + '...'
            : content,
        'updatedAt': FieldValue.serverTimestamp(),
        'messageCount': chat.messageCount + 1,
      });

      return Message(
        id: messageRef.id,
        chatId: chatId,
        userId: userId,
        content: content,
        sender: sender,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Error adding message: $e');
      rethrow;
    }
  }

  // Get messages for chat
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Message.fromFirestore(doc))
              .toList();
        });
  }

  // Toggle favorite message
  Future<void> toggleFavoriteMessage(
    String chatId,
    String messageId,
    bool isFavorite,
  ) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isFavorite': !isFavorite});
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();

      // Update message count
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      await _firestore.collection('chats').doc(chatId).update({
        'messageCount': messagesSnapshot.docs.length,
      });
    } catch (e) {
      print('Error deleting message: $e');
      rethrow;
    }
  }
}
