import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_event.dart';
import 'package:flutter_weather_app/bloc/weather_state.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController = TextEditingController();
  List<String> favoriteCities = [];
  int userPoints = 0;
final List<String> weatherChallenges = [
    "Tańcz w deszczu",
    "Zrób zdjęcie najpiękniejszej chmury, jaką dziś zobaczysz!",
    "Wybierz się na spacer, niezależnie od pogody!",
    "Spróbuj policzyć krople deszczu na szybie (przynajmniej przez minutę)!",
    "Przeczytaj książkę z pogodą w tytule!",
    "Poszukaj tęczy po deszczu"
  ];

  String? currentChallenge;

  @override
  void initState() {
    super.initState();
     _loadState();
    _generateNewChallenge();
  }


Future<void> _updatePoints(int points) async {
  setState(() {
    userPoints += points;
  });
}



Future<void> _loadState() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    final lastCity = prefs.getString('lastCity');
    if (lastCity != null) {
      context.read<WeatherBloc>().add(FetchWeather(lastCity));
    }
  });
}

Future<void> _saveState(String cityName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastCity', cityName);
}

Future<void> _saveFavoriteCities() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('favoriteCities', favoriteCities);
}

  void _generateNewChallenge() {
    final random = Random();
    setState(() {
      currentChallenge = weatherChallenges[random.nextInt(weatherChallenges.length)];
    });
  }


  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    setState(() {
      
    });
    await _updatePoints(10); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Zdjęcie przesłane! Zdobywasz 10 punktów!')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Aplikacja Pogodowa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getAppBarColor(context),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _onGeolocationPressed,
          ),
        ],
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
                    : [const Color.fromARGB(255, 86, 122, 140), Colors.white],
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
                      _buildChallengeWidget(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _generateNewChallenge,
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Nowe wyzwanie",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
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
                            _buildActivitySuggestion(state.weather),
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

  void _onGeolocationPressed() {}

  Color _getAppBarColor(BuildContext context) {
    final weatherState = context.watch<WeatherBloc>().state;
    if (weatherState is WeatherLoaded) {
      double temperature = weatherState.weather.temperature;
      return _getBackgroundColor(temperature);
    }
    return Colors.blueAccent;
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
            onPressed: () async {
              final cityName = cityController.text.trim();
              if (cityName.isNotEmpty) {
                await _saveState(cityName);
                context.read<WeatherBloc>().add(FetchWeather(cityName));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getButtonColor(context),
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
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Dzisiejsze Wyzwanie:',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentChallenge ?? "Brak wyzwań.",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 86, 122, 140),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Dodaj zdjęcie",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    final weatherState = context.watch<WeatherBloc>().state;
    if (weatherState is WeatherLoaded) {
      double temperature = weatherState.weather.temperature;
      if (temperature < 10) {
        return Colors.blue;
      } else if (temperature < 20) {
        return Colors.lightBlue;
      } else if (temperature < 30) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }
    return Colors.blueAccent;
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
        onPressed: () async {
          setState(() {
            favoriteCities.remove(city);
          });
          await _saveFavoriteCities();
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
              onPressed: () async {
                final newCity = cityController.text.trim();
                if (newCity.isNotEmpty && !favoriteCities.contains(newCity)) {
                  setState(() {
                    favoriteCities.add(newCity);
                  });
                  await _saveFavoriteCities();
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

  Widget _buildActivitySuggestion(Weather weather) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Propozycje aktywności:',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              weather.suggestedActivity,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
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