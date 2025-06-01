class ReviewRequestModel {
  final double rating;
  final String comment;
  final String productId;

  ReviewRequestModel({
    required this.rating,
    required this.comment,
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'createReviewDto': {
        'rating': rating,
        'comment': comment,
      },
      'productId': productId,
    };
  }
}
