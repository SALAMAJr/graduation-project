import 'package:dio/dio.dart';
import 'package:furniswap/data/repository/createproducts/ProductRepoImpl.dart';
import 'package:get_it/get_it.dart';

import 'package:furniswap/core/network/socket_service.dart';
import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/auth_repoImpl.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo_impl.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/data/socket/socket_service_impl.dart';
import 'package:furniswap/presentation/manager/cubit/product_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // ✅ Dio & ApiService
  final dio = Dio();
  final apiService = ApiService(dio);

  // ✅ Register ApiService dependencies
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));
  getIt.registerLazySingleton<ProductRepo>(
      () => ProductRepoImpl(apiService)); // ✅ هنا الإضافة

  // ✅ Socket
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<SocketService>()));

  // ✅ Cubits
  getIt.registerFactory<ProductCubit>(() => ProductCubit(getIt<ProductRepo>()));
}
