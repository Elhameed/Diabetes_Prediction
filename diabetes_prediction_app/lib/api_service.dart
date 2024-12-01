import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Predict function
  Future<Map<String, dynamic>> makePrediction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  // Retrain model function
  Future<Map<String, dynamic>> retrainModel(List<int> fileBytes) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/retrain/'));
    request.files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: 'data/diabetes.csv'));

    final response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      throw Exception('Failed to retrain the model');
    }
  }
}
