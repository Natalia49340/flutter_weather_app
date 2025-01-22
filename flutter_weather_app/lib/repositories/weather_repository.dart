

import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<Weather> getWeather(String cityName) async {
    final data = await apiService.fetchWeatherData(cityName);
    return Weather.fromJson(data);
  }

  getWeatherByCoordinates(double latitude, double longitude) {}
}
