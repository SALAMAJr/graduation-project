import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/repository/auth_repoImpl.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo_impl.dart';
import 'package:furniswap/core/network/socket_service.dart';
import 'package:furniswap/data/socket/socket_service_impl.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // ✅ إنشاء Dio والـ ApiService
  final dio = Dio();
  final apiService = ApiService(dio);

  // ✅ تسجيل الـ AuthRepo
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(apiService));

  // ✅ تسجيل SocketService
  getIt.registerLazySingleton<SocketService>(() => SocketServiceImpl());

  // ✅ تسجيل ChatRepo باستخدام SocketService من getIt
  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(getIt<SocketService>()));
}
