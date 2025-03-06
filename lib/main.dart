import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(BookeeperApp());
}

class BookeeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blue, // Color of selected tab text
          unselectedLabelColor: Colors.black54, // Color of unselected tab text
          indicator: BoxDecoration(
            color: Colors.white, // White background for tabs
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
