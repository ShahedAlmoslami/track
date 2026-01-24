import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/log_in_screen.dart';
import 'package:track/presentaion/screen/sign_up_screen.dart';
import 'package:track/presentaion/screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goNext(); // ✅ لازم نستدعيها
  }

  Future<void> goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  LogInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.prymaryColor,
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
