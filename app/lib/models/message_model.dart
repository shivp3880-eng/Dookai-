import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  Message({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.content,
    required this.sender,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Message(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      sender: data['sender'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }
  final String id;
  final String chatId;
  final String userId;
  final String content;
  final String sender; // 'user' or 'ai'
  final DateTime createdAt;
  final bool isFavorite;

  Map<String, dynamic> toFirestore() => {
      'chatId': chatId,
      'userId': userId,
      'content': content,
      'sender': sender,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFavorite': isFavorite,
    };

  Message copyWith({
    String? id,
    String? chatId,
    String? userId,
    String? content,
    String? sender,
    DateTime? createdAt,
    bool? isFavorite,
  }) => Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
}
