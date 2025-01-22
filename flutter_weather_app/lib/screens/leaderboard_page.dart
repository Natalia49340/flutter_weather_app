import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  
  final List<Map<String, dynamic>> scores = [
    {'name': 'Ania', 'points': 120},
    {'name': 'Kamil', 'points': 90},
    {'name': 'Zosia', 'points': 75},
  ];
  final List<String> friends = ['Ania', 'Kamil', 'Zosia', 'Michał', 'Ola'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Liczba zakładek
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tablica wyników'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.leaderboard), text: 'Wyniki'),
              Tab(icon: Icon(Icons.group), text: 'Znajomi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaderboardTab(),
            _buildFriendsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final user = scores[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          elevation: 5.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                user['name'][0], // Inicjał użytkownika
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user['name'], style: const TextStyle(fontSize: 18)),
            trailing: Text(
              '${user['points']} pkt',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildFriendsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          elevation: 5.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.greenAccent,
              child: Text(
                friend[0], // Inicjał znajomego
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(friend, style: const TextStyle(fontSize: 18)),
          ),
        );
      },
    );
  }
}
