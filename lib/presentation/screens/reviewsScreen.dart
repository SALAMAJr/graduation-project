import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/getreviews_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/presentation/screens/editReviewScreen.dart'; // تأكد إنها مستوردة

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<ReviewModel> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetUserReviewsCubit>(
      create: (_) => GetIt.I<GetUserReviewsCubit>()..getUserReviews(),
      child: BlocConsumer<GetUserReviewsCubit, GetUserReviewsState>(
        listener: (context, state) {
          if (state is GetUserReviewsSuccess) {
            setState(() {
              _reviews = List.from(state.reviews);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffF5EFE6),
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "My Reviews",
                style: TextStyle(
                  color: Color(0xff694A38),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Color(0xff694A38)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsScreen()));
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagesListScreen()));
                  },
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (state is GetUserReviewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetUserReviewsFailure) {
                  return Center(
                      child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ));
                } else if (_reviews.isEmpty) {
                  return const Center(
                      child: Text(
                    "لا يوجد مراجعات",
                    style: TextStyle(fontSize: 18, color: Color(0xff694A38)),
                  ));
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Past Reviews",
                          style:
                              TextStyle(color: Color(0xff694A38), fontSize: 17),
                        ),
                      ),
                      ...List.generate(_reviews.length, (index) {
                        final review = _reviews[index];
                        return buildReviewItem(review, context, index);
                      }),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildReviewItem(ReviewModel review, BuildContext context, int index) {
    final product = review.product;
    final String imageUrl = (product?.imageUrl ?? '').isNotEmpty
        ? product!.imageUrl!
        : 'assets/images/default_avatar.png';
    final String name = product?.name ?? 'No Name';
    final double rating = review.rating?.toDouble() ?? 0;
    final String comment = review.comment ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
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
                  child: imageUrl.startsWith('http')
                      ? Image.network(imageUrl)
                      : Image.asset(imageUrl),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4A3419),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      comment,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff4B5563),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            final updatedReview = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditReviewScreen(review: review)),
                            );
                            if (updatedReview != null && mounted) {
                              setState(() {
                                _reviews[index] = updatedReview;
                              });
                            }
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Review'),
                                content: const Text(
                                    'Are you sure you want to delete this review?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              setState(() {
                                _reviews.removeAt(index);
                              });
                              // لو عايز تربط بapi delete زود هنا بعدين
                            }
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
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
  }
}
