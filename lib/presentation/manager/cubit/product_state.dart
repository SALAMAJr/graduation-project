part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);
}

class ProductListSuccess extends ProductState {
  final List<ProductItem> products;

  ProductListSuccess(this.products);
}
