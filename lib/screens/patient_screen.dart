import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:good_doctor_app/provider/app_provider.dart';
import 'package:good_doctor_app/provider/home_provider.dart';
import 'package:good_doctor_app/service/auth_servies.dart';
import 'package:good_doctor_app/service/localization_servies.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff5DB3A8),
        title: Text(
          '${'Hi Patient.'.tr} ${AuthServies.instance.userData!.firstname} ${AuthServies.instance.userData!.secondname}',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () => LocalizationServices.toggleLanguage(),
                icon: Icon(Icons.translate, color: Colors.white),
              ),
              IconButton(
                onPressed: () async {
                  //       Provider.of<HomeProvider>(context, listen: false).reset();
                  await Provider.of<AppProvider>(
                    context,
                    listen: false,
                  ).logout(context);
                },
                icon: Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          if (value.allDoctors.isEmpty) {
            return const Center(child: Text("No doctors available."));
          }

          return ListView.builder(
            itemCount: value.allDoctors.length,
            itemBuilder: (context, index) {
              final doctor = value.allDoctors[index];
              final doctorStatus =
                  value.bookedDoctorStatuses[doctor['usersId']];

              return Card(
                color: Color(0xff5DB3A8),
                child: ListTile(
                  title: Text(
                    '${doctor['firstname']} ${doctor['secondname']}',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  subtitle: Text(
                    'Specialization:'.tr +
                        (doctor['doctorSpecialization'] ?? ''),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => value.toggleAppointment(doctor['usersId']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doctorStatus == 'accepted'
                          ? Colors.green
                          : doctorStatus == 'booked'
                          ? Colors.red
                          : doctorStatus == 'cancelled_by_patient'
                          ? Colors.green
                          : doctorStatus == 'cancelled_by_doctor'
                          ? Colors.grey
                          : Colors.green,
                    ),
                    child: Text(
                      doctorStatus == 'accepted'
                          ? 'Accepted - Book Again'.tr
                          : doctorStatus == 'booked'
                          ? 'Cancel'.tr
                          : doctorStatus == 'cancelled_by_patient'
                          ? 'Book'.tr
                          : doctorStatus == 'cancelled_by_doctor'
                          ? 'Cancelled by Doctor - Book Again'.tr
                          : 'Book'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
