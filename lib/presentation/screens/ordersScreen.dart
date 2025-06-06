import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/orderDetailsScreen.dart';
import 'package:furniswap/presentation/screens/updateOrderScreen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Widget buildPendingStatus() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffFEF3C7),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_filled,
              color: Colors.black,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              "Pending",
              style: TextStyle(
                  color: Color(0xff92400E), fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget buildShippedStatus() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffDBEAFE),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MyFlutterApp.delivery,
              color: Colors.black,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              "Shipped",
              style: TextStyle(
                  color: Color(0xff1E40AF), fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget buildDeliveredStatus() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffD1FAE5),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              color: Colors.black,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              "Delivered",
              style: TextStyle(
                  color: Color(0xff065F46), fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget buildIProductCard(
      {required Widget status, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5),
          elevation: 2,
          minimumSize: Size(double.infinity, 155),
          backgroundColor: Colors.white,
          shadowColor: Colors.black26,
          overlayColor: Colors.brown.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateOrderScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        Image.asset("assets/images/Wooden_Dining_Chair.png")),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Wooden Dining Chair",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2D1810),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "\$199",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff694A38),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    status,
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetailsScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        minimumSize: Size(double.infinity, 35),
                        backgroundColor: Color(0xff694A38),
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
          "My Orders",
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildIProductCard(status: buildPendingStatus(), context: context),
          buildIProductCard(status: buildPendingStatus(), context: context),
          buildIProductCard(status: buildShippedStatus(), context: context),
          buildIProductCard(status: buildShippedStatus(), context: context),
          buildIProductCard(status: buildDeliveredStatus(), context: context),
          buildIProductCard(status: buildDeliveredStatus(), context: context),
          buildIProductCard(status: buildDeliveredStatus(), context: context),
        ],
      ),
    );
  }
}
