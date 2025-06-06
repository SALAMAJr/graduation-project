import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/createproduct/product_entity.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo repo;

  ProductCubit(this.repo) : super(ProductInitial());

  Future<void> createProduct(ProductEntity entity) async {
    emit(ProductLoading());

    final result = await repo.createProduct(entity);

    result.fold(
      (failure) => emit(ProductFailure(
        failure is ServerFailure ? failure.message : 'Unknown error',
      )),
      (_) => emit(ProductSuccess()),
    );
  }

  Future<void> getMyProducts() async {
    emit(ProductLoading());

    final result = await repo.getMyProducts();

    result.fold(
      (failure) => emit(ProductFailure(
        failure is ServerFailure ? failure.message : 'Unknown error',
      )),
      (products) =>
          emit(ProductListSuccess(products)), // ✅ دلوقتي بتتعامل مع ProductItem
    );
  }

  Future<void> updateProduct(ProductEntity entity) async {
    emit(ProductLoading());

    final result = await repo.updateProduct(entity);

    result.fold(
      (failure) => emit(ProductFailure(
        failure is ServerFailure ? failure.message : 'Unknown error',
      )),
      (updatedProduct) => emit(ProductUpdatedSuccess(updatedProduct)),
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(ProductLoading());

    final result = await repo.deleteProduct(productId);

    result.fold(
      (failure) => emit(ProductFailure(
        failure is ServerFailure ? failure.message : 'Unknown error',
      )),
      (_) => emit(ProductDeletedSuccess()),
    );
  }
}
