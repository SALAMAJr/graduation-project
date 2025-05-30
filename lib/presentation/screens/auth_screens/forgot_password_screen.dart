import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/auth_screens/login_screen.dart';
import 'package:furniswap/icons/icons.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F6F3),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F6F3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 25),
                child: Icon(
                  MyFlutterApp.sofa,
                  size: 35,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4A3B2A)),
                ),
              ),
              Text(
                "Enter your email to receive a password reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xff8B7355)),
              ),
              SizedBox(
                height: 25,
              ),
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: "Enter your email",
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xffE8E0D5), width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xffE8E0D5), width: 1)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Color(0xff694A38),
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(fontSize: 14, color: Color(0xff8B5E3C)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
