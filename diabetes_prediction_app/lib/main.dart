import 'package:flutter/material.dart';
import 'home.dart';
import 'prediction_screen.dart';
import 'retrain_screen.dart';
import 'main_menu.dart'; 
import 'visualizations_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthLens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white, // Set global background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Home screen (starting point)
        '/prediction': (context) => PredictionScreen(), // Prediction screen
        '/retrain': (context) => RetrainScreen(), // Retraining screen
        '/main-menu': (context) => MainMenuScreen(), // Main menu screen 
        '/visualization': (context) => VisualizationsScreen(), // Visualization screen
      },
    );
  }
}
