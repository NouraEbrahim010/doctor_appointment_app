import 'package:flutter/widgets.dart';
import 'package:good_doctor_app/screens/home_screen.dart';
import 'package:good_doctor_app/screens/login_screen.dart';
import 'package:good_doctor_app/screens/register_screen.dart';
import 'package:good_doctor_app/screens/welcome_screen.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';

class AppRoute {
  static Map<String, Widget Function(BuildContext context)> routes = {
    AppRouteName.initialRouteKey: (context) => WelcomeScreen(),
    AppRouteName.loginscreen: (context) => LoginScreen(),
    AppRouteName.registerscreen: (context) => RegisterScreen(),
    AppRouteName.homeappscreen: (context) => HomeAppScreen(),
  };
}
