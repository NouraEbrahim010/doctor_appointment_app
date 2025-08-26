import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_doctor_app/service/auth_servies.dart';
import 'package:good_doctor_app/service/firebase_store_servies.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirestoreService _firebasestorage = FirestoreService();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (AuthServies.instance.isAuthenticatedBefore) {
        _firebasestorage.getCurrentUserData().then((value) {
          AuthServies.instance.userData = value;
          Navigator.pushReplacementNamed(context, AppRouteName.homeappscreen);
        });
      } else {
        Navigator.pushReplacementNamed(context, AppRouteName.loginscreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4EB8A3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 150, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Welcome to Good Doctor App'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your health, our priority'.tr,
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
