import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {

  Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt, this.lastMessage,
    this.updatedAt,
    this.isPinned = false,
    this.messageCount = 0,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'New Chat',
      lastMessage: data['lastMessage'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      isPinned: data['isPinned'] ?? false,
      messageCount: data['messageCount'] ?? 0,
    );
  }
  final String id;
  final String userId;
  final String title;
  final String? lastMessage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPinned;
  final int messageCount;

  Map<String, dynamic> toFirestore() => {
      'userId': userId,
      'title': title,
      'lastMessage': lastMessage,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
      'isPinned': isPinned,
      'messageCount': messageCount,
    };

  Chat copyWith({
    String? id,
    String? userId,
    String? title,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    int? messageCount,
  }) => Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      messageCount: messageCount ?? this.messageCount,
    );
}
