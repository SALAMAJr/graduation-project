import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ✅ استيراد Hive Flutter

import 'package:furniswap/core/injection/setup_dependencies.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/presentation/manager/cubit/login_cubit.dart';
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

  // ✅ تهيئة Hive وفتح الـ Box
  await Hive.initFlutter(); // مهم جدًا
  await Hive.openBox('authBox'); // افتح البوكس اللي هنستخدمه

  // ✅ تهيئة Dependencies
  setupDependencies();

  // ✅ تسجيل الـ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ طباعة الـ FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('✅ FCM Token: $fcmToken');

  // ✅ استقبال الرسائل في foreground
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🚀 App opened from Notification: ${message.notification?.title}");
  });

  runApp(MyApp(
    authRepo: getIt<AuthRepo>(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepo authRepo;

  const MyApp({
    super.key,
    required this.authRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(authRepo)),
        BlocProvider(
          create: (context) => LoginCubit(
            getIt<AuthRepo>(),
            getIt<ChatRepo>(),
          ),
        ),
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
