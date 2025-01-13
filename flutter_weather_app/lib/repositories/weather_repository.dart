import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/services/api_service.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<Weather> getWeather(String cityName) async {
    final data = await apiService.fetchWeatherData(cityName);
    return Weather.fromJson(data);
  }
}
