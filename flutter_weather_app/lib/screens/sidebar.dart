import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final List<String> favoriteCities;

  const Sidebar({super.key, required this.favoriteCities});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...favoriteCities.map((city) {
            return ListTile(
              title: Text(city),
              onTap: () {
                // Tutaj dodamy kod do załadowania pogody dla danego miasta
                Navigator.pop(context); // Zamknięcie panelu
              },
            );
          })
        ],
      ),
    );
  }
}
