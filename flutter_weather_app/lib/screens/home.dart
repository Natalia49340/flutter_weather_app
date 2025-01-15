import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_event.dart';
import 'package:flutter_weather_app/bloc/weather_state.dart';
import 'package:flutter_weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController = TextEditingController();
  List<String> favoriteCities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Aplikacja Pogodowa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: const Text(
                'Ulubione Miasta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ...favoriteCities.map((city) => _buildCityListItem(city)),
            _buildAddCityButton(),
          ],
        ),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: state is WeatherLoaded
                    ? [
                        _getBackgroundColor(state.weather.temperature),
                        Colors.white,
                      ]
                    : [Colors.blueGrey, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildCityInputSection(context),
                      const SizedBox(height: 30),
                      if (state is WeatherLoading)
                        const CircularProgressIndicator(color: Colors.blueAccent),
                      if (state is WeatherError)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            state.message,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (state is WeatherLoaded)
                        Column(
                          children: [
                            _buildWeatherCard(state.weather),
                            _buildHourlyForecastWidget(state.weather),
                            _buildFiveDayForecastWidget(state.weather),
                            _buildUVWidget(state.weather),
                            _buildHumidityWidget(state.weather),
                            _buildPressureWidget(state.weather),
                            _buildWindWidget(state.weather),
                            _buildSunriseSunsetWidget(state.weather),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBackgroundColor(double temp) {
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

  Widget _buildCityInputSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(150),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: cityController,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.blueAccent,
              ),
              hintText: "Wpisz nazwę miasta",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final cityName = cityController.text.trim();
              if (cityName.isNotEmpty) {
                context.read<WeatherBloc>().add(FetchWeather(cityName));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Pobierz pogodę",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${weather.temperature.toStringAsFixed(0)}°C",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildCityListItem(String city) {
    return ListTile(
      title: Text(city),
      trailing: IconButton(
        icon: Icon(
          favoriteCities.contains(city) ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          setState(() {
            favoriteCities.remove(city);  // Usuwa miasto z listy
          });
        },
      ),
      onTap: () {
        context.read<WeatherBloc>().add(FetchWeather(city));
        Navigator.pop(context);
      },
    );
  }

  Widget _buildAddCityButton() {
    return ListTile(
      title: Text('Dodaj miasto'),
      onTap: _showAddCityDialog,
    );
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dodaj miasto"),
          content: TextField(
            controller: cityController,
            decoration: InputDecoration(hintText: "Wpisz nazwę miasta"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Anuluj"),
            ),
            TextButton(
              onPressed: () {
                final newCity = cityController.text.trim();
                if (newCity.isNotEmpty && !favoriteCities.contains(newCity)) {
                  setState(() {
                    favoriteCities.add(newCity);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Dodaj"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHourlyForecastWidget(Weather weather) {
    return _buildForecastCard(
      title: 'Prognoza godzinowa',
      forecasts: List.generate(5, (index) {
        return 'Godzina: ${index + 1} - Temp: ${(weather.temperature + index).toStringAsFixed(0)}°C';
      }),
    );
  }

  Widget _buildFiveDayForecastWidget(Weather weather) {
    return _buildForecastCard(
      title: 'Prognoza 5-dniowa',
      forecasts: List.generate(5, (index) {
        return 'Dzień ${index + 1} - Temp: ${(weather.temperature + index).toStringAsFixed(0)}°C';
      }),
    );
  }

  Widget _buildForecastCard({required String title, required List<String> forecasts}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            ...forecasts.map((forecast) => Row(
                  children: [
                    const Icon(Icons.cloud, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Text(forecast),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildUVWidget(Weather weather) {
    return _buildInfoCard('Indeks UV', 'UV: 5.2', Icons.sunny, Colors.orange);
  }

  Widget _buildHumidityWidget(Weather weather) {
    return _buildInfoCard('Wilgotność', 'Wilgotność: 65%', Icons.water_drop, Colors.blue);
  }

  Widget _buildPressureWidget(Weather weather) {
    return _buildInfoCard('Ciśnienie', 'Ciśnienie: 1015 hPa', Icons.alt_route, Colors.grey);
  }

  Widget _buildWindWidget(Weather weather) {
    return _buildInfoCard('Wiatr', 'Wiatr: 10 km/h', Icons.wind_power, Colors.blue);
  }

  Widget _buildSunriseSunsetWidget(Weather weather) {
    return _buildInfoCard(
        'Wschód i zachód słońca', 'Wschód: 6:30 AM, Zachód: 7:00 PM', Icons.wb_sunny, Colors.orange);
  }

  Widget _buildInfoCard(String title, String info, IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 10),
                Text(info),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
