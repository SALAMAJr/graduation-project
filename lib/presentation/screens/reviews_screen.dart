import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:furniswap/presentation/manager/review/cubit/review_cubit.dart';
import 'package:furniswap/presentation/screens/edit_review_screen.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';
import 'package:furniswap/presentation/screens/create_review_screen.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class Review {
  String title;
  String imagePath;
  String comment;
  double rating;
  bool isEditing;
  Review({
    required this.title,
    required this.imagePath,
    required this.comment,
    required this.rating,
    this.isEditing = false,
  });
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Review> reviews = [
    Review(
      title: "Vintage Coffee Table",
      imagePath: "assets/images/Vintage_Coffee_Table.png",
      comment:
          "Beautiful piece, exactly as described. The wood finish is perfect.",
      rating: 4.0,
    ),
    Review(
      title: "Dining Chair Set",
      imagePath: "assets/images/Dining_Chair_Set.png",
      comment: "Very comfortable chairs, great condition.",
      rating: 5.0,
    ),
  ];

  Widget buildPendingReviewsItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5),
          elevation: 2,
          minimumSize: Size(double.infinity, 130),
          backgroundColor: Colors.white,
          shadowColor: Colors.black26,
          overlayColor: Colors.brown.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          final newReview = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateReviewScreen(
                imagePath: "assets/images/Bookshelf.png",
                title: "Bookshelf",
              ),
            ),
          );
          if (newReview != null) {
            context.read<ReviewCubit>().createReview({
              "rating": newReview.rating,
              "comment": newReview.comment,
              "userId": "72e3e269-f196-4b62-90df-445a50fa2873",
              "productId": "1",
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/Bookshelf.png"),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Bookshelf",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2D1810),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Received on Jan 15, 2025",
                      style: TextStyle(color: Color(0xff4B5563), fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final newReview = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateReviewScreen(
                              imagePath: "assets/images/Bookshelf.png",
                              title: "Bookshelf",
                            ),
                          ),
                        );
                        if (newReview != null) {
                          context.read<ReviewCubit>().createReview({
                            "rating": newReview.rating,
                            "comment": newReview.comment,
                            "userId": "72e3e269-f196-4b62-90df-445a50fa2873",
                            "productId": "1",
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        minimumSize: Size(double.infinity, 35),
                        backgroundColor: Color(0xff694A38),
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Write a Review",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          "My Reviews",
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
      body: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            setState(() {
              reviews.add(
                Review(
                  title: "Bookshelf",
                  imagePath: "assets/images/Bookshelf.png",
                  comment: state.review.data.comment,
                  rating: state.review.data.rating.toDouble(),
                ),
              );
            });
          } else if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Past Reviews",
                style: TextStyle(color: Color(0xff694A38), fontSize: 17),
              ),
            ),
            ...List.generate(reviews.length, (index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 85,
                          height: 85,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(review.imagePath),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                review.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff4A3419),
                                ),
                              ),
                              SizedBox(height: 4),
                              review.isEditing
                                  ? RatingBar.builder(
                                      initialRating: review.rating,
                                      minRating: 1,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 24,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.black,
                                      ),
                                      glow: false,
                                      onRatingUpdate: (value) {
                                        setState(() {
                                          review.rating = value;
                                        });
                                      },
                                    )
                                  : RatingBarIndicator(
                                      rating: review.rating,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.black,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                    ),
                              SizedBox(height: 8),
                              review.isEditing
                                  ? TextFormField(
                                      initialValue: review.comment,
                                      maxLines: 2,
                                      onChanged: (value) {
                                        review.comment = value;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                      ),
                                    )
                                  : Text(
                                      review.comment,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff4B5563),
                                      ),
                                    ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final updatedReview =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditReviewScreen(
                                            review: review,
                                          ),
                                        ),
                                      );
                                      if (updatedReview != null) {
                                        setState(() {
                                          review.title = updatedReview.title;
                                          review.comment =
                                              updatedReview.comment;
                                          review.rating = updatedReview.rating;
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        reviews.removeAt(index);
                                      });
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 3),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Pending Reviews",
                style: TextStyle(color: Color(0xff694A38), fontSize: 17),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildPendingReviewsItem(context),
                buildPendingReviewsItem(context),
                buildPendingReviewsItem(context),
                buildPendingReviewsItem(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
