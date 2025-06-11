import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';
import 'package:furniswap/presentation/manager/homeCubit/home_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_search_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/create_review_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/getreviews_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/update_review_cubit.dart';
import 'package:furniswap/presentation/manager/userCubit/user_details_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:furniswap/core/injection/setup_dependencies.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/presentation/manager/authCubit/sign_up_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/login_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/forgot_password_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/screens/splashScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
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
  } catch (e, stack) {
    print('❌ Exception in main(): $e');
    print(stack);
  }
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
            create: (_) => LoginCubit(getIt<AuthRepo>(), getIt<ChatRepo>())),
        BlocProvider(create: (_) => ProductCubit(productRepo)),
        BlocProvider(create: (_) => getIt<ForgotPasswordCubit>()),
        BlocProvider(create: (_) => getIt<ResetPasswordCubit>()),
        BlocProvider(create: (_) => getIt<UserCubit>()),
        BlocProvider(create: (_) => getIt<ProductSearchCubit>()),
        BlocProvider(create: (_) => getIt<HomeCubit>()),
        BlocProvider(create: (_) => getIt<CreateReviewCubit>()),
        BlocProvider(create: (_) => getIt<ChatsListCubit>()),
        BlocProvider<ChatDetailsCubit>(
            create: (_) => getIt<ChatDetailsCubit>()),
        BlocProvider(create: (_) => getIt<GetUserReviewsCubit>()),
        BlocProvider(create: (_) => getIt<UpdateReviewCubit>()),
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
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            splashColor: Colors.brown,
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
