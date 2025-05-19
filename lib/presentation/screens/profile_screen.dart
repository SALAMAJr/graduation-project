import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/addresses_screen.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/listings_screen.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';
import 'package:furniswap/presentation/screens/orders_screen.dart';
import 'package:furniswap/presentation/screens/payment_methods_screen.dart';
import 'package:furniswap/presentation/screens/points_screen.dart';
import 'package:furniswap/presentation/screens/reviews_screen.dart';
import 'package:furniswap/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildListItem(
      {required IconData icon,
      required String lable,
      required Widget screen,
      required BuildContext context,
      bool isCustomIcon = false,
      double defaultIconSize = 23,
      double customIconSize = 18}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screen));
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(12),
              elevation: 3,
              minimumSize: Size(double.infinity, 55),
              backgroundColor: Colors.white,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: isCustomIcon ? customIconSize : defaultIconSize,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffF3EDE7),
                    borderRadius: BorderRadius.circular(90)),
                padding: EdgeInsets.all(8),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Text(
                lable,
                style: TextStyle(
                    color: Color(0xff4A3427),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
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
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xff694A38),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Mohamed Salem",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A3427)),
              ),
              SizedBox(height: 5),
              Text(
                "Mosh2eb@bk.ru",
                style: TextStyle(fontSize: 13, color: Color(0xff8B7355)),
              ),
              SizedBox(
                height: 15,
              ),
              buildListItem(
                  icon: MyFlutterApp.box,
                  lable: "My Orders",
                  screen: OrdersScreen(),
                  context: context,
                  isCustomIcon: true),
              buildListItem(
                  icon: MyFlutterApp.location_on,
                  lable: "Shipping Addresses",
                  screen: AddressesScreen(),
                  context: context,
                  isCustomIcon: true),
              buildListItem(
                  icon: MyFlutterApp.credit_card_alt,
                  lable: "Payment Methods",
                  screen: PaymentMethodsScreen(),
                  context: context,
                  isCustomIcon: true),
              buildListItem(
                  icon: Icons.star,
                  lable: "My Points",
                  screen: PointsScreen(),
                  context: context,
                  isCustomIcon: false),
              buildListItem(
                  icon: MyFlutterApp.box,
                  lable: "My Listings",
                  screen: ListingsScreen(),
                  context: context,
                  isCustomIcon: true),
              buildListItem(
                  icon: MyFlutterApp.chat,
                  lable: "My Reviews",
                  screen: ReviewsScreen(),
                  context: context,
                  isCustomIcon: true),
              buildListItem(
                  icon: Icons.settings,
                  lable: "Settings",
                  screen: SettingsScreen(),
                  context: context,
                  isCustomIcon: false),
            ],
          ),
        ),
      ),
    );
  }
}
