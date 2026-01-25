import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiService {
  final Dio _dio = Dio();

  // 🔗 ลิงก์ Gist ของคุณ
  final String myApiUrl = 'https://gist.githubusercontent.com/MarkCnw/126da4dbaf4cc387c3e9c01cbd281b3a/raw/81032daf2c0c6c3a7a772ae4f257733c1507bbcb/tips.json';

  List<String> _healingQuotes = [];
  List<String> _damageQuotes = [];

  ApiService() {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
  }

  // 📥 ฟังก์ชันโหลดข้อมูล (Reactions)
  Future<void> _fetchData() async {
    try {
      final response = await _dio.get(myApiUrl);
      
      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        final Map<String, dynamic> jsonData = rawData is String ? jsonDecode(rawData) : rawData;

        if (jsonData.containsKey('reactions')) {
          final reactions = jsonData['reactions'];
          _healingQuotes = List<String>.from(reactions['healing'] ?? []);
          _damageQuotes = List<String>.from(reactions['damaging'] ?? []);
        }
      }
    } catch (e) {
      print("Error fetching API: $e");
    }
  }

  // 🗣️ ฟังก์ชันขอคำพูดกวนๆ
  Future<String> getReaction(bool isHealing) async {
    if (_healingQuotes.isEmpty || _damageQuotes.isEmpty) {
      await _fetchData();
    }

    final list = isHealing ? _healingQuotes : _damageQuotes;
    
    if (list.isNotEmpty) {
      return list[Random().nextInt(list.length)];
    }
    
    return isHealing ? "ขอบคุณนะ! 💚" : "มันร้อนนะ! 🔥";
  }
}