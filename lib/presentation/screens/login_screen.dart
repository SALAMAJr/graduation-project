import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/screens/forgot_password_screen.dart';
import 'package:furniswap/presentation/screens/sign_up_screen.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/manager/cubit/login_cubit.dart';
import 'package:furniswap/presentation/screens/nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget buildTextFormField({
    required String label,
    required bool obscureText,
    required TextInputType type,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: type,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter $hintText' : null,
          decoration: InputDecoration(
            hintText: "Enter your $hintText",
            filled: true,
            fillColor: const Color(0xffF5F1EA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffE8E0D5), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffE8E0D5), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignUpWithButton(
      {required IconData icon, required String label}) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        side: const BorderSide(color: Color(0xffE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoginSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const NavScreen(initialIndex: 0)),
              (route) => false,
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
                  const SizedBox(height: 100),
                  const Text(
                    "Welcome to Furni Swap",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Login to your account",
                      style: TextStyle(fontSize: 16, color: Color(0xff6B7280))),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextFormField(
                          label: "Email address",
                          obscureText: false,
                          type: TextInputType.emailAddress,
                          hintText: "email",
                          controller: emailController,
                        ),
                        const SizedBox(height: 20),
                        buildTextFormField(
                          label: "Password",
                          obscureText: true,
                          type: TextInputType.visiblePassword,
                          hintText: "password",
                          controller: passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xff8B5E3C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        state is LoginLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submitLogin,
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  minimumSize: const Size(double.infinity, 48),
                                  backgroundColor: const Color(0xff694A38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Login",
                                    style: TextStyle(color: Colors.white)),
                              ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color: Color(0xffE5E7EB),
                                      thickness: 1.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                                child: Text("Or continue with",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff6B7280))),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: Color(0xffE5E7EB),
                                      thickness: 1.5)),
                            ],
                          ),
                        ),
                        Row(children: [
                          Expanded(
                              child: buildSignUpWithButton(
                                  icon: MyFlutterApp.google, label: "Google")),
                          const SizedBox(width: 10),
                          Expanded(
                              child: buildSignUpWithButton(
                                  icon: MyFlutterApp.facebook,
                                  label: "Facebook")),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                            );
                          },
                          child: const Text("Sign up",
                              style: TextStyle(color: Color(0xff8B5E3C))),
                        ),
                      ],
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
