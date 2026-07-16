import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/index.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/custom_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {

  const ChatScreen({super.key, required this.chatId});
  final String chatId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage(String content) async {
    if (content.isEmpty) return;

    _messageController.clear();
    setState(() => _isGenerating = true);
    _scrollToBottom();

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final aiService = ref.read(aiServiceProvider);
      final authService = ref.read(authServiceProvider);

      final currentUser = authService.currentUser;
      if (currentUser == null) return;

      // Add user message
      await firebaseService.addMessage(
        widget.chatId,
        currentUser.uid,
        content,
        'user',
      );

      _scrollToBottom();

      // Generate AI response
      final aiResponse = await aiService.generateResponse(content);

      // Add AI message
      await firebaseService.addMessage(
        widget.chatId,
        currentUser.uid,
        aiResponse,
        'ai',
      );

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesProvider(widget.chatId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: ref.read(firebaseServiceProvider).getChat(widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                (snapshot.data!).title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
            return const Text('Chat');
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _showRenameDialog,
                child: const Text('Rename'),
              ),
              PopupMenuItem(
                onTap: _showDeleteConfirmation,
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: chatMessages.when(
              data: (messages) => messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start a conversation by sending a message',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return FadeInUp(
                            duration: Duration(
                              milliseconds: 300 + (index * 50),
                            ),
                            child: _buildMessageBubble(
                              message,
                              currentUser?.uid,
                            ),
                          );
                        },
                      ),
              loading: () => const LoadingWidget(message: AppStrings.loading),
              error: (error, stack) =>
                  AppErrorWidget(message: '${AppStrings.error}: $error'),
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isGenerating,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: AppStrings.typeMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.defaultBorderRadius,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: _isGenerating
                        ? null
                        : () => _sendMessage(_messageController.text),
                    child: _isGenerating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, String? userId) {
    final isUserMessage = message.sender == 'user';
    final alignment = isUserMessage
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bgColor = isUserMessage ? AppTheme.primaryColor : Colors.grey[300];
    final textColor = isUserMessage ? Colors.white : Colors.black;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (isUserMessage)
              Text(
                message.content,
                style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              )
            else
              MarkdownBody(
                data: message.content,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.poppins(color: textColor, fontSize: 14),
                  code: GoogleFonts.poppins(
                    backgroundColor: Colors.grey[200],
                    fontSize: 12,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  codeblockPadding: const EdgeInsets.all(8),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUserMessage)
                  IconButton(
                    icon: const Icon(Icons.content_copy, size: 16),
                    onPressed: () {
                      // Copy to clipboard logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                    constraints: const BoxConstraints(minWidth: 0),
                    padding: const EdgeInsets.all(4),
                  ),
                if (!isUserMessage)
                  IconButton(
                    icon: Icon(
                      message.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 16,
                    ),
                    onPressed: () async {
                      final firebaseService = ref.read(firebaseServiceProvider);
                      await firebaseService.toggleFavoriteMessage(
                        widget.chatId,
                        message.id,
                        message.isFavorite,
                      );
                    },
                    constraints: const BoxConstraints(minWidth: 0),
                    padding: const EdgeInsets.all(4),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final firebaseService = ref.read(firebaseServiceProvider);
                await firebaseService.updateChatTitle(
                  widget.chatId,
                  controller.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final firebaseService = ref.read(firebaseServiceProvider);
              await firebaseService.deleteChat(widget.chatId);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
