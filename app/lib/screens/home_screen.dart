import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userChats = ref.watch(userChatsProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Go to Login'),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: null,
                  title: Text(
                    'DookAI',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: AppConstants.smallPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome Message
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              child: Text(
                                '${AppStrings.welcomeMessage}, ${user.displayName ?? 'User'}!',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // New Chat Button
                            FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final firebaseService = ref.read(
                                      firebaseServiceProvider,
                                    );
                                    final chat = await firebaseService
                                        .createChat(user.uid, 'New Chat');
                                    if (mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        '/chat',
                                        arguments: chat.id,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text(AppStrings.newChat),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.defaultBorderRadius,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Search Bar
                            FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.searchChats,
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.defaultBorderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Chats List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  sliver: userChats.when(
                    data: (chats) {
                      if (chats.isEmpty) {
                        return SliverToBoxAdapter(
                          child: FadeIn(
                            duration: const Duration(milliseconds: 700),
                            child: EmptyStateWidget(
                              icon: Icons.chat_bubble_outline,
                              title: 'No Chats',
                              message: AppStrings.noChats,
                              actionLabel: AppStrings.newChat,
                              onAction: () async {
                                final firebaseService = ref.read(
                                  firebaseServiceProvider,
                                );
                                final chat = await firebaseService.createChat(
                                  user.uid,
                                  'New Chat',
                                );
                                if (mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: chat.id,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }

                      final pinnedChats = chats
                          .where((c) => c.isPinned)
                          .toList();
                      final regularChats = chats
                          .where((c) => !c.isPinned)
                          .toList();

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          if (pinnedChats.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppConstants.defaultPadding,
                                bottom: AppConstants.smallPadding,
                              ),
                              child: Text(
                                AppStrings.pinnedChats,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ...pinnedChats.asMap().entries.map((e) => FadeInUp(
                                duration: Duration(
                                  milliseconds: 400 + (e.key * 100),
                                ),
                                child: _buildChatTile(
                                  context,
                                  e.value,
                                  user.uid,
                                ),
                              )),
                            const SizedBox(height: 24),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.smallPadding,
                            ),
                            child: Text(
                              AppStrings.recentChats,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...regularChats.asMap().entries.map((e) => FadeInUp(
                              duration: Duration(
                                milliseconds: 400 + (e.key * 100),
                              ),
                              child: _buildChatTile(context, e.value, user.uid),
                            )),
                          const SizedBox(height: 24),
                        ]),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: LoadingWidget(message: AppStrings.loading),
                    ),
                    error: (error, stack) => SliverToBoxAdapter(
                      child: AppErrorWidget(
                        message: '${AppStrings.error}: $error',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: LoadingWidget(message: AppStrings.loading)),
      error: (error, stack) =>
          Scaffold(body: AppErrorWidget(message: '${AppStrings.error}: $error')),
    );
  }

  Widget _buildChatTile(BuildContext context, dynamic chat, String userId) => Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.smallPadding),
        title: Text(
          chat.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          chat.lastMessage ?? 'No messages yet',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 18,
                ),
                onPressed: () async {
                  final firebaseService = ref.read(firebaseServiceProvider);
                  await firebaseService.togglePinChat(chat.id, chat.isPinned);
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () async {
                      final firebaseService = ref.read(firebaseServiceProvider);
                      await firebaseService.deleteChat(chat.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => Navigator.pushNamed(context, '/chat', arguments: chat.id),
      ),
    );
}
