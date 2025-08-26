import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AppValidator {
  static String? validatefield(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required'.tr;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required'.tr;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters'.tr;
    }
    return null;
  }
}
