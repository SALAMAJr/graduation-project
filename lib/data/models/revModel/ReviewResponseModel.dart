class ReviewResponseModel {
  final String status;
  final String message;
  final ReviewModel data;

  ReviewResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      status: json['status'],
      message: json['message'],
      data: ReviewModel.fromJson(json['data']),
    );
  }
}

class ReviewModel {
  final int rating;
  final String comment;
  final UserModel user;
  final ProductModel product;

  ReviewModel({
    required this.rating,
    required this.comment,
    required this.user,
    required this.product,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      user: UserModel.fromJson(json['user']),
      product: ProductModel.fromJson(json['product']),
    );
  }
}

class UserModel {
  final String id;

  UserModel({required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
    );
  }
}

class ProductModel {
  final String id;

  ProductModel({required this.id});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
    );
  }
}
