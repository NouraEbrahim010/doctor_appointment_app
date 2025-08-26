import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:good_doctor_app/models/users_model.dart';
import 'package:good_doctor_app/provider/home_provider.dart';
import 'package:good_doctor_app/service/auth_servies.dart';
import 'package:good_doctor_app/service/firebase_store_servies.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';
import 'package:good_doctor_app/utils/screen_state.dart';
import 'package:provider/provider.dart';

class AppProvider with ChangeNotifier {
  RegisterState state = RegisterState.register;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  String errorMessage = '';
  String? currentUserId;
  UsersModel? userData;
  String? userType;

  List<String> bookedDoctorIds = [];
  Future<void> register(
    BuildContext context, {
    required String email,
    required String password,
    required String firstname,
    required String secondname,
    required String type,
    required String doctorSpecialization,
    required String medicalRecord,
    required String medicalMedicineTaken,
  }) async {
    try {
      state = RegisterState.loading;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUserId = userCredential.user?.uid;

      if (currentUserId != null) {
        await _firestoreService.addUser(
          userId: currentUserId!,
          email: email,
          firstname: firstname,
          secondname: secondname,
          type: type,
          doctorSpecialization: doctorSpecialization,
          medicalRecord: medicalRecord,
          medicalMedicineTaken: medicalMedicineTaken,
        );
        AuthServies.instance.userData = await _firestoreService
            .getCurrentUserData();
        print('User data loaded: ${AuthServies.instance.userData}');
      }

      state = RegisterState.alreadyLoggedIn;
      notifyListeners();

      Provider.of<HomeProvider>(context, listen: false).reset();
      await Provider.of<HomeProvider>(context, listen: false).loadData();
      Navigator.pushReplacementNamed(context, AppRouteName.homeappscreen);
    } catch (e) {
      errorMessage = e.toString();
      state = RegisterState.error;
      Get.snackbar(
        'Register Error',
        "Failed: $errorMessage",
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> logIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      state = RegisterState.loading;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      currentUserId = _auth.currentUser?.uid;

      AuthServies.instance.userData = await _firestoreService
          .getCurrentUserData();
      print('User data loaded: ${AuthServies.instance.userData}');

      state = RegisterState.alreadyLoggedIn;
      notifyListeners();

      Provider.of<HomeProvider>(context, listen: false).reset();
      await Provider.of<HomeProvider>(context, listen: false).loadData();
      Navigator.pushReplacementNamed(context, AppRouteName.homeappscreen);
    } catch (e) {
      errorMessage = e.toString();
      state = RegisterState.error;

      Get.snackbar(
        'Login Error',
        "Failed: $errorMessage",
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await AuthServies.instance.logout();
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacementNamed(context, AppRouteName.loginscreen);
      }
    } catch (e) {
      print('Error happened in logout: $e');
    }
    notifyListeners();
  }
}
