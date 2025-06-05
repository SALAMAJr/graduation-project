import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/createproduct/product_search_model.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo.dart';

part 'product_search_state.dart';

class ProductSearchCubit extends Cubit<ProductSearchState> {
  final ProductSearchRepo repo;

  ProductSearchCubit(this.repo) : super(ProductSearchInitial());

  int _page = 1;
  final int _limit = 10;
  bool _isLastPage = false;
  List<ProductSearchModel> _allProducts = [];
  String _lastQuery = '';

  void reset() {
    _page = 1;
    _isLastPage = false;
    _allProducts.clear();
    _lastQuery = '';
    emit(ProductSearchInitial());
  }

  Future<void> searchProducts(String query, {bool loadMore = false}) async {
    final trimmedQuery = query.trim();

    // ✅ Check for empty query
    if (trimmedQuery.isEmpty) {
      emit(ProductSearchFailure("Search query must not be empty."));
      return;
    }

    if (_isLastPage && loadMore) return;

    if (!loadMore) {
      reset();
      _lastQuery = trimmedQuery;
      emit(ProductSearchLoading());
    }

    final result = await repo.searchProducts(
      query: trimmedQuery,
      page: _page,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(ProductSearchFailure(
        failure is ServerFailure ? failure.message : 'Unknown error',
      )),
      (response) {
        final newProducts = response.products;
        _isLastPage = newProducts.length < _limit;
        _allProducts.addAll(newProducts);
        _page++;
        emit(ProductSearchSuccess(List.from(_allProducts)));
      },
    );
  }

  void loadNextPage() {
    if (!_isLastPage && _lastQuery.isNotEmpty) {
      searchProducts(_lastQuery, loadMore: true);
    }
  }
}
