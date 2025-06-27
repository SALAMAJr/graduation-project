import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:furniswap/core/globals.dart';
import 'package:furniswap/presentation/manager/category/cubit/category_products_cubit.dart';
import 'package:furniswap/presentation/manager/chatBot/cubit/chat_bot_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:furniswap/core/injection/setup_dependencies.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:furniswap/data/repository/createproducts/product_repo.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';

import 'package:furniswap/presentation/manager/ChatCubit/cubit/chat_details_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/chats_list_cubit.dart';
import 'package:furniswap/presentation/manager/ChatCubit/cubit/receiver_cubit.dart';
import 'package:furniswap/presentation/manager/homeCubit/home_cubit.dart';
import 'package:furniswap/presentation/manager/imageSearch/cubit/image_search_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_search_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/create_review_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/getreviews_cubit.dart';
import 'package:furniswap/presentation/manager/reviewCubit/cubit/update_review_cubit.dart';
import 'package:furniswap/presentation/manager/sendmessage/cubit/chat_send_message_cubit.dart';
import 'package:furniswap/presentation/manager/userCubit/user_details_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/sign_up_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/login_cubit.dart';
import 'package:furniswap/presentation/manager/productCubit/product_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/forgot_password_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/screens/splashScreen.dart';

import 'package:furniswap/core/notification/in_app_notification_provider.dart'; // Provider بتاع البانر

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
    getIt<SocketService>().connect();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('✅ FCM Token: $fcmToken');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🚀 App opened from Notification: ${message.notification?.title}");
    });

    // ChangeNotifierProvider هو اللي لافف كل MultiBlocProvider
    runApp(
      ChangeNotifierProvider(
        create: (_) => InAppNotificationProvider(),
        child: MyApp(),
      ),
    );
  } catch (e, stack) {
    print('❌ Exception in main(): $e');
    print(stack);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(getIt<AuthRepo>())),
        BlocProvider(
            create: (_) => LoginCubit(getIt<AuthRepo>(), getIt<ChatRepo>())),
        BlocProvider(create: (_) => ProductCubit(getIt<ProductRepo>())),
        BlocProvider(create: (_) => getIt<ForgotPasswordCubit>()),
        BlocProvider(create: (_) => getIt<ResetPasswordCubit>()),
        BlocProvider(create: (_) => getIt<UserCubit>()),
        BlocProvider(create: (_) => getIt<ProductSearchCubit>()),
        BlocProvider(
            create: (_) => getIt<CategoryProductsCubit>()), // 👈 ده الجديد

        BlocProvider(create: (_) => getIt<HomeCubit>()),
        BlocProvider(create: (_) => getIt<CreateReviewCubit>()),
        BlocProvider(create: (_) => getIt<ChatsListCubit>()),
        BlocProvider<ChatDetailsCubit>(
            create: (_) => getIt<ChatDetailsCubit>()),
        BlocProvider(create: (_) => getIt<GetUserReviewsCubit>()),
        BlocProvider(create: (_) => getIt<UpdateReviewCubit>()),
        BlocProvider(create: (_) => getIt<ReceiverCubit>()),
        BlocProvider(create: (_) => getIt<ChatSendMessageCubit>()),
        BlocProvider(create: (_) => getIt<ImageSearchCubit>()),
        BlocProvider<ChatBotCubit>(
          create: (_) => getIt<ChatBotCubit>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
        builder: (context, child) {
          // البانر يطلع فوق وصغير
          return Stack(
            children: [
              child!,
              Consumer<InAppNotificationProvider>(
                builder: (context, notifier, _) {
                  if (notifier.senderName != null) {
                    return Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (notifier.onTap != null) notifier.onTap!();
                            Future.delayed(const Duration(milliseconds: 350),
                                () {
                              if (context.mounted) notifier.clear();
                            });
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 340,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.brown[100],
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.withOpacity(0.09),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (notifier.imageUrl != null &&
                                      notifier.imageUrl!.isNotEmpty)
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(notifier.imageUrl!),
                                      radius: 16,
                                    ),
                                  if (notifier.imageUrl != null &&
                                      notifier.imageUrl!.isNotEmpty)
                                    const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notifier.senderName!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xff694A38)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          notifier.message!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Color(0xff694A38), size: 18),
                                    onPressed: notifier.clear,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
