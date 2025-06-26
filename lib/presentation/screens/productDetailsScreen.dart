import 'package:flutter/material.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/createReviewScreen.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/messagesDetailsScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductItem product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<String> images;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    images = [widget.product.imageUrl];
  }

  Widget buildImageGallerySection() {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(images[index], fit: BoxFit.cover);
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${images.length}',
                style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageGallerySection(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 18),
                      const SizedBox(width: 4),
                      Text(product.category ?? 'Unknown'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Condition: ${product.condition}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text("Price: ${product.price} EGP"),
                        const SizedBox(height: 8),
                        Text("Type: ${product.type}"),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      builder: (_) => CreateReviewScreen(
                        productId: product.id,
                        imageUrl: product.imageUrl,
                        productName: product.name,
                        ownerName: 'Seller Name',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xffFDE68A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const FittedBox(
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
            const SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessagesDetailsScreen(
                        receiverId: product.userId,
                        chatId: null,
                        receiverName: 'Seller Name',
                        receiverImage: product.imageUrl,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xffF3F4F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const FittedBox(
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
            const SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xff694A38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(
                        product.type == "buy"
                            ? Icons.shopping_cart
                            : MyFlutterApp.swap,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.type == "buy" ? "Buy" : "Swap",
                        style: const TextStyle(color: Colors.white),
                      ),
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
