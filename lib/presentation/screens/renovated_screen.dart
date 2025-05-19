import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';

class RenovatedScreen extends StatefulWidget {
  const RenovatedScreen({super.key});

  @override
  State<RenovatedScreen> createState() => _RenovatedScreenState();
}

class _RenovatedScreenState extends State<RenovatedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> images = [
    "assets/images/renovated1.png",
    "assets/images/renovated2.png",
    "assets/images/renovated3.png",
  ];

  final List<Map<String, String>> products = [
    {
      "image": "assets/images/Vintage_Chair.png",
      "title": "Vintage Chair",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Cabinet.png",
      "title": "Cabinet",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Cabinet.png",
      "title": "Cabinet",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Vintage_Chair.png",
      "title": "Vintage Chair",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Vintage_Chair.png",
      "title": "Vintage Chair",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Cabinet.png",
      "title": "Cabinet",
      "condition": "Like New"
    },
    {
      "image": "assets/images/Coffee_Table.png",
      "title": "Coffee Table",
      "condition": "Refurbished"
    },
    {
      "image": "assets/images/Dresser.png",
      "title": "Dresser",
      "condition": "Refurbished"
    },
    {
      "image": "assets/images/Dresser.png",
      "title": "Dresser",
      "condition": "Refurbished"
    },
    {
      "image": "assets/images/Coffee_Table.png",
      "title": "Coffee Table",
      "condition": "Refurbished"
    },
    {
      "image": "assets/images/Coffee_Table.png",
      "title": "Coffee Table",
      "condition": "Refurbished"
    },
    {
      "image": "assets/images/Dresser.png",
      "title": "Dresser",
      "condition": "Refurbished"
    },
  ];

  int _currentIndex = 0;

  Widget buildImageGallerySection() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 180,
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
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == _currentIndex;
                return Container(
                  width: isActive ? 12 : 8,
                  height: isActive ? 12 : 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Color(0xff4A3F35) : Color(0xffD1C7BC),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(String image, String title, String condition) {
    final displayCondition = condition == "Like New" ? "Like New" : condition;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image.asset(
                image,
                height: 120,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4A3F35),
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffE8E2D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayCondition,
                  style: TextStyle(fontSize: 12, color: Color(0xff4A3F35)),
                ),
              ),
            ),
            SizedBox(height: 2),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    minimumSize: Size(double.infinity, 36),
                    backgroundColor: Color(0xff694A38),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(
                  condition == "Like New" ? "Swap" : "Buy",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(String filter) {
    final filtered = products.where((p) => p['condition'] == filter).toList();
    return GridView.builder(
      padding: EdgeInsets.only(top: 16),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final product = filtered[index];
        return buildProductCard(
          product['image']!,
          product['title']!,
          product['condition']!,
        );
      },
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
          "Renovated",
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              height: 48,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "pop",
                    fontSize: 13),
                unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "pop",
                    fontSize: 13),
                unselectedLabelColor: Color(0xff4A3F35),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Color(0xff694A38),
                  borderRadius: BorderRadius.circular(90),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: "New"),
                  Tab(text: "Refurbished"),
                ],
              ),
            ),
            SizedBox(height: 16),
            buildImageGallerySection(),
            SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildProductGrid("Like New"),
                  buildProductGrid("Refurbished"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff694A38),
        shape: CircleBorder(),
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
