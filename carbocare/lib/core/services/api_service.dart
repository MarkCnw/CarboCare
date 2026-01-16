// lib/core/services/api_service.dart

import 'dart:io';
import 'dart:math';
import 'dart:convert'; // ✅ สำคัญ
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Bypass SSL เพื่อ Emulator
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  Future<String> getDailyTip() async {
    try {
      final String myApiUrl =
          'https://gist.githubusercontent.com/MarkCnw/126da4dbaf4cc387c3e9c01cbd281b3a/raw/4296a7cb7880f953285debb69a66eb3a23e6a693/tips.json';

      final response = await _dio.get(myApiUrl);

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;

        // ✅ แปลงให้เป็น Map เสมอ
        final Map<String, dynamic> jsonData =
            rawData is String ? jsonDecode(rawData) : rawData;

        final List<dynamic> tipsList = jsonData['tips'];

        final random = Random();
        return tipsList[random.nextInt(tipsList.length)];
      }

      return "รักษ์โลก เริ่มที่ตัวเรา 🌍";
    } catch (e) {
      print("API Error: $e");
      return "การเดินทางพันลี้ เริ่มต้นที่ก้าวแรก 🚶‍♂️";
    }
  }
}
