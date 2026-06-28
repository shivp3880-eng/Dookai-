import 'package:dio/dio.dart';

class AIService {
  late Dio _dio;
  final String? _apiKey; // You'll need to set this from env or config

  AIService({String? apiKey}) : _apiKey = apiKey {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  // Generate AI response using your preferred API
  // This is a template - you'll need to implement with your actual API
  Future<String> generateResponse(String prompt) async {
    try {
      // Example: Using a hypothetical AI API
      // You can replace this with Gemini API, OpenAI API, etc.

      // For now, returning a simulated response
      await Future.delayed(const Duration(milliseconds: 500));

      return _generateSimulatedResponse(prompt);
    } catch (e) {
      print('Error generating AI response: $e');
      rethrow;
    }
  }

  // Stream AI response with typing animation
  Stream<String> streamAIResponse(String prompt) async* {
    try {
      // Simulate streaming response
      final response = _generateSimulatedResponse(prompt);
      final words = response.split(' ');

      for (final word in words) {
        await Future.delayed(const Duration(milliseconds: 50));
        yield word + ' ';
      }
    } catch (e) {
      print('Error streaming AI response: $e');
      rethrow;
    }
  }

  // Helper function to generate simulated responses
  String _generateSimulatedResponse(String prompt) {
    final responses = {
      'hello':
          'Hello! 👋 I\'m DookAI, your smart AI assistant. How can I help you today?',
      'hi': 'Hi there! Welcome to DookAI. What can I assist you with?',
      'what can you do':
          'I can help you with:\n'
          '• Answering questions on various topics\n'
          '• Writing and editing content\n'
          '• Code assistance and debugging\n'
          '• Creative ideas and brainstorming\n'
          '• And much more!\n\n'
          'Feel free to ask me anything!',
      'help':
          'I\'m here to help! You can ask me anything, and I\'ll do my best to assist you. What do you need?',
    };

    final lowerPrompt = prompt.toLowerCase();
    for (final key in responses.keys) {
      if (lowerPrompt.contains(key)) {
        return responses[key]!;
      }
    }

    return 'That\'s an interesting question! I\'m processing it now. In a real implementation, '
        'this would connect to a powerful AI API like Gemini, OpenAI, or Claude to provide '
        'intelligent, context-aware responses. The streaming would show the response being '
        'typed in real-time for a more interactive experience.\n\n'
        'Your question: \"$prompt\"\n\n'
        'You can customize this with your preferred AI service!';
  }

  // Extract suggested prompts
  List<String> getSuggestedPrompts() {
    return [
      'Tell me about Flutter',
      'How to learn AI?',
      'Best practices for coding',
      'Explain machine learning',
      'Tips for productivity',
      'What is Firebase?',
    ];
  }

  // Generate chat title from first message
  Future<String> generateChatTitle(String firstMessage) async {
    try {
      // Limit to first 50 characters
      if (firstMessage.length <= 50) {
        return firstMessage;
      }
      return firstMessage.substring(0, 50) + '...';
    } catch (e) {
      return 'New Chat';
    }
  }
}
