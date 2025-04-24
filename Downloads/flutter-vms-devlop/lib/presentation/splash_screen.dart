import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

import '../routes/pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    try {
      final bool isLoggedIn = await _authService.isLoggedIn();
      if (!mounted) return;
      
      if (isLoggedIn) {
        Get.offAndToNamed(AppScreens.home);
      } else {
        Get.offAndToNamed(AppScreens.login);
      }
    } catch (e) {
      if (!mounted) return;
      Get.offAndToNamed(AppScreens.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashbg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with fade-in animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 0),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/moksalogo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            // Loading indicator with fade-in animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
