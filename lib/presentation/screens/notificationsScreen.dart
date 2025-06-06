import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/notificationDetailsScreen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xff694A38),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xff694A38)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle(title: 'Today'),
          const SizedBox(height: 12),
          NotificationCard(
            icon: Icons.swap_horiz,
            iconBgColor: Color(0xFFE0ECFF),
            iconColor: Color(0xFF3B82F6),
            title: 'New swap request',
            subtitle: 'Sarah wants to swap her shift with you on Friday',
            time: '2 hours ago',
          ),
          const SizedBox(height: 12),
          NotificationCard(
            icon: Icons.message,
            iconBgColor: Color(0xFFE6F4EA),
            iconColor: Color(0xFF10B981),
            title: 'New message',
            subtitle: 'Team meeting has been rescheduled to 3 PM',
            time: '5 hours ago',
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Yesterday'),
          const SizedBox(height: 12),
          NotificationCard(
            icon: Icons.notifications,
            iconBgColor: Color(0xFFEDE9FE),
            iconColor: Color(0xFF8B5CF6),
            title: 'System Update',
            subtitle: 'App version 2.4 is now available with new features',
            time: 'Yesterday at 8:30 PM',
          ),
          const SizedBox(height: 12),
          NotificationCard(
            icon: Icons.calendar_today,
            iconBgColor: Color(0xFFFFE7D9),
            iconColor: Color(0xFFF97316),
            title: 'Calendar Update',
            subtitle: 'Your shift on Saturday has been confirmed',
            time: 'Yesterday at 2:15 PM',
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Earlier'),
          const SizedBox(height: 12),
          NotificationCard(
            icon: Icons.favorite,
            iconBgColor: Color(0xFFFEE2E2),
            iconColor: Color(0xFFEF4444),
            title: 'Achievement Unlocked',
            subtitle: 'You\'ve completed 50 successful shifts!',
            time: 'Apr 22',
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const NotificationCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        elevation: 2,
        minimumSize: Size(double.infinity, 130),
        backgroundColor: Colors.white,
        shadowColor: Colors.black26,
        overlayColor: Colors.brown.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationDetailsScreen()));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
