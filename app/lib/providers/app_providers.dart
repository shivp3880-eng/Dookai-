import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/index.dart';
import '../services/index.dart';

// Services
final authServiceProvider = Provider((ref) => AuthService());
final firebaseServiceProvider = Provider((ref) => FirebaseService());
final aiServiceProvider = Provider((ref) => AIService());

// Auth State
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// User Data
final userDataProvider = FutureProvider.family<UserModel?, String>((
  ref,
  uid,
) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getUserData(uid);
});

// Current User
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// User Chats
final userChatsProvider = StreamProvider<List<Chat>>((ref) {
  final authService = ref.watch(authServiceProvider);
  final firebaseService = ref.watch(firebaseServiceProvider);

  final currentUser = authService.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return firebaseService.getUserChats(currentUser.uid);
});

// Single Chat
final chatProvider = FutureProvider.family<Chat?, String>((ref, chatId) async {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getChat(chatId);
});

// Chat Messages
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  chatId,
) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getChatMessages(chatId);
});

// Search Chats
final searchChatsProvider = FutureProvider.family<List<Chat>, String>((
  ref,
  query,
) async {
  final authService = ref.watch(authServiceProvider);
  final firebaseService = ref.watch(firebaseServiceProvider);

  final currentUser = authService.currentUser;
  if (currentUser == null) {
    return [];
  }

  return firebaseService.searchChats(currentUser.uid, query);
});

// Suggested Prompts
final suggestedPromptsProvider = Provider((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.getSuggestedPrompts();
});
