import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/accountSettingsScreen.dart';
import 'package:furniswap/presentation/screens/loginScreen.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/languageRegionScreen.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/passwordSecurityScreen.dart';
import 'package:furniswap/presentation/screens/profileScreen.dart';

Widget buildListItem({
  required IconData icon,
  required String label,
  required Widget screen,
  required BuildContext context,
  bool isCustomIcon = false,
  double defaultIconSize = 23,
  double customIconSize = 19,
}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      minimumSize: Size(double.infinity, 58),
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: isCustomIcon ? customIconSize : defaultIconSize,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xff4A3427),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
      ],
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Settings",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Color(0xff694A38), width: 2),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 45,
                      backgroundImage: AssetImage("assets/images/Avatar2.png"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mohamed Salem",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4A3427),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Mosh2eb@bk.ru",
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff8B7355)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildRoundedContainer([
              buildListItem(
                icon: Icons.person_outline,
                label: "Account Settings",
                screen: AccountSettingsScreen(),
                context: context,
                isCustomIcon: false,
              ),
              buildDivider(),
              buildListItem(
                icon: Icons.lock,
                label: "Password & Security",
                screen: PasswordSecurityScreen(),
                context: context,
                isCustomIcon: false,
              ),
              buildDivider(),
              buildListItem(
                icon: Icons.notifications_none,
                label: "Notifications",
                screen: NotificationsScreen(),
                context: context,
                isCustomIcon: false,
              ),
            ]),
            SizedBox(height: 10),
            _buildRoundedContainer([
              buildListItem(
                icon: MyFlutterApp.privacy,
                label: "Privacy & Permissions",
                screen: ProfileScreen(),
                context: context,
                isCustomIcon: true,
              ),
              buildDivider(),
              buildListItem(
                icon: MyFlutterApp.language,
                label: "Language & Region",
                screen: LanguageRegionScreen(),
                context: context,
                isCustomIcon: true,
              ),
            ]),
            SizedBox(height: 10),
            _buildRoundedContainer([
              buildListItem(
                icon: MyFlutterApp.help_outline,
                label: "Help & Support",
                screen: ProfileScreen(),
                context: context,
                isCustomIcon: true,
              ),
              buildDivider(),
              buildListItem(
                icon: MyFlutterApp.document,
                label: "Terms & Privacy Policy",
                screen: ProfileScreen(),
                context: context,
                isCustomIcon: true,
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Color(0xffEF4444),
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedContainer(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: children,
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: Colors.brown[200],
      thickness: 0.8,
      height: 0,
    );
  }
}
