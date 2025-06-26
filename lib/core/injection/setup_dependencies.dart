import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

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

// 🔵 Import بتاع البحث بالصور
import 'package:furniswap/data/repository/imageSearch/ImageSearchRepo.dart';
import 'package:furniswap/data/repository/imageSearch/ImageSearchRepoImpl.dart';

// API Service
import 'package:furniswap/data/api_services/api_service.dart';

// Cubits
import 'package:furniswap/presentation/manager/productCubit/product_cubit.dart';
import 'package:furniswap/presentation/manager/userCubit/user_details_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/forgot_password_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_search_cubit.dart';
import 'package:furniswap/presentation/manager/homeCubit/home_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/create_review_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/getreviews_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/update_review_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/receiver_cubit.dart';
import 'package:furniswap/presentation/manager/sendmessage/cubit/chat_send_message_cubit.dart';
// 🔵 Cubit بتاع البحث بالصور
import 'package:furniswap/presentation/manager/imageSearch/cubit/image_search_cubit.dart';
// ✅ Cubit بتاع التصنيفات
import 'package:furniswap/presentation/manager/category/cubit/category_products_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Dio الأساسي بتاع كل حاجة بتاخد ApiService
  final dio = Dio();
  final apiService = ApiService(dio);

  // 1. Register ApiService
  getIt.registerLazySingleton<ApiService>(() => apiService);

  // 2. Register Repositories (اللي بياخدوا ApiService)
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(apiService));
  getIt.registerLazySingleton<UserRepo>(() => UserRepoImpl(apiService));
  getIt.registerLazySingleton<ProductSearchRepo>(
      () => ProductSearchRepoImpl(apiService));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(apiService));
  getIt.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(apiService));

  // ✅ Register CategoryProductsCubit بعد ما سجلنا ProductRepo فوقه
  getIt.registerFactory<CategoryProductsCubit>(
      () => CategoryProductsCubit(getIt<ProductRepo>()));

  // 3. SocketService
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());

  // 4. ChatRepo
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<ApiService>(), getIt<SocketService>()));

  // 🔵 Register ImageSearchRepo (لازم Dio مخصوص ليه لإنه مش معتمد على ApiService)
  getIt
      .registerLazySingleton<ImageSearchRepo>(() => ImageSearchRepoImpl(Dio()));

  // 5. Register Cubits (كلهم بياخدوا الريبو بتاعهم)
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
  getIt.registerFactory<GetUserReviewsCubit>(
      () => GetUserReviewsCubit(getIt<ReviewRepo>()));
  getIt.registerFactory<UpdateReviewCubit>(
      () => UpdateReviewCubit(getIt<ReviewRepo>()));
  getIt
      .registerFactory<ChatsListCubit>(() => ChatsListCubit(getIt<ChatRepo>()));
  getIt.registerFactory<ChatDetailsCubit>(
      () => ChatDetailsCubit(getIt<ChatRepo>()));
  getIt.registerFactory<ReceiverCubit>(() => ReceiverCubit(getIt<ChatRepo>()));
  getIt.registerFactory<ChatSendMessageCubit>(
      () => ChatSendMessageCubit(getIt<SocketService>()));

  // 🔵 Register ImageSearchCubit بعد ما الريبو بتاعه يتسجل فوق
  getIt.registerFactory<ImageSearchCubit>(
      () => ImageSearchCubit(getIt<ImageSearchRepo>()));
}
