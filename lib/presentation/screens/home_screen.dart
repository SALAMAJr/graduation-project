import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/cubit/product_search_cubit.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';
import 'package:furniswap/presentation/screens/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    "All Items",
    "Chairs",
    "Tables",
    "Sofas",
    "Desks",
    "Cabinets",
    "Lighting"
  ];
  String selectedCategory = "All Items";
  final TextEditingController _searchController = TextEditingController();

  Widget buildCategoryItem(String categoryName) {
    bool isSelected = categoryName == selectedCategory;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = categoryName;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<ProductSearchCubit>(),
              child: SearchResultsScreen(query: categoryName),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        backgroundColor: isSelected ? const Color(0xff694A38) : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/app_logo.png",
                height: 30, width: 40, color: const Color(0xff8B7355)),
            const SizedBox(width: 8),
            Image.asset("assets/images/app_name.png",
                height: 20, width: 110, color: const Color(0xff8B7355)),
          ],
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MessagesListScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search Input
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) {
                    final trimmed = value.trim();
                    if (trimmed.isEmpty) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProductSearchCubit>(),
                          child: SearchResultsScreen(query: trimmed),
                        ),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Search furniture...",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.black),
                      onPressed: () {},
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 🔘 Categories
              SizedBox(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) =>
                      buildCategoryItem(categories[index]),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Recommendation System",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),

              const SizedBox(height: 10),
              const Center(
                  child: Text("Display recommended items here...")), // مؤقت
            ],
          ),
        ),
      ),
    );
  }
}
