import 'package:dio/dio.dart';
import 'package:furniswap/data/repository/createproducts/HomeRepoImpl.dart';
import 'package:furniswap/data/repository/createproducts/homeRepo.dart';
import 'package:furniswap/presentation/manager/homeCubit/home_cubit.dart';
import 'package:get_it/get_it.dart';

// API Services
import 'package:furniswap/data/api_services/api_service.dart';

// Repositories
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/auth_repoImpl.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/data/repository/createproducts/ProductRepoImpl.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepo.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepoImpl.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo_impl.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';
import 'package:furniswap/data/repository/socket/socket_service_impl.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo_impl.dart';

// Cubits
import 'package:furniswap/presentation/manager/productCubit/product_cubit.dart';
import 'package:furniswap/presentation/manager/userCubit/user_details_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/forgot_password_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_search_cubit.dart';
// HomeCubit (الجديد)

final getIt = GetIt.instance;

void setupDependencies() {
  // ✅ Dio & ApiService
  final dio = Dio();
  final apiService = ApiService(dio);

  // ✅ Register API-based Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(apiService));
  getIt.registerLazySingleton<UserRepo>(() => UserRepoImpl(apiService));
  getIt.registerLazySingleton<ProductSearchRepo>(
      () => ProductSearchRepoImpl(apiService));
  getIt.registerLazySingleton<HomeRepo>(
      () => HomeRepoImpl(apiService)); // << NEW

  // ✅ Register Socket & Chat Repos
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<SocketService>()));

  // ✅ Register Cubits
  getIt.registerFactory<ProductCubit>(() => ProductCubit(getIt<ProductRepo>()));
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepo>()));
  getIt.registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(getIt<AuthRepo>()));
  getIt.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(getIt<AuthRepo>()));
  getIt.registerFactory<ProductSearchCubit>(
      () => ProductSearchCubit(getIt<ProductSearchRepo>()));
  getIt
      .registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>())); // << NEW
}
