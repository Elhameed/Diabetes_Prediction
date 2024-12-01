import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RetrainScreen extends StatefulWidget {
  @override
  _RetrainScreenState createState() => _RetrainScreenState();
}

class _RetrainScreenState extends State<RetrainScreen> {
  final ApiService apiService = ApiService(baseUrl: 'https://diabetes-prediction-gj1e.onrender.com');
  Uint8List? selectedFile;
  bool isLoading = false;
  String retrainMessage = '';
  double? accuracy;
  double? valAccuracy;
  String? downloadUrl;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      setState(() {
        selectedFile = result.files.single.bytes;
      });
    }
  }

  Future<void> _retrainModel() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload a CSV file.')));
      return;
    }

    setState(() {
      isLoading = true;
      retrainMessage = '';
    });

    try {
      var result = await apiService.retrainModel(selectedFile!);
      setState(() {
        retrainMessage = result['message'];
        accuracy = result['accuracy'];
        valAccuracy = result['val_accuracy'];
        downloadUrl = result['download_url'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retrain Model')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Upload CSV File'),
            ),
            if (selectedFile != null) 
              Text('File Selected: Yes', style: TextStyle(color: Colors.green)),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (!isLoading)
              ElevatedButton(
                onPressed: _retrainModel,
                child: Text('Retrain Model'),
              ),
            SizedBox(height: 20),
            if (retrainMessage.isNotEmpty) ...[
              Text('Message: $retrainMessage', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Accuracy: ${accuracy?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Validation Accuracy: ${valAccuracy?.toStringAsFixed(2) ?? 'N/A'}'),
              if (downloadUrl != null)
                TextButton(
                  onPressed: () {
                    // Opens the download URL in the browser
                    launchUrl(Uri.parse(downloadUrl!));
                  },
                  child: Text('Download Retrained Model'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
