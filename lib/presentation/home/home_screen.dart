import 'package:flutter/material.dart';
import '../news/news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final screens = const [
    NewsScreen(key: ValueKey('Top'), type: 'Top'),
    NewsScreen(key: ValueKey('New'), type: 'New'),
    NewsScreen(key: ValueKey('Best'), type: 'Best'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.trending_up), label: 'Top'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'New'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Best'),
        ],
      ),
    );
  }
}