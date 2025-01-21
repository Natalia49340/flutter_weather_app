class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  // Suggested activity based on the temperature
  String get suggestedActivity {
    if (temperature > 30) {
      return 'Jest gorąco na zewnątrz! Co powiesz na pływanie?';
    } else if (temperature > 20) {
      return 'Idealna pogoda na spacer lub bieganie w parku!';
    } else if (temperature > 10) {
      return 'Jest trochę chłodno. Dobry dzień na aktywność w pomieszczeniu lub spacer w kurtce.';
    } else {
      return 'Jest dość zimno! Może zostań w domu z gorącym napojem';
      
    }
  }
}
