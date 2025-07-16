import 'package:flutter_test/flutter_test.dart';

class MockAIChatService {
  Future<void> initialize() async {
    // Do nothing, skip Firebase
  }

  Future<String> sendMessage(String message) async {
    return getMockResponse(message);
  }

  String getMockResponse(String message) {
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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AIChatService', () {
    late MockAIChatService service;

    setUp(() {
      service = MockAIChatService();
    });

    test('should return a mock response for chat', () async {
      final response = await service.sendMessage('Hello');
      expect(response, isNotNull);
      expect(response, isA<String>());
      expect(response, contains('Hello'));
    });
  });
}
