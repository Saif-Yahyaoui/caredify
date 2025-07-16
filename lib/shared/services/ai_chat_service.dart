import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AIChatService {
  static final AIChatService _instance = AIChatService._internal();
  factory AIChatService() => _instance;
  AIChatService._internal();

  late final GenerativeModel _model;
  ChatSession? _chatSession;
  bool _isInitialized = false;

  /// Initialize the AI chat service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Ensure Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Initialize the Gemini Developer API backend service
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-flash', // Try a different model
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );

      // Start a new chat session
      _chatSession = _model.startChat();
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('AI Chat Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing AI Chat Service: $e');
      }
      rethrow;
    }
  }

  /// Send a message and get AI response
  Future<String> sendMessage(String message) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _chatSession ??= _model.startChat();

      // Send the message and get response
      final response = await _chatSession!.sendMessage(Content.text(message));

      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error sending message: $e');
        debugPrint('Error type: ${e.runtimeType}');
        debugPrint('Error details: ${e.toString()}');
      }

      // Temporary mock response for testing while App Check is being resolved
      return _getMockResponse(message);
    }
  }

  /// Temporary mock responses for testing
  String _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! I\'m your CAREDIFY AI health assistant. How can I help you today?';
    } else if (lowerMessage.contains('health') ||
        lowerMessage.contains('fitness')) {
      return 'Great question about health! Regular exercise, balanced nutrition, and adequate sleep are key to maintaining good health. Would you like specific advice on any of these areas?';
    } else if (lowerMessage.contains('exercise') ||
        lowerMessage.contains('workout')) {
      return 'Exercise is essential for heart health! Try to get at least 150 minutes of moderate aerobic activity per week. Walking, swimming, and cycling are excellent options.';
    } else if (lowerMessage.contains('sleep')) {
      return 'Quality sleep is crucial for health. Aim for 7-9 hours per night. Try to maintain a consistent sleep schedule and create a relaxing bedtime routine.';
    } else if (lowerMessage.contains('water') ||
        lowerMessage.contains('hydration')) {
      return 'Stay hydrated! Drink about 8 glasses (2 liters) of water daily. More if you\'re exercising or in hot weather.';
    } else if (lowerMessage.contains('stress')) {
      return 'Managing stress is important for overall health. Try deep breathing, meditation, regular exercise, and maintaining a healthy work-life balance.';
    } else {
      return 'I\'m here to help with your health and wellness questions! You can ask me about exercise, nutrition, sleep, stress management, and general health topics.';
    }
  }

  /// Send a message with streaming response
  Stream<String> sendMessageStream(String message) async* {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _chatSession ??= _model.startChat();

      // Send the message and get streaming response
      final response = _chatSession!.sendMessageStream(
        Content.text(message),
      );

      await for (final chunk in response) {
        final text = chunk.text ?? '';
        yield text;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error sending message stream: $e');
      }
      yield 'Sorry, there was an error processing your message. Please try again.';
    }
  }

  /// Reset the chat session
  void resetChat() {
    _chatSession = _model.startChat();
    if (kDebugMode) {
      debugPrint('Chat session reset');
    }
  }

  /// Get chat history
  List<Content> getChatHistory() {
    return _chatSession?.history.toList() ?? [];
  }

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    _chatSession = null;
    _isInitialized = false;
  }
}
