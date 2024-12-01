import 'package:flutter/material.dart';
import 'api_service.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ApiService apiService = ApiService(baseUrl: 'https://diabetes-prediction-gj1e.onrender.com');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pregnanciesController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _skinThicknessController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _diabetesPedigreeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String result = '';
  bool isLoading = false;

  Future<void> _makePrediction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await apiService.makePrediction({
          "pregnancies": double.parse(_pregnanciesController.text),
          "glucose": double.parse(_glucoseController.text),
          "blood_pressure": double.parse(_bloodPressureController.text),
          "skin_thickness": double.parse(_skinThicknessController.text),
          "insulin": double.parse(_insulinController.text),
          "bmi": double.parse(_bmiController.text),
          "diabetes_pedigree_function": double.parse(_diabetesPedigreeController.text),
          "age": double.parse(_ageController.text),
        });

        setState(() {
          result = 'Prediction: ${response['prediction']} (Probability: ${response['prediction_probability']})';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _pregnanciesController,
                decoration: InputDecoration(labelText: 'Pregnancies'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _glucoseController,
                decoration: InputDecoration(labelText: 'Glucose'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _bloodPressureController,
                decoration: InputDecoration(labelText: 'Blood Pressure'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _skinThicknessController,
                decoration: InputDecoration(labelText: 'Skin Thickness'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _insulinController,
                decoration: InputDecoration(labelText: 'Insulin'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _bmiController,
                decoration: InputDecoration(labelText: 'BMI'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _diabetesPedigreeController,
                decoration: InputDecoration(labelText: 'Diabetes Pedigree Function'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator(),
              if (!isLoading)
                ElevatedButton(
                  onPressed: _makePrediction,
                  child: Text('Make Prediction'),
                ),
              SizedBox(height: 20),
              if (result.isNotEmpty) Text(result),
            ],
          ),
        ),
      ),
    );
  }
}
