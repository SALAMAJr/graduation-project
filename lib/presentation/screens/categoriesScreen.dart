import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/searchResultsScreen.dart';
import 'package:furniswap/presentation/manager/category/cubit/category_products_cubit.dart';
import 'package:furniswap/core/injection/setup_dependencies.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        backgroundColor: isSelected ? const Color(0xff694A38) : Colors.white,
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
          const BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            final category = item["title"];
            if (category == null || category.isEmpty) return;

            final newCubit = CategoryProductsCubit(getIt())
              ..fetchByCategory(category);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: newCubit,
                  child: SearchResultsScreen(
                    query: category,
                    isCategory: true,
                  ),
                ),
              ),
            );
          },
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
                    child: Image.asset(item["image"]!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item["title"]!,
                    style: const TextStyle(
                      color: Color(0xff2C1810),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item["subtitle"]!,
                    style: const TextStyle(
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
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Categories",
            style: TextStyle(
                color: Color(0xff694A38),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MessagesListScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 10),
              child: SizedBox(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) =>
                      buildCategoryItem(categories[index]),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    buildCategoryCard(items[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
