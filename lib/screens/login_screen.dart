import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:good_doctor_app/provider/app_provider.dart';
import 'package:good_doctor_app/service/localization_servies.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  Future<void> getwidgetFunction() async {
    final authprovider = context.read<AppProvider>();
    await authprovider.logIn(
      context,
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
    );
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
                      children: [
                        Text(
                          'Log In'.tr,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5DB3A8),
                          ),
                        ),
                        TextFormField(
                          controller: _emailcontroller,
                          decoration: InputDecoration(
                            labelText: 'Email'.tr,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5DB3A8)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password'.tr,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5DB3A8)),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff5DB3A8),
                          ),
                          onPressed: () async => await getwidgetFunction(),
                          child: Text(
                            'Login'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'If you aren\'t registered ?'.tr,
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
                            AppRouteName.registerscreen,
                          ),
                          child: Text(
                            'Register Now'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
