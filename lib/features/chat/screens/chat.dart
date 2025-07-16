import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/ai_chat_provider.dart';
import '../../../shared/services/ai_chat_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize AI chat service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatServiceProvider).initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Clear input
    _messageController.clear();

    // Add user message
    ref.read(chatMessagesProvider.notifier).addUserMessage(message);

    // Add loading message
    ref.read(chatMessagesProvider.notifier).addLoadingMessage();
    ref.read(chatLoadingProvider.notifier).state = true;
    ref.read(chatErrorProvider.notifier).state = null;

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final aiService = ref.read(aiChatServiceProvider);
      final response = await aiService.sendMessage(message);

      // Remove loading message and add AI response
      ref.read(chatMessagesProvider.notifier).removeLoadingMessage();
      ref.read(chatMessagesProvider.notifier).addAIMessage(response);
      ref.read(chatLoadingProvider.notifier).state = false;

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      // Handle error
      ref.read(chatMessagesProvider.notifier).removeLoadingMessage();
      ref
          .read(chatMessagesProvider.notifier)
          .addAIMessage(
            'Sorry, there was an error processing your message. Please try again.',
          );
      ref.read(chatLoadingProvider.notifier).state = false;
      ref.read(chatErrorProvider.notifier).state = e.toString();
    }
  }

  void _resetChat() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Chat'),
            content: const Text('Are you sure you want to clear all messages?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(chatMessagesProvider.notifier).resetChat();
                  ref.read(aiChatServiceProvider).resetChat();
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(chatLoadingProvider);
    final error = ref.watch(chatErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Assistant'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChat,
            tooltip: 'Reset Chat',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome message if no messages
            if (messages.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withAlpha(
                            (0.1 * 255).toInt(),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          size: 60,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to CAREDIFY AI Assistant',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ask me anything about health, wellness, or fitness!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _buildSuggestionChips(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              )
            else
              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),

            // Error message
            if (error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $error',
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed:
                          () =>
                              ref.read(chatErrorProvider.notifier).state = null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            // Input area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      onPressed: isLoading ? null : _sendMessage,
                      icon:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final time = DateFormat('HH:mm').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha(
                            (0.1 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.health_and_safety,
                color: AppColors.primaryBlue,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isUser
                        ? AppColors.primaryBlue
                        : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft:
                      isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                  bottomRight:
                      isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                ),
                boxShadow:
                    isUser
                        ? null
                        : [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.05 * 255).toInt()),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isLoading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isUser ? Colors.white : AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI is typing...',
                          style: TextStyle(
                            color: isUser ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color:
                            isUser
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isUser ? Colors.white60 : Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.grey[600], size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'How can I improve my sleep?',
      'What exercises are good for heart health?',
      'How much water should I drink daily?',
      'Tips for stress management',
    ];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Questions:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                suggestions
                    .map(
                      (suggestion) => GestureDetector(
                        onTap: () {
                          _messageController.text = suggestion;
                          _sendMessage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withAlpha(
                              (0.08 * 255).toInt(),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryBlue.withAlpha(
                                (0.2 * 255).toInt(),
                              ),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            suggestion,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
