import 'package:dio/dio.dart';
import 'package:furniswap/data/repository/ChatBot/ChatBotRepo.dart';
import 'package:furniswap/data/repository/ChatBot/ChatBotRepoImpl.dart';
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
import 'package:furniswap/presentation/manager/imageSearch/cubit/image_search_cubit.dart';
import 'package:furniswap/presentation/manager/category/cubit/category_products_cubit.dart';
import 'package:furniswap/presentation/manager/chatBot/cubit/chat_bot_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  final dio = Dio();
  final apiService = ApiService(dio);

  // 🟢 API Service
  getIt.registerLazySingleton<ApiService>(() => apiService);

  // 🔵 Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(apiService));
  getIt.registerLazySingleton<UserRepo>(() => UserRepoImpl(apiService));
  getIt.registerLazySingleton<ProductSearchRepo>(
      () => ProductSearchRepoImpl(apiService));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(apiService));
  getIt.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(apiService));

  // ✅ Category Cubit
  getIt.registerFactory<CategoryProductsCubit>(
      () => CategoryProductsCubit(getIt<ProductRepo>()));

  // 🔌 Socket
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());

  // 💬 Chat between users
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<ApiService>(), getIt<SocketService>()));

  // 🔍 Image Search
  getIt
      .registerLazySingleton<ImageSearchRepo>(() => ImageSearchRepoImpl(Dio()));

  // 🧠 Chat Bot
  getIt.registerLazySingleton<ChatBotRepo>(() => ChatBotRepoImpl(Dio()));
  getIt.registerFactory<ChatBotCubit>(() => ChatBotCubit(getIt<ChatBotRepo>()));

  // 🟡 Cubits
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
  getIt.registerFactory<ImageSearchCubit>(
      () => ImageSearchCubit(getIt<ImageSearchRepo>()));
}
