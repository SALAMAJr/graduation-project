import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/presentation/manager/cubit/product_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:furniswap/core/injection/setup_dependencies.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/presentation/manager/cubit/login_cubit.dart';
import 'package:furniswap/presentation/manager/cubit/sign_up_cubit.dart';
import 'package:furniswap/presentation/screens/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('💤 Background Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  setupDependencies();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('✅ FCM Token: $fcmToken');

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🚀 App opened from Notification: ${message.notification?.title}");
  });

  runApp(MyApp(
    authRepo: getIt<AuthRepo>(),
    productRepo: getIt<ProductRepo>(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepo authRepo;
  final ProductRepo productRepo;

  const MyApp({
    super.key,
    required this.authRepo,
    required this.productRepo,
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
        BlocProvider(
          create: (_) => ProductCubit(productRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Furni Swap',
        theme: ThemeData(
          fontFamily: "pop",
          splashColor: Colors.brown.withAlpha(25),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.brown.withAlpha(25)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.brown.withAlpha(25)),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.brown.withAlpha(25)),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            splashColor: Colors.brown.withAlpha(25),
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.black12,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
