import 'dart:convert';

import 'package:flutter_weather_app/utils/config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
