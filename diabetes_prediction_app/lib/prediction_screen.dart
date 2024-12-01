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

        double predictionProbability = response['prediction_probability'];

        setState(() {
          // Logic for handling different responses based on prediction probability
          if (predictionProbability > 0.5) {
            result = 'The model predicts that the patient is likely to have diabetes with ${predictionProbability * 100}% confidence.';
          } else {
            result = 'The model predicts that the patient is unlikely to have diabetes with ${predictionProbability * 100}% confidence.';
          }
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
      appBar: AppBar(
        title: Text('Diabetes Prediction'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(_pregnanciesController, 'Pregnancies'),
              _buildTextFormField(_glucoseController, 'Glucose'),
              _buildTextFormField(_bloodPressureController, 'Blood Pressure'),
              _buildTextFormField(_skinThicknessController, 'Skin Thickness'),
              _buildTextFormField(_insulinController, 'Insulin'),
              _buildTextFormField(_bmiController, 'BMI'),
              _buildTextFormField(_diabetesPedigreeController, 'Diabetes Pedigree Function'),
              _buildTextFormField(_ageController, 'Age'),

              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator()),
              if (!isLoading)
                ElevatedButton(
                  onPressed: _makePrediction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Make Prediction', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              SizedBox(height: 20),

              if (result.isNotEmpty)
                _buildResultBox(result),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        keyboardType: TextInputType.number,
        validator: (value) => value == null || value.isEmpty ? 'Enter a value' : null,
      ),
    );
  }

  Widget _buildResultBox(String result) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            'Prediction Result',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            result,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
