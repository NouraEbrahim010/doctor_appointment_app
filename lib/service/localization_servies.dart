import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationServices extends GetxController {
  static Locale currentLocale = Locale('en');
  static void toggleLanguage() {
    if (currentLocale.languageCode == 'en') {
      currentLocale = Locale('ar');
    } else {
      currentLocale = Locale('en');
    }
    box.write('lang', currentLocale.languageCode);
    Get.updateLocale(currentLocale);
  }

  static final box = GetStorage();
  static Locale get initialLocale {
    final langCode = box.read('lang') ?? 'en';
    return Locale(langCode);
  }
}
