import 'package:flutter/material.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:flutter_weather_app/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Testowanie API
  final apiService = ApiService();
  final weatherRepository = WeatherRepository(apiService);

  try {
    final weather = await weatherRepository.getWeather("London");
    print("City: ${weather.cityName}, Temp: ${weather.temperature}°C, Desc: ${weather.description}");
  } catch (e) {
    print("Error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Weather App")),
        body: Center(child: Text("Test")),
      ),
    );
  }
}
