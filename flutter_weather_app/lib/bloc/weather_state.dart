import '../models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}



abstract class FavoriteCitiesState {}

class FavoriteCitiesInitial extends FavoriteCitiesState {}

class FavoriteCitiesLoading extends FavoriteCitiesState {}

class FavoriteCitiesLoaded extends FavoriteCitiesState {
  final List<String> cities;
  FavoriteCitiesLoaded(this.cities);
}

class FavoriteCitiesError extends FavoriteCitiesState {
  final String message;
  FavoriteCitiesError(this.message);
}


