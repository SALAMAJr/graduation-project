import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/receiver_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:furniswap/presentation/screens/messagesDetailsScreen.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:get_it/get_it.dart';

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
                return const Center(child: Text('لا توجد محادثات حتى الآن.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final chatId = chat.chatId;
                  final receiverId = chat.receiverId;

                  return BlocProvider(
                    create: (_) => ReceiverCubit(GetIt.I<ChatRepo>())
                      ..loadReceiver(receiverId),
                    child: BlocBuilder<ReceiverCubit, ReceiverState>(
                      builder: (context, state) {
                        String name = receiverId;
                        String image = 'assets/images/Avatar.png';

                        if (state is ReceiverLoaded) {
                          name = '${state.receiver.firstName} ${state.receiver.lastName}'
                                  .trim()
                                  .isEmpty
                              ? receiverId
                              : '${state.receiver.firstName} ${state.receiver.lastName}';
                          image = state.receiver.image.isNotEmpty
                              ? state.receiver.image
                              : 'assets/images/Avatar.png';
                        } else if (state is ReceiverLoading) {
                          name = "جاري التحميل...";
                        } else if (state is ReceiverError) {
                          name = "غير متاح";
                        }

                        return MessageTile(
                          name: name,
                          subtitle: "",
                          message: "ابدأ المحادثة الآن",
                          time: "",
                          profileImage: image,
                          unread: false,
                          onTap: () {
                            // نعمل الكوبيـت هنا ونوديه مع الشاشة
                            final chatDetailsCubit =
                                ChatDetailsCubit(GetIt.I());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: chatDetailsCubit,
                                  child: MessagesDetailsScreen(
                                    receiverId: receiverId,
                                    chatId: chatId,
                                    receiverName: name,
                                    receiverImage: image,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
            ClipOval(
              child: profileImage.startsWith('http')
                  ? Image.network(
                      profileImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/Avatar.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover),
                    )
                  : Image.asset(
                      profileImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  if (subtitle.isNotEmpty)
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
