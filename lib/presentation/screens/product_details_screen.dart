import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';
import 'package:furniswap/presentation/screens/create_review_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final List<String> images = [
    "assets/images/renovated1.png",
    "assets/images/renovated2.png",
    "assets/images/renovated3.png",
  ];

  int _currentIndex = 0;

  Widget buildImageGallerySection() {
    return Container(
      width: double.infinity,
      height: 250,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${images.length}',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChipItem({required String label}) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.transparent,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Product Details',
          style: TextStyle(
            color: Color(0xff694A38),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageGallerySection(),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modern Gray Fabric Sofa',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Avatar.png"),
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            'Sarah Wilson',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xff4B5563)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.verified, color: Colors.green, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text('Excellent condition'),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, color: Colors.grey, size: 18),
                      SizedBox(width: 2),
                      Text('2.5 miles away'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Beautiful 3-seater sofa in excellent condition. Purchased 1 year ago from IKEA. Minimal wear, no stains or damage. Perfect for modern living rooms.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Willing to swap for:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildChipItem(label: 'Dining Table'),
                            buildChipItem(label: 'Armchair'),
                            buildChipItem(label: 'Coffee Table'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateReviewScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Color(0xffFDE68A),
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.rate_review_outlined,
                          color: Color(0xff92400E), size: 18),
                      SizedBox(width: 4),
                      Text("Review",
                          style: TextStyle(color: Color(0xff92400E))),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Color(0xffF3F4F6),
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.messenger_outline,
                          color: Color(0xff374151), size: 18),
                      SizedBox(width: 4),
                      Text("Message",
                          style: TextStyle(color: Color(0xff374151))),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Color(0xff694A38),
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(MyFlutterApp.swap, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text("Swap", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
