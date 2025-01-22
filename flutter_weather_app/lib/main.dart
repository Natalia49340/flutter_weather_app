

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';
import 'repositories/weather_repository.dart';
import 'services/api_service.dart';
import 'screens/main_navigation_page.dart'; 



void main() {
  final apiService = ApiService();
  final weatherRepository = WeatherRepository(apiService);

  runApp(MyApp(weatherRepository: weatherRepository));
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const MyApp({super.key, required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => WeatherBloc(weatherRepository),
        child: MainNavigationPage(weatherRepository: weatherRepository),
      ),
    );
  }
}
