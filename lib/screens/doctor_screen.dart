import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:good_doctor_app/provider/app_provider.dart';
import 'package:good_doctor_app/provider/home_provider.dart';
import 'package:good_doctor_app/service/auth_servies.dart';
import 'package:good_doctor_app/service/localization_servies.dart';
import 'package:provider/provider.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff5DB3A8),
        title: Text(
          '${'Hi Dr.'.tr} ${AuthServies.instance.userData!.firstname} ${AuthServies.instance.userData!.secondname}',
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
                  //               Provider.of<HomeProvider>(context, listen: false).reset();
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
          if (value.bookedPatients.isEmpty) {
            return const Center(child: Text("No patients booked yet."));
          }

          return ListView.builder(
            itemCount: value.bookedPatients.length,
            itemBuilder: (context, index) {
              final patient = value.bookedPatients[index];
              final status = patient['appointmentStatus'];
              return Card(
                color: Color(0xff5DB3A8),
                child: ListTile(
                  title: Text(
                    "${patient['firstname']} ${patient['secondname']}",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medical Record:'.tr + (patient['medicalRecord'] ?? ''),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        'Medicine Taken:'.tr +
                            (patient['medicalMedicineTaken'] ?? ''),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${'Status:'.tr} ${status.toString().toUpperCase()}',
                        style: TextStyle(
                          color: status == 'accepted'
                              ? Colors.green
                              : status == 'cancelled'
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: patient['appointmentStatus'] == 'booked'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => Provider.of<HomeProvider>(
                                context,
                                listen: false,
                              ).acceptPatient(patient['usersId']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text(
                                'Accept'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => Provider.of<HomeProvider>(
                                context,
                                listen: false,
                              ).cancelPatient(patient['usersId']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Cancel'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        )
                      : patient['appointmentStatus'] == 'accepted'
                      ? Text(
                          'Accepted'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      : Text(
                          'Cancelled'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
