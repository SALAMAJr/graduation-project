import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/addressesScreen.dart';
import 'package:furniswap/presentation/screens/listingsScreen.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/ordersScreen.dart';
import 'package:furniswap/presentation/screens/paymentMethodsScreen.dart';
import 'package:furniswap/presentation/screens/pointsScreen.dart';
import 'package:furniswap/presentation/screens/reviewsScreen.dart';
import 'package:furniswap/presentation/screens/settingsScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildListItem({
    required IconData icon,
    required String lable,
    required Widget screen,
    required BuildContext context,
    bool isCustomIcon = false,
    double defaultIconSize = 23,
    double customIconSize = 18,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          elevation: 3,
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: Colors.white,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffF3EDE7),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: isCustomIcon ? customIconSize : defaultIconSize,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                lable,
                style: const TextStyle(
                  color: Color(0xff4A3427),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "My Profile",
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
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagesListScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            buildListItem(
              icon: MyFlutterApp.box,
              lable: "My Orders",
              screen: OrdersScreen(),
              context: context,
              isCustomIcon: true,
            ),
            buildListItem(
              icon: MyFlutterApp.location_on,
              lable: "Shipping Addresses",
              screen: AddressesScreen(),
              context: context,
              isCustomIcon: true,
            ),
            buildListItem(
              icon: MyFlutterApp.credit_card_alt,
              lable: "Payment Methods",
              screen: PaymentMethodsScreen(),
              context: context,
              isCustomIcon: true,
            ),
            buildListItem(
              icon: Icons.star,
              lable: "My Points",
              screen: PointsScreen(),
              context: context,
              isCustomIcon: false,
            ),
            buildListItem(
              icon: MyFlutterApp.box,
              lable: "My Listings",
              screen: ListingsScreen(),
              context: context,
              isCustomIcon: true,
            ),
            buildListItem(
              icon: MyFlutterApp.chat,
              lable: "My Reviews",
              screen: ReviewsScreen(),
              context: context,
              isCustomIcon: true,
            ),
            buildListItem(
              icon: Icons.settings,
              lable: "Settings",
              screen: SettingsScreen(),
              context: context,
              isCustomIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
