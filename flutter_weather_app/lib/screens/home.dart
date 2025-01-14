import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_event.dart';
import 'package:flutter_weather_app/bloc/weather_state.dart';


class WeatherPage extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          Color getBackgroundColor(double temp) {
            if (temp < 10) {
              return Colors.blue;
            } else if (temp < 20) {
              return Colors.lightBlue;
            } else if (temp < 30) {
              return Colors.orange;
            } else {
              return Colors.red;
            }
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: state is WeatherLoaded
                      ? LinearGradient(
                          colors: [
                            getBackgroundColor(state.weather.temperature),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : LinearGradient(
                          colors: [Colors.blueGrey, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Weather App",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: "Enter city name",
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withAlpha(204),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final cityName = cityController.text.trim();
                        if (cityName.isNotEmpty) {
                          context.read<WeatherBloc>().add(FetchWeather(cityName));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text("Get Weather"),
                    ),
                    SizedBox(height: 20),
                    if (state is WeatherLoaded)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.weather.cityName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Image.network(
                            "https://openweathermap.org/img/wn/${state.weather.icon}@4x.png",
                            fit: BoxFit.cover,
),

                          Text(
                            "${state.weather.temperature}°C",
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            state.weather.description,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    if (state is WeatherLoading)
                      Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    if (state is WeatherError)
                      Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
