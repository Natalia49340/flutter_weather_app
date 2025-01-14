class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final int sunrise; // Dodajemy pole sunrise
  final int sunset;  // Dodajemy pole sunset

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'], // Dodano ikonę
      sunrise: json['sys']['sunrise'], // Pobieramy czas wschodu
      sunset: json['sys']['sunset'],   // Pobieramy czas zachodu
    );
  }
}
