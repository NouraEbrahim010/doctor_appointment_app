import 'package:flutter/widgets.dart';

class AppSize {
  static double getAppWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getAppHeigh(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getwidgetWidth(
    BuildContext context, {
    double screenPercent = 1,
  }) {
    return getAppWidth(context) * screenPercent;
  }

  static double getwidgetHight(
    BuildContext context, {
    double screenPercent = 1,
  }) {
    return getAppHeigh(context) * screenPercent;
  }
}
