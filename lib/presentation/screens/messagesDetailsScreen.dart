import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/repository/chating/chat_repo_impl.dart';
import 'package:furniswap/data/repository/socket/socket_service_impl.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/create_chat_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MessagesDetailsScreen extends StatefulWidget {
  final String receiverId;
  final String? chatId; // خليه nullable
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
  String? chatId;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;
  File? _imageFile;
  final List<Map<String, dynamic>> _messages = [];
  bool _isCreatingChat = false; // عشان مانعملش Create أكتر من مرة

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
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

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty && _imageFile == null) return;
    print("📨 عايز ابعت رسالة. chatId: $chatId");

    if (chatId == null && !_isCreatingChat) {
      setState(() {
        _isCreatingChat = true;
      });
      print("🚀 مفيش شات، هبدأ createChat الأول");
      context.read<CreateChatCubit>().createChat(widget.receiverId);
      // الرسالة مش هتتبعت غير لما يخلص الإنشاء (شوف BlocListener تحت)
    } else {
      print("💬 هضيف الرسالة محليًا دلوقتي (بدون API)!");
      setState(() {
        _messages.add({
          'text': _controller.text.trim(),
          'image': _imageFile,
          'time': TimeOfDay.now().format(context),
        });
        _controller.clear();
        _imageFile = null;
        _showEmojiPicker = false;
      });
      _focusNode.requestFocus();
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateChatCubit(ChatRepoImpl(
        ApiService(Dio()),
        SocketServiceImpl(),
      )), // عدل لو عندك DI
      child: BlocListener<CreateChatCubit, CreateChatState>(
        listener: (context, state) {
          if (state is CreateChatLoading) {
            print("⏳ جاري إنشاء الشات ...");
            // ممكن تحط loader هنا لو حابب
          }
          if (state is CreateChatSuccess) {
            print("✅ تم إنشاء الشات بنجاح: ${state.chat.id}");
            setState(() {
              chatId = state.chat.id;
              _isCreatingChat = false;
            });
            // بعد الإنشاء ابعت الرسالة تاني
            _sendMessage();
          }
          if (state is CreateChatError) {
            print("❌ فشل إنشاء الشات: ${state.message}");
            setState(() {
              _isCreatingChat = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حصل مشكلة في إنشاء الشات')),
            );
          }
        },
        child: Scaffold(
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
                  backgroundImage: AssetImage(widget.receiverImage),
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
                        'Chat ID: ${_shortChatId(chatId)}',
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
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B7355),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (message['image'] != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(message['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (message['text'].isNotEmpty)
                              Text(
                                message['text'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              message['time'],
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        onPressed: _sendMessage,
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
        ),
      ),
    );
  }
}
