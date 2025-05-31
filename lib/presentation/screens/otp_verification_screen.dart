import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/screens/login_screen.dart';
import 'package:furniswap/presentation/manager/cubit/sign_up_cubit.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  void _submitOtp(BuildContext context) {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return;
    }

    context.read<SignUpCubit>().verifyOtp(
          email: widget.email,
          otp: otp,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F2EB),
        elevation: 0,
      ),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is OtpVerifiedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A3419),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Enter the 6-digit code sent to",
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xff8B7355)),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff4A3419),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                    filled: true,
                    fillColor: Colors.white,
                    counterText: "",
                    prefixIcon: const Icon(Icons.security),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffE8E0D5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffE8E0D5)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                state is SignUpLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _submitOtp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff694A38),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
