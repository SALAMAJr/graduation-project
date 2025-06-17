import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/data/models/socketModel/chatData.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:furniswap/presentation/manager/sendmessage/cubit/chat_send_message_cubit.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';
// 👇 أهم سطر هنا
import 'package:furniswap/core/globals.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  File? _imageFile;
  late String myId;

  @override
  void initState() {
    super.initState();
    // 👇 هنا نقول إحنا في شات ده
    currentlyOpenedChatId = widget.chatId;
    myId = Hive.box('authBox').get('user_id', defaultValue: "");
    print("🔑 My ID: $myId | ReceiverID: ${widget.receiverId}");

    final socketService = GetIt.I<SocketService>();
    socketService.onMessage((data) {
      print("📩 [SOCKET] رسالة وصلت من السيرفر: $data");

      final senderId = data['senderId'] ?? "";
      print("➡️ senderId: $senderId");
      print("🟠 widget.receiverId: ${widget.receiverId} | myId: $myId");

      // الرسالة تخص الشات ده لو اللي باعت هو الـ receiverId أو أنا اللي باعت (myId)
      final isCurrentChat = senderId == widget.receiverId || senderId == myId;
      print("isCurrentChat: $isCurrentChat");

      if (isCurrentChat) {
        print("✅ الرسالة دي بتخص الشات ده، هضيفها في UI");
        final newMsg = ChatMessage(
          id: data['id'] ?? UniqueKey().toString(),
          message: data['content'] ?? "",
          imageUrl: data['imageUrl'],
          createdAt:
              DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now(),
          senderId: senderId,
        );
        context.read<ChatDetailsCubit>().addMessageLocally(newMsg);
      } else {
        print("❌ الرسالة مش بتخص الشات الحالي، مش هتعرضها!");
      }
    });

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

    Future.microtask(() {
      final cubit = context.read<ChatDetailsCubit>();
      if (cubit.state is! ChatDetailsLoaded) {
        cubit.loadOrCreateChat(widget.receiverId);
      }
    });
  }

  @override
  void dispose() {
    // 👇 لما تخرج من الشات، خلي المتغير فاضي
    currentlyOpenedChatId = null;
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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

  Future<String?> _uploadImage(File image) async {
    // هنا تعمل upload للصورة وترجع لينكها من API
    return null;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String chatId) async {
    if (_controller.text.trim().isEmpty && _imageFile == null) return;

    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    print(
        "🚀 [SEND] بعت رسالة للطرف التاني: ${_controller.text.trim()} / image: $imageUrl");
    await context.read<ChatSendMessageCubit>().sendMessage(
          receiverId: widget.receiverId,
          content: _controller.text.trim(),
          imageUrl: imageUrl,
        );

    final messageModel = ChatMessage(
      id: UniqueKey().toString(),
      message: _controller.text.trim(),
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      senderId: myId,
    );
    context.read<ChatDetailsCubit>().addMessageLocally(messageModel);

    _controller.clear();
    setState(() {
      _imageFile = null;
      _showEmojiPicker = false;
    });
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: (widget.receiverImage.isNotEmpty)
                  ? NetworkImage(widget.receiverImage)
                  : AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
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
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
              builder: (context, state) {
                if (state is ChatDetailsLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is ChatDetailsError) {
                  return Center(child: Text(state.message));
                }
                if (state is ChatDetailsLoaded) {
                  final chat = state.chatData;
                  final sortedMessages = List<ChatMessage>.from(chat.messages)
                    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      final message = sortedMessages[index];
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
                              if (message.imageUrl != null &&
                                  message.imageUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      message.imageUrl!,
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (message.message.isNotEmpty)
                                Text(
                                  message.message,
                                  style: TextStyle(
                                    color:
                                        isMine ? Colors.white : Colors.black87,
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
                  );
                }
                return Center(child: CircularProgressIndicator());
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    icon: const Icon(Icons.send, color: Color(0xFF8B7355)),
                    onPressed: () => _sendMessage(widget.chatId ?? ""),
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
}
