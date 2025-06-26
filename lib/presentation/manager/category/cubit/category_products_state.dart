part of 'category_products_cubit.dart';

abstract class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object?> get props => [];
}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductItem> products;

  const CategoryProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class CategoryProductsError extends CategoryProductsState {
  final String message;

  const CategoryProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
