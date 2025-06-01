import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 3.0;

  void _submitReview() {
    // لسه مفيش API - بس هنعرض SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Review saved locally (UI only)"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget buildProductCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://s.france24.com/media/display/451ed2b8-eed6-11ea-afdd-005056bf87d6/w:1280/p:16x9/messi-1805.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Vintage Wooden Armchair",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "From: Michael Smith",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Review",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xff694A38),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffF5EFE6),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProductCard(),
            const Text(
              "Rate this product:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 30),
            const Text(
              "Write your comment:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff694A38),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
