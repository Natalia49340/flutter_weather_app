import 'package:flutter/material.dart';

class WeatherMapPage extends StatelessWidget {
  const WeatherMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa pogodowa')),
      body: const Center(
        child: Text(
          'Zobacz mapę pogody na żywo!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
