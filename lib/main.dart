import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/repository/auth_repoImpl.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/review/review_repo.dart';
import 'package:furniswap/data/repository/review/review_repo_impl.dart';
import 'package:furniswap/presentation/manager/cubit/login_cubit.dart';
import 'package:furniswap/presentation/manager/review/cubit/review_cubit.dart';
import 'package:furniswap/presentation/manager/signup/sign_up_cubit.dart';
import 'package:furniswap/presentation/screens/splash_screen.dart';

/// ✅ handler بيشتغل لما يجيلك إشعار والتطبيق مقفول
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('💤 Background Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Firebase
  await Firebase.initializeApp();

  // ✅ تسجيل الـ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ طباعة الـ FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('✅ FCM Token: $fcmToken');

  // ✅ استقبال الرسائل في foreground
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print("📩 Foreground Message: ${message.notification?.title}");
  // });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🚀 App opened from Notification: ${message.notification?.title}");
  });

  final dio = Dio();
  final apiService = ApiService(dio);
  final AuthRepo authRepo = AuthRepoImpl(apiService);
  final ReviewRepo reviewRepo = ReviewRepoImpl(apiService);

  runApp(MyApp(authRepo: authRepo, reviewRepo: reviewRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepo authRepo;
  final ReviewRepo reviewRepo;

  const MyApp({
    super.key,
    required this.authRepo,
    required this.reviewRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(authRepo)),
        BlocProvider(create: (_) => LoginCubit(authRepo)),
        BlocProvider(create: (_) => ReviewCubit(reviewRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Furni Swap',
        theme: ThemeData(
          fontFamily: "pop",
          splashColor: Colors.brown.withOpacity(0.1),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor:
                  WidgetStateProperty.all(Colors.brown.withOpacity(0.1)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor:
                  WidgetStateProperty.all(Colors.brown.withOpacity(0.1)),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              overlayColor:
                  WidgetStateProperty.all(Colors.brown.withOpacity(0.1)),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            splashColor: Colors.brown.withOpacity(0.1),
          ),
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.black12,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
