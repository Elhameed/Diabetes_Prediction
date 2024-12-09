import 'package:flutter/material.dart';
import 'prediction_screen.dart';
import 'retrain_screen.dart';
import 'visualizations_screen.dart'; // Import the VisualizationsScreen

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthLens'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Implement settings functionality if necessary
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Add scrolling
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(
                context,
                icon: Icons.health_and_safety,
                iconColor: Colors.blue,
                title: 'Predict Diabetes',
                description: 'Enter patient data to predict the likelihood of diabetes.',
                buttonLabel: 'Start Prediction',
                buttonColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PredictionScreen()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildCard(
                context,
                icon: Icons.refresh,
                iconColor: Colors.green,
                title: 'Retrain Model',
                description: 'Use new data to improve model accuracy.',
                buttonLabel: 'Retrain Now',
                buttonColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RetrainScreen()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildCard(
                context,
                icon: Icons.bar_chart,
                iconColor: Colors.purple,
                title: 'Visualizations',
                description: 'Explore insightful visualizations of the dataset.',
                buttonLabel: 'View Visualizations',
                buttonColor: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisualizationsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String buttonLabel,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Container(
        width: double.infinity, // Make cards stretch to fill width
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 50),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonLabel,
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
