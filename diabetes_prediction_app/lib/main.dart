import 'package:flutter/material.dart';
import 'api_service.dart';  // Import the API service

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ApiService apiService = ApiService(baseUrl: 'https://diabetes-prediction-gj1e.onrender.com');
  
  // Form inputs
  final _pregnanciesController = TextEditingController();
  final _glucoseController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _skinThicknessController = TextEditingController();
  final _insulinController = TextEditingController();
  final _bmiController = TextEditingController();
  final _diabetesPedigreeController = TextEditingController();
  final _ageController = TextEditingController();

  String prediction = '';
  String predictionProb = '';

  Future<void> _makePrediction() async {
    Map<String, dynamic> data = {
      "pregnancies": double.parse(_pregnanciesController.text),
      "glucose": double.parse(_glucoseController.text),
      "blood_pressure": double.parse(_bloodPressureController.text),
      "skin_thickness": double.parse(_skinThicknessController.text),
      "insulin": double.parse(_insulinController.text),
      "bmi": double.parse(_bmiController.text),
      "diabetes_pedigree_function": double.parse(_diabetesPedigreeController.text),
      "age": double.parse(_ageController.text),
    };

    try {
      var result = await apiService.makePrediction(data);
      setState(() {
        prediction = result['prediction'] == 1 ? 'Diabetes' : 'No Diabetes';
        predictionProb = result['prediction_probability'].toString();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diabetes Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(controller: _pregnanciesController, decoration: InputDecoration(labelText: 'Pregnancies')),
            TextField(controller: _glucoseController, decoration: InputDecoration(labelText: 'Glucose')),
            TextField(controller: _bloodPressureController, decoration: InputDecoration(labelText: 'Blood Pressure')),
            TextField(controller: _skinThicknessController, decoration: InputDecoration(labelText: 'Skin Thickness')),
            TextField(controller: _insulinController, decoration: InputDecoration(labelText: 'Insulin')),
            TextField(controller: _bmiController, decoration: InputDecoration(labelText: 'BMI')),
            TextField(controller: _diabetesPedigreeController, decoration: InputDecoration(labelText: 'Diabetes Pedigree Function')),
            TextField(controller: _ageController, decoration: InputDecoration(labelText: 'Age')),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makePrediction,
              child: Text('Predict'),
            ),
            
            SizedBox(height: 20),
            if (prediction.isNotEmpty) 
              Text('Prediction: $prediction'),
            if (predictionProb.isNotEmpty) 
              Text('Probability: $predictionProb'),
          ],
        ),
      ),
    );
  }
}
