import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:good_doctor_app/localization/tanslation.dart';
import 'package:good_doctor_app/provider/app_provider.dart';
import 'package:good_doctor_app/provider/home_provider.dart';
import 'package:good_doctor_app/service/localization_servies.dart';
import 'package:good_doctor_app/utils/app_route.dart';
import 'package:good_doctor_app/utils/app_route_name.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (context) => AppProvider()),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
      ],
      child: GetMaterialApp(
        translations: Language(),
        locale: LocalizationServices.initialLocale,
        initialRoute: AppRouteName.initialRouteKey,
        routes: AppRoute.routes,
      ),
    );
  }
}
