import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  String? type;
  bool isLoading = true;
  String errorMessage = '';

  List<Map<String, dynamic>> allDoctors = [];
  List<String> bookedDoctorIds = [];
  List<Map<String, dynamic>> bookedPatients = [];
  Map<String, String> bookedDoctorStatuses = {};

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> loadData() async {
    final uid = currentUserId;
    if (uid == null) {
      errorMessage = 'User not logged in.';
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        errorMessage = 'User data not found.';
      } else {
        type = userDoc.data()!['type'];

        if (type == 'doctor') {
          await loadBookedPatients();
        } else if (type == 'patient') {
          await loadDoctorsAndAppointments();
        }

        errorMessage = '';
      }
    } catch (e) {
      errorMessage = 'Failed to load data: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadDoctorsAndAppointments() async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final doctorSnap = await FirebaseFirestore.instance
          .collection('Users')
          .where('type', isEqualTo: 'doctor')
          .get();

      allDoctors = doctorSnap.docs.map((doc) {
        final data = doc.data();
        data['usersId'] = doc.id;
        data['status'] = 'none';
        return data;
      }).toList();

      final appointSnap = await FirebaseFirestore.instance
          .collection('appointments')
          .where('patientId', isEqualTo: uid)
          .where(
            'status',
            whereIn: [
              'booked',
              'accepted',
              'cancelled_by_patient',
              'cancelled_by_doctor',
            ],
          )
          .get();

      bookedDoctorStatuses = {
        for (var doc in appointSnap.docs) doc['doctorId']: doc['status'],
      };

      bookedDoctorIds = bookedDoctorStatuses.keys.toList();

      for (var doctor in allDoctors) {
        final doctorId = doctor['usersId'];
        if (bookedDoctorStatuses.containsKey(doctorId)) {
          doctor['status'] = bookedDoctorStatuses[doctorId];
        }
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Error loading doctors: $e';
      notifyListeners();
    }
  }

  Future<void> loadBookedPatients() async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final appointSnap = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: uid)
          .where('status', whereIn: ['booked', 'accepted'])
          .get();

      bookedPatients = [];

      for (var doc in appointSnap.docs) {
        final patientId = doc['patientId'];
        final status = doc['status'];

        final patientDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(patientId)
            .get();

        final data = patientDoc.data();
        if (data != null) {
          data['usersId'] = patientDoc.id;
          data['appointmentStatus'] = status;
          bookedPatients.add(data);
        }
      }
    } catch (e) {
      errorMessage = 'Error loading patients: $e';
    }
  }

  Future<void> toggleAppointment(String doctorId) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final appointQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('patientId', isEqualTo: uid)
          .get();

      if (appointQuery.docs.isNotEmpty) {
        final currentStatus = appointQuery.docs.first['status'];

        if (currentStatus == 'booked' || currentStatus == 'accepted') {
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointQuery.docs.first.id)
              .update({'status': 'cancelled_by_patient'});
        } else if (currentStatus == 'cancelled_by_patient' ||
            currentStatus == 'cancelled_by_doctor') {
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointQuery.docs.first.id)
              .update({
                'status': 'booked',
                'timestamp': FieldValue.serverTimestamp(),
              });
        }
      } else {
        await FirebaseFirestore.instance.collection('appointments').add({
          'doctorId': doctorId,
          'patientId': uid,
          'status': 'booked',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      await loadDoctorsAndAppointments();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error toggling appointment: $e';
      notifyListeners();
    }
  }

  Future<void> cancelPatient(String patientId) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final appointQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: uid)
          .where('patientId', isEqualTo: patientId)
          .get();

      if (appointQuery.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointQuery.docs.first.id)
            .update({'status': 'cancelled_by_doctor'});
      }

      await loadBookedPatients();
      await loadDoctorsAndAppointments();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error canceling patient: $e';
      notifyListeners();
    }
  }

  Future<void> acceptPatient(String patientId) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final appointQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: uid)
          .where('patientId', isEqualTo: patientId)
          .get();

      if (appointQuery.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointQuery.docs.first.id)
            .update({'status': 'accepted'});
      }

      await loadBookedPatients();
      await loadDoctorsAndAppointments();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error accepting patient: $e';
      notifyListeners();
    }
  }

  void reset() {
    type = null;
    isLoading = true;
    errorMessage = '';

    allDoctors.clear();
    bookedDoctorIds.clear();
    bookedPatients.clear();

    notifyListeners();
  }
}
