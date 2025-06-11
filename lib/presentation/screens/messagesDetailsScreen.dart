import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:furniswap/data/repository/chating/chat_repo_impl.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';

import 'package:furniswap/data/models/socketModel/ChatData.dart';

class MessagesDetailsScreen extends StatefulWidget {
  final String receiverId;
  final String? chatId;
  final String receiverName;
  final String receiverImage;

  const MessagesDetailsScreen({
    super.key,
    required this.receiverId,
    required this.chatId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  _MessagesDetailsScreenState createState() => _MessagesDetailsScreenState();
}

class _MessagesDetailsScreenState extends State<MessagesDetailsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;
  File? _imageFile;
  late String myId;

  @override
  void initState() {
    super.initState();
    myId = Hive.box('authBox').get('user_id', defaultValue: "");
    if (widget.receiverId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('مفيش بيانات للمستخدم المستقبل!')),
        );
        Navigator.of(context).pop();
      });
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmojiPicker) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller.text += emoji.emoji;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    setState(() {
      _showEmojiPicker = false;
    });
    _focusNode.requestFocus();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF8B7355)),
                title: Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF8B7355)),
                title: Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
      setState(() {
        _showEmojiPicker = true;
      });
    }
  }

  String _shortChatId(String? chatId) {
    if (chatId == null) return '---';
    if (chatId.length <= 14) return chatId;
    return "${chatId.substring(0, 7)}...${chatId.substring(chatId.length - 4)}";
  }

  void _sendMessage(String chatId) {
    if (_controller.text.trim().isEmpty && _imageFile == null) return;
    // هنا مكان إرسال الرسالة:
    // context.read<ChatDetailsCubit>().sendMessage(chatId, _controller.text, image: _imageFile);

    _controller.clear();
    setState(() {
      _imageFile = null;
      _showEmojiPicker = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatDetailsCubit(GetIt.I())..loadOrCreateChat(widget.receiverId),
      child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
        builder: (context, state) {
          print("🟣 [UI] ChatDetailsCubit State: $state");

          if (state is ChatDetailsLoading) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text("تحميل الشات...")),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ChatDetailsError) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text("خطأ")),
              body: Center(child: Text(state.message)),
            );
          }
          if (state is ChatDetailsLoaded) {
            final chat = state.chatData;
            print('🟢 [UI] Loaded with messages: ${chat.messages.length}');
            return Scaffold(
              backgroundColor: Color(0xffF5EFE6),
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: true,
                elevation: 0,
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.receiverImage.startsWith("http")
                          ? NetworkImage(widget.receiverImage)
                          : AssetImage(widget.receiverImage) as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              color: Color(0xFF5D4037),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Chat ID: ${_shortChatId(chat.id)}',
                            style: const TextStyle(
                              color: Color(0xff8B7355),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            chat.messages[chat.messages.length - 1 - index];
                        final isMine = message.senderId == myId;
                        return Align(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? const Color(0xFF8B7355)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMine ? 16 : 0),
                                bottomRight: Radius.circular(isMine ? 0 : 16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMine
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (message.message.isNotEmpty)
                                  Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isMine
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  message.createdAt.toString(),
                                  style: TextStyle(
                                      color: isMine
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_imageFile != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Color(0xffF7F5F2),
                          borderRadius: BorderRadius.circular(45)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.image_outlined,
                                color: Color(0xFF8B7355)),
                            onPressed: _pickImage,
                          ),
                          IconButton(
                            icon: Icon(
                              _showEmojiPicker
                                  ? Icons.keyboard_alt_outlined
                                  : Icons.emoji_emotions_outlined,
                              color: const Color(0xFF8B7355),
                            ),
                            onPressed: _toggleEmojiPicker,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Color(0xffADAEBC)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send,
                                color: Color(0xFF8B7355)),
                            onPressed: () => _sendMessage(chat.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !_showEmojiPicker,
                    child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        onEmojiSelected: (Category? category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        config: const Config(
                          emojiSizeMax: 28.0,
                          columns: 7,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // لو لسه مفيش حاجة
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
