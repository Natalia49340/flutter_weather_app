abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String cityName;

  FetchWeather(this.cityName);
}
class ResetWeather extends WeatherEvent {}


abstract class FavoriteCitiesEvent {}

class LoadFavoriteCities extends FavoriteCitiesEvent {}

class AddFavoriteCity extends FavoriteCitiesEvent {
  final String city;
  AddFavoriteCity(this.city);
}

class RemoveFavoriteCity extends FavoriteCitiesEvent {
  final String city;
  RemoveFavoriteCity(this.city);
}