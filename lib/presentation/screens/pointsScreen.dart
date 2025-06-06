import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';

class PointsScreen extends StatelessWidget {
  PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Points",
          style: TextStyle(
            color: Color(0xff694A38),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 3),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagesListScreen()));
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.only(left: 3, right: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8)
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "1,250 Points",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff694A38)),
                            ),
                            SizedBox(height: 4),
                            Text("Your Total Points Balance",
                                style: TextStyle(color: Color(0xff694A38))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text("Ways to Earn Points",
                        style:
                            TextStyle(color: Color(0xff694A38), fontSize: 17)),
                    SizedBox(height: 12),
                    buildActionCard("Complete a Swap", "Earn 500 Points"),
                    SizedBox(
                      height: 5,
                    ),
                    buildActionCard("Invite a Friend", "Earn 300 Points"),
                    SizedBox(
                      height: 5,
                    ),
                    buildActionCard("Leave a Review", "Earn 150 Points"),
                    SizedBox(height: 30),
                    Text("Recent Transactions",
                        style:
                            TextStyle(color: Color(0xff694A38), fontSize: 17)),
                    SizedBox(height: 12),
                    buildTransaction(
                        "+500 Points", "Swap Completed", "Mar 12, 2025"),
                    SizedBox(
                      height: 2,
                    ),
                    buildTransaction(
                        "+150 Points", "Left a Review", "Mar 10, 2025"),
                    SizedBox(
                      height: 2,
                    ),
                    buildTransaction(
                        "-200 Points", "Used for Discount", "Mar 8, 2025"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Color(0xff694A38),
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    "Redeem Points",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionCard(String title, String subtitle) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Color(0xff694A38)),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Color(0xff8B7355)),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildTransaction(String points, String description, String date) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(points, style: TextStyle(color: Color(0xff694A38))),
        subtitle: Text(description, style: TextStyle(color: Color(0xff8B7355))),
        trailing: Text(date, style: TextStyle(color: Color(0xff8B7355))),
      ),
    );
  }
}
