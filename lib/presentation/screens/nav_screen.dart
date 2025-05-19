import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/categories_screen.dart';
import 'package:furniswap/presentation/screens/home_screen.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/profile_screen.dart';
import 'package:furniswap/presentation/screens/renovated_screen.dart';
import 'package:furniswap/presentation/screens/swap_and_repair_main_screen.dart';

class NavScreen extends StatefulWidget {
  final int initialIndex;
  const NavScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  final List<Widget> _pages = [
    HomeScreen(),
    CategoriesScreen(),
    SwapAndRepairMainScreen(),
    RenovatedScreen(),
    ProfileScreen()
  ];

  final List<IconData> _icons = [
    MyFlutterApp.home,
    MyFlutterApp.shopping_cart,
    MyFlutterApp.swap,
    MyFlutterApp.brush,
    Icons.person,
  ];

  final List<String> _labels = [
    'Home',
    'Categories',
    'Swap',
    'Renovated',
    'Profile',
  ];

  final List<double> _iconSizes = [
    24,
    24,
    24,
    24,
    28,
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: PageView(
          controller: _pageController,
          physics: DirectionAwareScrollPhysics(
            currentPage: _selectedIndex,
            totalPages: _pages.length,
          ),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = _selectedIndex == index;
            final isCenter = index == 2;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCenter)
                    Transform.translate(
                      offset: const Offset(0, -15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff694A38)
                              : const Color(0xffAFC8AD),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _icons[index],
                          color: Colors.black,
                          size: _iconSizes[index],
                        ),
                      ),
                    )
                  else
                    Icon(
                      _icons[index],
                      color: Colors.black,
                      size: _iconSizes[index],
                    ),
                  SizedBox(height: isCenter ? 12 : 4),
                  if (isCenter)
                    Transform.translate(
                      offset: const Offset(0, -15),
                      child: Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? const Color(0xff694A38)
                              : Colors.grey[500],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    )
                  else
                    Text(
                      _labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? const Color(0xff694A38)
                            : Colors.grey[500],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class DirectionAwareScrollPhysics extends ScrollPhysics {
  final int currentPage;
  final int totalPages;

  DirectionAwareScrollPhysics({
    required this.currentPage,
    required this.totalPages,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  DirectionAwareScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return DirectionAwareScrollPhysics(
      currentPage: currentPage,
      totalPages: totalPages,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double offset) {
    if (currentPage == 0 && offset < 0) {
      return offset;
    } else if (currentPage == totalPages - 1 && offset > 0) {
      return offset;
    }
    return super.applyBoundaryConditions(position, offset);
  }
}
