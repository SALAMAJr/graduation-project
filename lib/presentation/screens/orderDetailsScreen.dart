import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Order Details",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductCard(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Status',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusStep('Ordered', true),
                      _buildStatusStep('Shipped', true),
                      _buildStatusStep('Delivered', false),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.grey.shade300,
                    color: Color(0xff8B4513),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buidSellerInfoCard(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'Sarah Johnson',
                    style: TextStyle(color: Color(0xff4B5563)),
                  ),
                  Text(
                    '123 Pine Street, Apt 4B',
                    style: TextStyle(color: Color(0xff4B5563)),
                  ),
                  Text(
                    'Brooklyn, NY 11201',
                    style: TextStyle(color: Color(0xff4B5563)),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Expected Delivery',
                      style: TextStyle(fontSize: 14, color: Color(0xff6B7280)),
                    ),
                    subtitle: Text('April 20, 2025',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(
                      MyFlutterApp.delivery,
                      color: Color(0xff8B4513),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text("Payment Method",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    _buildPaymentCard(),
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff694A38),
            elevation: 0,
            minimumSize: Size(double.infinity, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Contact Support",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order ID: #FLB9021',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Text(
                'April 15, 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Chairs.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Wooden Armchair',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Scandinavian Design',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$249.00',
                      style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String title, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: isDone ? Colors.brown : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buidSellerInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/Avatar.png'),
          radius: 24,
        ),
        title:
            Text('John Cooper', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Seller'),
        trailing: Icon(Icons.chat_bubble, color: Color(0xff8B4513)),
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          MyFlutterApp.cc_visa,
          color: Color(0xff8B4513),
          size: 25,
        ),
        title: Text(
          'Visa ending in 4832',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        subtitle: Text('Expires 08/27',
            style: TextStyle(color: Colors.grey, fontSize: 13)),
      ),
    );
  }
}
