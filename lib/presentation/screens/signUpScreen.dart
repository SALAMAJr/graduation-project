import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/loginScreen.dart';
import 'package:furniswap/presentation/manager/authCubit/sign_up_cubit.dart';
import 'package:furniswap/presentation/screens/otpVerificationScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  Widget buildTextFormField({
    required bool obscureText,
    required TextInputType type,
    required IconData prefixIcon,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
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
        const SizedBox(height: 15),
      ],
    );
  }

  void submitSignUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final data = {
        "email": emailController.text.trim(),
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
      };

      context.read<SignUpCubit>().registerUser(data);
    }
  }

  Widget buildSignUpWithButton({
    required IconData icon,
    required String lable,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDED0C3)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(lable, style: const TextStyle(color: Color(0xff4A3419))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F2EB),
      appBar: AppBar(backgroundColor: const Color(0xffF5F2EB)),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.register.message ?? 'Success')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationScreen(email: state.register.email ?? ''),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4A3419)),
                    ),
                    const SizedBox(height: 30),
                    buildTextFormField(
                      controller: nameController,
                      obscureText: false,
                      type: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      hintText: "Full Name",
                    ),
                    buildTextFormField(
                      controller: emailController,
                      obscureText: false,
                      type: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      hintText: "Email",
                    ),
                    buildTextFormField(
                      controller: phoneController,
                      obscureText: false,
                      type: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      hintText: "Phone",
                    ),
                    buildTextFormField(
                      controller: passwordController,
                      obscureText: true,
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      hintText: "Password",
                    ),
                    state is SignUpLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => submitSignUp(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: const Color(0xff694A38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(color: Color(0xff8B7355))),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                  color: Color(0xff4A3419),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Text("Or sign up with",
                        style: TextStyle(color: Color(0xff8B7355))),
                    const SizedBox(height: 10),
                    buildSignUpWithButton(
                        icon: MyFlutterApp.google,
                        lable: "Continue with Google"),
                    const SizedBox(height: 10),
                    buildSignUpWithButton(
                        icon: MyFlutterApp.facebook,
                        lable: "Continue with Facebook"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
