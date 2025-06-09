import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// API Services
import 'package:furniswap/data/api_services/api_service.dart';

// Repositories
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/auth_repoImpl.dart';
import 'package:furniswap/data/repository/createproducts/homeRepo.dart';
import 'package:furniswap/data/repository/createproducts/HomeRepoImpl.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/data/repository/createproducts/ProductRepoImpl.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepo.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepoImpl.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo_impl.dart';
import 'package:furniswap/data/repository/review/reviewRepo.dart';
import 'package:furniswap/data/repository/review/reviewRepoImpl.dart';
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
import 'package:furniswap/presentation/manager/homeCubit/home_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/create_review_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // 1. Dio & ApiService
  final dio = Dio();
  final apiService = ApiService(dio);

  // 2. Register ApiService (ده الأساس لأي REST repo)
  getIt.registerLazySingleton<ApiService>(() => apiService);

  // 3. Register كل الـ repositories اللي محتاجة ApiService
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(apiService));
  getIt.registerLazySingleton<UserRepo>(() => UserRepoImpl(apiService));
  getIt.registerLazySingleton<ProductSearchRepo>(
      () => ProductSearchRepoImpl(apiService));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(apiService));
  getIt.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(apiService));

  // 4. Register الـ SocketService (واحد بس دايمًا)
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());

  // 5. Register الـ ChatRepoImpl (بياخد ApiService و SocketService)
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<ApiService>(), getIt<SocketService>()));

  // 6. Register كل الـ cubits
  getIt.registerFactory<ProductCubit>(() => ProductCubit(getIt<ProductRepo>()));
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepo>()));
  getIt.registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(getIt<AuthRepo>()));
  getIt.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(getIt<AuthRepo>()));
  getIt.registerFactory<ProductSearchCubit>(
      () => ProductSearchCubit(getIt<ProductSearchRepo>()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));
  getIt.registerFactory<CreateReviewCubit>(
      () => CreateReviewCubit(getIt<ReviewRepo>()));
  getIt
      .registerFactory<ChatsListCubit>(() => ChatsListCubit(getIt<ChatRepo>()));
}
