import 'package:get/get.dart';
import 'package:good_doctor_app/localization/arabic_language.dart';
import 'package:good_doctor_app/localization/english_language.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {'en': englishMap, 'ar': arabicMap};
  }
}
