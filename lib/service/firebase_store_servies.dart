import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_doctor_app/models/users_model.dart';

class FirestoreService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userType;
  Future<void> addUser({
    String? userId,
    String? email,
    String? firstname,
    String? secondname,
    String? type,
    String? doctorSpecialization,
    String? medicalRecord,
    String? medicalMedicineTaken,
  }) async {
    {
      final Map<String, dynamic> userData = {
        'firstname': firstname,
        'secondname': secondname,
        'email': email,
        'type': type,
      };

      if (type == 'doctor') {
        userData['doctorSpecialization'] = doctorSpecialization ?? '';
      } else if (type == 'patient') {
        userData['medicalRecord'] = medicalRecord ?? '';
        userData['medicalMedicineTaken'] = medicalMedicineTaken ?? '';
      }

      await _firebase.collection('Users').doc(userId).set(userData);
    }
  }

  Future<UsersModel?> getCurrentUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final doc = await _firebase.collection('Users').doc(userId).get();
    if (doc.exists) {
      return UsersModel.fromJson(doc.data()!);
    } else {
      print('No user data found for ID: $userId');
      return null;
    }
  }
}
