import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/core/errors/failures.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final ProductRepo repo;

  CategoryProductsCubit(this.repo) : super(CategoryProductsInitial());

  Future<void> fetchByCategory(String category) async {
    try {
      emit(CategoryProductsLoading());
      print("🔄 Fetching products for category: $category");

      final result = await repo.getMyProducts();

      result.fold(
        (failure) {
          final errorMessage = _getFailureMessage(failure);
          print("❌ Failed to fetch products: $errorMessage");
          emit(CategoryProductsError(message: errorMessage));
        },
        (products) {
          for (var p in products) {
            print("🧾 ${p.name} → category: ${p.category}");
          }

          final filtered = category.toLowerCase() == "all items"
              ? products
              : products.where((p) {
                  final productCategory = (p.category ?? "").toLowerCase();
                  return productCategory == category.toLowerCase();
                }).toList();

          print("✅ Found ${filtered.length} products for category $category");
          emit(CategoryProductsLoaded(products: filtered));
        },
      );
    } catch (e, stack) {
      print("❌ Unknown error during category fetch: $e");
      print(stack);
      emit(CategoryProductsError(message: "خطأ غير متوقع أثناء جلب البيانات"));
    }
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return failure.message;
    if (failure is UnknownFailure) return failure.message;
    return "حدث خطأ غير متوقع";
  }
}
