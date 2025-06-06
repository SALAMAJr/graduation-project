import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/diyScreen.dart';
import 'package:furniswap/presentation/screens/repair_screen.dart';
import 'package:furniswap/presentation/screens/swap_screen.dart';

class SwapAndRepairMainScreen extends StatelessWidget {
  const SwapAndRepairMainScreen({super.key});

  Widget buildTabItem({required IconData icon, required String lable}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 21,
        ),
        SizedBox(width: 8),
        Text(lable),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffF5EFE6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Swap & Repair",
            style: TextStyle(
                color: Color(0xff694A38),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  color: Color(0xff694A38)),
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
          bottom: TabBar(
              overlayColor:
                  WidgetStateProperty.all(Colors.brown.withOpacity(0.07)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "pop", fontSize: 15),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: "pop",
                  fontSize: 15),
              indicatorColor: Color(0xff694A38),
              labelColor: Color(0xff694A38),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: buildTabItem(icon: MyFlutterApp.swap, lable: "Swap"),
                ),
                Tab(
                  child:
                      buildTabItem(icon: MyFlutterApp.repair, lable: "Repair"),
                ),
                Tab(
                  child: buildTabItem(icon: MyFlutterApp.book, lable: "DIY"),
                ),
              ]),
        ),
        body: TabBarView(
          children: [SwapScreen(), RepairScreen(), DiyScreen()],
        ),
      ),
    );
  }
}
