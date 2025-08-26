// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class DioServies {
  final Dio _client = Dio();
  final String baseUrl = 'https://opentdb.com';
  Future<Response> get({required String endPoint, String? qparameters}) async {
    try {
      return await _client.get('$baseUrl$endPoint${qparameters ?? ''}');
    } catch (e) {
      print('------->Dio servies level$e<-------');
      rethrow;
    }
  }
}
