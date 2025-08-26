import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:good_doctor_app/provider/app_provider.dart';
import 'package:good_doctor_app/service/localization_servies.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';
import 'package:good_doctor_app/utils/app_validator.dart';
import 'package:good_doctor_app/utils/screen_state.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _medicalRecordController =
      TextEditingController();
  final TextEditingController _medicineTakenController =
      TextEditingController();
  final TextEditingController _doctorSpecializationController =
      TextEditingController();
  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();
    _medicalRecordController.dispose();
    _medicineTakenController.dispose();
    _doctorSpecializationController.dispose();
    super.dispose();
  }

  Future<void> getwidgetFunction(RegisterState state) async {
    final authprovider = context.read<AppProvider>();
    if (state == RegisterState.register) {
      await authprovider.register(
        context,
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
        firstname: _firstNameController.text,
        secondname: _secondNameController.text,
        type: selectedValue ?? 'patient',
        doctorSpecialization: _doctorSpecializationController.text,
        medicalRecord: _medicalRecordController.text,
        medicalMedicineTaken: _medicineTakenController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5DB3A8),
      appBar: AppBar(
        backgroundColor: Color(0xff5DB3A8),
        actions: [
          IconButton(
            onPressed: () => LocalizationServices.toggleLanguage(),
            icon: Icon(Icons.translate, color: Colors.white),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Good Doctor App'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Sign Up'.tr,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5DB3A8),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name'.tr,
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5DB3A8),
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  AppValidator.validatefield(value),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _secondNameController,
                              decoration: InputDecoration(
                                labelText: 'Second Name'.tr,
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5DB3A8),
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  AppValidator.validatefield(value),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _emailcontroller,
                              decoration: InputDecoration(
                                labelText: 'Email'.tr,
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5DB3A8),
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  AppValidator.validatefield(value),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _passwordcontroller,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password'.tr,
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5DB3A8),
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  AppValidator.validatePassword(value),
                            ),
                            SizedBox(height: 20),
                            FormField<String>(
                              validator: (value) {
                                if (selectedValue == null) {
                                  return 'Please select a type'.tr;
                                }
                                return null;
                              },
                              builder: (formFieldState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 160,
                                          child: ListTile(
                                            title: Text(
                                              'Doctor'.tr,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            leading: Radio<String>(
                                              activeColor: Color(0xff5DB3A8),
                                              value: "doctor",
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  formFieldState.didChange(
                                                    value,
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width: 160,
                                          child: ListTile(
                                            title: Text(
                                              'Patient'.tr,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            leading: Radio<String>(
                                              activeColor: Color(0xff5DB3A8),
                                              value: "patient",
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  formFieldState.didChange(
                                                    value,
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (formFieldState.hasError)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          formFieldState.errorText!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),

                            if (selectedValue == "patient") ...[
                              TextFormField(
                                controller: _medicalRecordController,
                                decoration: InputDecoration(
                                  labelText: 'Medical Record'.tr,
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff5DB3A8),
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    AppValidator.validatefield(value),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: _medicineTakenController,
                                decoration: InputDecoration(
                                  labelText: 'Medicine Taken'.tr,
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff5DB3A8),
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    AppValidator.validatefield(value),
                              ),
                            ] else if (selectedValue == "doctor") ...[
                              TextFormField(
                                controller: _doctorSpecializationController,
                                decoration: InputDecoration(
                                  labelText: 'Doctor Specialization'.tr,
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff5DB3A8),
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    AppValidator.validatefield(value),
                              ),
                            ],

                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff5DB3A8),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  value.state = RegisterState.register;
                                  await getwidgetFunction(value.state);
                                }
                              },
                              child: Text(
                                'Register'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              'If you are registered ?'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff5DB3A8),
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                AppRouteName.loginscreen,
                              ),
                              child: Text(
                                'Login Now'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
