import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';

class SwapDetailsScreen extends StatefulWidget {
  @override
  _SwapDetailsScreenState createState() => _SwapDetailsScreenState();
}

class _SwapDetailsScreenState extends State<SwapDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    'assets/images/Vintage_Armchair2.png',
    'assets/images/Vintage_Armchair.png',
    'assets/images/renovated2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F6F3),
      body: Column(
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Color(0xff694A38)
                              : Colors.white.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Vintage Leather Armchair',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff4A3F35),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xffE6D5C9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Available',
                            style: TextStyle(
                              color: Color(0xff8B4513),
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 18, color: Color(0xff8B4513)),
                        SizedBox(width: 4),
                        Text('Excellent Condition'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 18, color: Color(0xff8B4513)),
                        SizedBox(width: 4),
                        Text('2.5 miles away'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/Avatar.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Sarah Parker',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('4.9 ★ (23 swaps)',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View Profile',
                            style: TextStyle(color: Color(0xff7A4E2D)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'About this item',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff4A3F35),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Beautiful vintage leather armchair in cognac brown. Features solid wood frame, original leather upholstery with minimal wear. Perfect for reading nooks or statement pieces. Approximately 5 years old, well-maintained.',
                      style: TextStyle(color: Colors.black87, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _DimensionBox(label: 'Width', value: '75 cm'),
                        _DimensionBox(label: 'Depth', value: '80 cm'),
                        _DimensionBox(label: 'Height', value: '90 cm'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff694A38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {},
                            child: const Text('Propose Swap',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffE6D5C9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            icon: const Icon(MyFlutterApp.chat,
                                size: 18, color: Color(0xff8B4513)),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DimensionBox extends StatelessWidget {
  final String label;
  final String value;

  const _DimensionBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffF9F6F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.brown)),
        ],
      ),
    );
  }
}
