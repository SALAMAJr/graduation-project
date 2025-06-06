import 'package:flutter/material.dart';
import 'messagesDetailsScreen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 12),
          MessageTile(
            name: 'Sarah Miller',
            subtitle: 'Swapping: Leather Sofa',
            message: 'Is the sofa still available for swap?',
            time: '10:24 AM',
            profileImage: 'assets/images/Avatar.png',
            unread: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          MessageTile(
            name: 'James Cooper',
            subtitle: 'Swapping: Dining Table',
            message: "Perfect! Let's arrange the pickup time...",
            time: 'Yesterday',
            profileImage: 'assets/images/Avatar.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          MessageTile(
            name: 'Emma Wilson',
            subtitle: 'Swapping: Vintage Lamp',
            message: 'Thank you for the swap! The lamp looks...',
            time: 'Wed',
            profileImage: 'assets/images/Avatar.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          MessageTile(
            name: 'Michael Chen',
            subtitle: 'Swapping: Leather Sofa',
            message: 'Would you consider a partial swap...',
            time: 'Mon',
            profileImage: 'assets/images/Avatar.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          MessageTile(
            name: 'Lisa Thompson',
            subtitle: 'Swapping: Coffee Table',
            message: 'I can meet this weekend for the swap...',
            time: 'Sun',
            profileImage: 'assets/images/Avatar.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          MessageTile(
            name: 'Lisa Thompson',
            subtitle: 'Swapping: Coffee Table',
            message: 'I can meet this weekend for the swap...',
            time: 'Sat',
            profileImage: 'assets/images/Avatar.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MessagesDetailsScreen()),
              );
            },
          ),
        ],
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
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessagesDetailsScreen())),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffE8E2DC)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.brown),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
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
