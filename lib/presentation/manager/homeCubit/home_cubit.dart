import 'package:bloc/bloc.dart';

import 'package:furniswap/data/models/createproduct/HomeModel%20.dart';
import 'package:furniswap/data/repository/createproducts/homeRepo.dart';

import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(const HomeInitial());

  Future<void> fetchHomeProducts({int page = 1, int limit = 10}) async {
    emit(const HomeLoading());
    print("⏳ Starting to fetch home products...");
    final result = await homeRepo.getHomeProducts(page: page, limit: limit);

    result.fold(
      (failure) {
        print("💥 HomeCubit error: ${failure}");
        emit(HomeError("حدث خطأ غير متوقع"));
      },
      (products) {
        print("✅ HomeCubit fetched ${products.length} products!");
        emit(HomeLoaded(products));
      },
    );
  }
}
