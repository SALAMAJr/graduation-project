class Review {
  final String message;
  final ReviewData data;

  Review({required this.message, required this.data});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      message: json["message"],
      data: ReviewData.fromJson(json["data"]),
    );
  }
}

class ReviewData {
  final int rating;
  final String comment;
  final ReviewUser user;
  final ReviewProduct product;

  ReviewData({
    required this.rating,
    required this.comment,
    required this.user,
    required this.product,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      rating: json["rating"],
      comment: json["comment"],
      user: ReviewUser.fromJson(json["user"]),
      product: ReviewProduct.fromJson(json["product"]),
    );
  }
}

class ReviewUser {
  final String id;

  ReviewUser({required this.id});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(id: json["id"]);
  }
}

class ReviewProduct {
  final String id;

  ReviewProduct({required this.id});

  factory ReviewProduct.fromJson(Map<String, dynamic> json) {
    return ReviewProduct(id: json["id"]);
  }
}
