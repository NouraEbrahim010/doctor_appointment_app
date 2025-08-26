import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_doctor_app/models/users_model.dart';

class AuthServies {
  static AuthServies instance = AuthServies._internal();
  final FirebaseAuth _fireBaseInstance = FirebaseAuth.instance;
  late UserCredential _currentUser;
  UsersModel? userData;
  AuthServies._internal();
  Future<void> rgisterUser({
    required String email,
    required String password,
  }) async {
    try {
      _currentUser = await _fireBaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error Happen in Firebase Servive at register uesr mathod: $e ');
      rethrow;
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      _currentUser = await _fireBaseInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error Happen in Firebase Servive at log in uesr mathod: $e ');
      rethrow;
    }
  }

  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Logging out user: ${user.uid}');
    } else {
      print('No user is logged in');
    }
    await FirebaseAuth.instance.signOut();
  }

  UserCredential get currentUser => _currentUser;
  User? get user => _fireBaseInstance.currentUser;
  bool get isAuthenticatedBefore => _fireBaseInstance.currentUser != null;
}
