import 'package:flutter/material.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'leaderboard_page.dart'; 
import 'weather_map_page.dart'; 
import 'home.dart'; 

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, required WeatherRepository weatherRepository});

  @override
  // ignore: library_private_types_in_public_api
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WeatherPage(),
    const LeaderboardPage(),
    const WeatherMapPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Tablica wyników',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa pogodowa',
          ),
        ],
      ),
    );
  }
}
