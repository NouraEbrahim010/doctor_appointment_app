import 'package:flutter/material.dart';
import 'package:good_doctor_app/screens/doctor_screen.dart';
import 'package:good_doctor_app/screens/patient_screen.dart';
import 'package:provider/provider.dart';
import 'package:good_doctor_app/provider/home_provider.dart';

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<HomeProvider>(context, listen: false).loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff5DB3A8)),
            ),
          );
        } else if (value.errorMessage.isNotEmpty) {
          return Scaffold(
            body: Center(
              child: Text(
                value.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else if (value.type == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'User type not defined.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        } else if (value.type == 'doctor') {
          return const DoctorScreen();
        } else {
          return const PatientScreen();
        }
      },
    );
  }
}
