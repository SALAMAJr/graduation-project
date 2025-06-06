import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/manager/authCubit/forgot_password_cubit.dart';
import 'package:furniswap/presentation/manager/authCubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/screens/ResetPasswordScreen.dart';
import 'package:furniswap/presentation/screens/loginScreen.dart';
import 'package:furniswap/core/injection/setup_dependencies.dart'; // ✅ مهم جداً

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F6F3),
        elevation: 0,
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ OTP sent to your email'),
                backgroundColor: Colors.green,
              ),
            );

            // ✅ التنقل بعد انتهاء الفريم
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                          value: context.read<ForgotPasswordCubit>()),
                      BlocProvider(
                          create: (_) => ResetPasswordCubit(
                              getIt())), // ✅ هنا استخدمنا getIt<AuthRepo>()
                    ],
                    child: ResetPasswordScreen(email: state.email),
                  ),
                ),
              );
            });
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Icon(MyFlutterApp.sofa, size: 35, color: Colors.black),
                  const SizedBox(height: 25),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4A3B2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your email to receive a password reset link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xff8B7355)),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintText: "Enter your email",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE8E0D5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE8E0D5)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  state is ForgotPasswordLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            final email = emailController.text.trim();
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your email"),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ForgotPasswordCubit>()
                                .sendOtp(email: email);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: const Color(0xff694A38),
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Send OTP",
                              style: TextStyle(color: Colors.white)),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(fontSize: 14, color: Color(0xff8B5E3C)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
