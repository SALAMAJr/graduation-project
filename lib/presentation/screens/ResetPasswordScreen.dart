import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/cubit/reset_password_cubit.dart';
import 'package:furniswap/presentation/screens/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;

  String get passwordStrength {
    final password = newPasswordController.text;
    if (password.length >= 8 &&
        RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Strong";
    }
    return "Weak";
  }

  Color get strengthColor =>
      passwordStrength == "Strong" ? Colors.green : Colors.red;
  double get strengthValue => passwordStrength == "Strong" ? 0.8 : 0.3;
  bool get hasLength => newPasswordController.text.length >= 8;
  bool get hasSymbols => RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
      .hasMatch(newPasswordController.text);

  @override
  Widget build(BuildContext context) {
    final email = widget.email; // ✅ استخدم الإيميل اللي جالك من فوق

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF9F6F3),
          appBar: AppBar(
            backgroundColor: const Color(0xffF9F6F3),
            elevation: 0,
            title: const Text("Reset Password",
                style: TextStyle(color: Colors.black)),
            leading: const BackButton(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create a new password to secure your account",
                  style: TextStyle(fontSize: 16, color: Color(0xff4A3B2A)),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("New Password",
                    style: TextStyle(color: Color(0xff4A3B2A))),
                const SizedBox(height: 8),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => obscureNew = !obscureNew),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Confirm New Password",
                    style: TextStyle(color: Color(0xff4A3B2A))),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    hintText: "Confirm new password",
                    suffixIcon: IconButton(
                      icon: Icon(obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Password Strength",
                        style: TextStyle(color: Color(0xff4A3B2A))),
                    Text(passwordStrength,
                        style: TextStyle(color: strengthColor)),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: strengthValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                  minHeight: 6,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(hasLength ? Icons.check_circle : Icons.cancel,
                        color: hasLength ? Colors.green : Colors.red, size: 18),
                    const SizedBox(width: 6),
                    const Text("At least 8 characters",
                        style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(hasSymbols ? Icons.check_circle : Icons.cancel,
                        color: hasSymbols ? Colors.green : Colors.red,
                        size: 18),
                    const SizedBox(width: 6),
                    const Text("Contains numbers and symbols",
                        style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 30),
                state is ResetPasswordLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          final otp = otpController.text.trim();
                          final newPass = newPasswordController.text.trim();
                          final confirmPass =
                              confirmPasswordController.text.trim();

                          if (otp.isEmpty ||
                              newPass.isEmpty ||
                              confirmPass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Passwords do not match")),
                            );
                            return;
                          }

                          context.read<ResetPasswordCubit>().resetPassword(
                                email: email,
                                otp: otp,
                                newPassword: newPass,
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff8B7355),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Reset Password",
                            style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
