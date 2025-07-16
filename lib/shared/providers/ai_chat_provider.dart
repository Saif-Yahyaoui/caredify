import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_chat_service.dart';

// Provider for the AI chat service
final aiChatServiceProvider = Provider<AIChatService>((ref) {
  return AIChatService();
});

// Provider for chat messages
final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
      return ChatMessagesNotifier();
    });

// Provider for chat loading state
final chatLoadingProvider = StateProvider<bool>((ref) => false);

// Provider for chat error state
final chatErrorProvider = StateProvider<String?>((ref) => null);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void updateMessage(String id, ChatMessage updatedMessage) {
    state =
        state.map((message) {
          if (message.id == id) {
            return updatedMessage;
          }
          return message;
        }).toList();
  }

  void addUserMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(message);
  }

  void addAIMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );
    addMessage(message);
  }

  void addLoadingMessage() {
    final message = ChatMessage(
      id: 'loading-${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    addMessage(message);
  }

  void updateLoadingMessage(String id, String content) {
    updateMessage(
      id,
      ChatMessage(
        id: id,
        content: content,
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: false,
      ),
    );
  }

  void removeLoadingMessage() {
    state = state.where((message) => !message.isLoading).toList();
  }

  void clearMessages() {
    state = [];
  }

  void resetChat() {
    clearMessages();
  }
}
