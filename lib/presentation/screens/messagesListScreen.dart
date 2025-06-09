import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';
import 'package:furniswap/presentation/screens/messagesDetailsScreen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ChatsListCubit>(context)..loadChats(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5EFE6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Messages",
            style: TextStyle(
              color: Color(0xff694A38),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xff694A38)),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ChatsListCubit, ChatsListState>(
          builder: (context, state) {
            if (state is ChatsListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsListLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return const Center(child: Text('No chats found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final displayName = _formatName(chat.receiverId);
                  final chatId = chat.chatId ?? '';
                  final receiverId = chat.receiverId ?? '';
                  return MessageTile(
                    name: displayName,
                    subtitle: "Chat ID: ${_shortChatId(chatId)}",
                    message: "", // آخر رسالة لو عندك
                    time: "", // وقت آخر رسالة لو عندك
                    profileImage: 'assets/images/Avatar.png',
                    unread: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesDetailsScreen(
                            receiverId: receiverId,
                            chatId: chatId,
                            receiverName: displayName,
                            receiverImage: 'assets/images/Avatar.png',
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatsListError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('...'));
            }
          },
        ),
      ),
    );
  }

  String _formatName(String name) {
    if (name.isEmpty) return 'User';
    final uuidParts = name.split('-');
    if (uuidParts.length >= 3 || name.length > 18) {
      return "User";
    }
    return name;
  }

  String _shortChatId(String chatId) {
    if (chatId.length <= 14) return chatId;
    return "${chatId.substring(0, 7)}...${chatId.substring(chatId.length - 4)}";
  }
}

class MessageTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String message;
  final String time;
  final String profileImage;
  final bool unread;
  final VoidCallback? onTap;

  const MessageTile({
    required this.name,
    required this.subtitle,
    required this.message,
    required this.time,
    required this.profileImage,
    this.unread = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffE8E2DC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(profileImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.brown, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (unread)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.circle,
                          color: Color(0xFFDC9C77),
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
