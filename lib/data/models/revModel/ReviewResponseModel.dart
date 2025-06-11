class ReviewResponseModel {
  final String? status;
  final String? message;
  final ReviewModel? data;

  ReviewResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? ReviewModel.fromJson(json['data']) : null,
    );
  }
}

class ReviewModel {
  final String? id;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;
  final UserModel? user;
  final ProductModel? product;

  ReviewModel({
    this.id,
    this.rating,
    this.comment,
    this.createdAt,
    this.user,
    this.product,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class UserModel {
  final String? id;

  UserModel({this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
    );
  }
}

class ProductModel {
  final String? id;
  final String? name;
  final String? imageUrl;

  ProductModel({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
