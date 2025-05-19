import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> categories = [
    "All Items",
    "Popular",
    "Recent",
    "Trending"
  ];
  String selectedCategory = "All Items";

  final List<Map<String, String>> items = [
    {
      "image": "assets/images/Chairs.png",
      "title": "Chairs",
      "subtitle": "142 items"
    },
    {
      "image": "assets/images/Tables.png",
      "title": "Tables",
      "subtitle": "98 items"
    },
    {
      "image": "assets/images/Sofas.png",
      "title": "Sofas",
      "subtitle": "76 items"
    },
    {
      "image": "assets/images/Desks.png",
      "title": "Desks",
      "subtitle": "64 items"
    },
    {
      "image": "assets/images/Cabinets.png",
      "title": "Cabinets",
      "subtitle": "89 items"
    },
    {
      "image": "assets/images/Lighting.png",
      "title": "Lighting",
      "subtitle": "115 items"
    },
  ];

  Widget buildCategoryItem(String categoryName) {
    bool isSelected = categoryName == selectedCategory;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = categoryName;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15),
        backgroundColor: isSelected ? Color(0xff694A38) : Colors.white,
        overlayColor: Colors.white.withOpacity(0.4),
        shadowColor: Colors.white12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        categoryName,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget buildCategoryCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.brown.withOpacity(0.1),
          highlightColor: Colors.brown.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      item["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item["title"]!,
                    style: TextStyle(
                      color: Color(0xff2C1810),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item["subtitle"]!,
                    style: TextStyle(
                        fontSize: 12, color: Color.fromARGB(100, 44, 24, 16)),
                  ),
                ),
              ],
            ),
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
          "Categories",
          style: TextStyle(
              color: Color(0xff694A38),
              fontSize: 20,
              fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  elevation: 0,
                  backgroundColor: Colors.white,
                  mini: true,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  elevation: 0,
                  backgroundColor: Colors.white,
                  mini: true,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search furniture...",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon:
                          Icon(Icons.camera_alt_outlined, color: Colors.black),
                      onPressed: () {},
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 10),
              child: SizedBox(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return buildCategoryItem(categories[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return buildCategoryCard(items[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
