part of 'product_search_cubit.dart';

abstract class ProductSearchState {}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchLoading extends ProductSearchState {}

class ProductSearchSuccess extends ProductSearchState {
  final List<ProductSearchModel> products;

  ProductSearchSuccess(this.products);
}

class ProductSearchFailure extends ProductSearchState {
  final String message;

  ProductSearchFailure(this.message);
}
