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
      appBar: AppBar(
        title: Text('Retrain Model'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
                'Upload New Data',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Upload a CSV file containing the new training data.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
            // File upload section
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _pickFile,
              child: Text('Upload CSV File', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'File Selected: Yes',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            SizedBox(height: 20),

            // Loading and retrain button
            if (isLoading) 
              Center(child: CircularProgressIndicator()),
            if (!isLoading)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _retrainModel,
                child: Text('Retrain Model', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            SizedBox(height: 20),

            // Results section
            if (retrainMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Message:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(retrainMessage, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 15),
                    Text('Accuracy: ${accuracy?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('Validation Accuracy: ${valAccuracy?.toStringAsFixed(2) ?? 'N/A'}'),
                    SizedBox(height: 20),
                    if (downloadUrl != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          // Opens the download URL in the browser
                          launchUrl(Uri.parse(downloadUrl!));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding here
                          child: Text(
                            'Download Retrained Model',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
