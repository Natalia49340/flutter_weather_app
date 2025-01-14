import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_event.dart';
import 'package:flutter_weather_app/bloc/weather_state.dart';
import 'package:flutter_weather_app/models/weather_model.dart';

class WeatherPage extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Favorite Cities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildCityListItem(context, 'Warsaw'),
            _buildCityListItem(context, 'London'),
            _buildCityListItem(context, 'New York'),
          ],
        ),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
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

        return Container(
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
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      state is WeatherLoaded ? state.weather.cityName : "Weather App",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          SizedBox(height: 20),
                          _buildHourlyForecastWidget(state.weather),
                          SizedBox(height: 10),
                          _buildFiveDayForecastWidget(state.weather),
                          SizedBox(height: 10),
                          _buildUVWidget(state.weather),
                          SizedBox(height: 10),
                          _buildHumidityWidget(state.weather),
                          SizedBox(height: 10),
                          _buildPressureWidget(state.weather),
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
            ),
          ),
        );
      }),
    );
  }

  ListTile _buildCityListItem(BuildContext context, String city) {
    return ListTile(
      title: Text(city),
      onTap: () {
        context.read<WeatherBloc>().add(FetchWeather(city));
        Navigator.pop(context);
      },
    );
  }

  Widget _buildHourlyForecastWidget(Weather weather) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          Text('Hourly Forecast', style: TextStyle(fontSize: 20)),
          Text('Hour: 1 - Temp: ${weather.temperature + 1}°C'),
          Text('Hour: 2 - Temp: ${weather.temperature + 2}°C'),
        ],
      ),
    );
  }

  Widget _buildFiveDayForecastWidget(Weather weather) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          Text('5-Day Forecast', style: TextStyle(fontSize: 20)),
          Text('Day 1 - Temp: ${weather.temperature + 2}°C'),
          Text('Day 2 - Temp: ${weather.temperature + 4}°C'),
          Text('Day 3 - Temp: ${weather.temperature + 5}°C'),
          Text('Day 4 - Temp: ${weather.temperature + 6}°C'),
          Text('Day 5 - Temp: ${weather.temperature + 7}°C'),
        ],
      ),
    );
  }

  Widget _buildUVWidget(Weather weather) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          Text('UV Index', style: TextStyle(fontSize: 20)),
          Text('UV: 5.2'),
        ],
      ),
    );
  }

  Widget _buildHumidityWidget(Weather weather) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          Text('Humidity', style: TextStyle(fontSize: 20)),
          Text('Humidity: 70%'),
        ],
      ),
    );
  }

  Widget _buildPressureWidget(Weather weather) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          Text('Pressure', style: TextStyle(fontSize: 20)),
          Text('Pressure: 1012 hPa'),
        ],
      ),
    );
  }
}
