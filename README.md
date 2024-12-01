# Diabetes Prediction & Retraining System

## Overview

This project implements a **Diabetes Prediction and Retraining System** using machine learning. The system allows users to:
- Make predictions based on selected features of a dataset.
- Visualize relationships between features and the diabetes outcome.
- Upload bulk data (CSV format) for retraining the model.
- Trigger model retraining based on uploaded data and download the updated model.

The system is powered by a **FastAPI backend** and is integrated with a **Flutter mobile app** for user interaction. The solution also includes a **Locust load testing** for performance evaluation.

## Features

1. **Model Prediction**:  
   Users can provide their features (such as pregnancies, glucose, blood pressure, etc.) to predict the likelihood of diabetes using the trained model.

2. **Data Visualization**:  
   The system allows users to generate visualizations such as:
   - Scatter plots to visualize relationships between features.
   - Histograms to show the distribution of features across the dataset.

3. **Bulk Data Upload**:  
   Users can upload bulk data in CSV format to retrain the model. The data must contain the following columns:  
   `Pregnancies`, `Glucose`, `BloodPressure`, `SkinThickness`, `Insulin`, `BMI`, `DiabetesPedigreeFunction`, `Age`, `Outcome`.

4. **Model Retraining**:  
   After data is uploaded, the system automatically retrains the model and provides evaluation metrics (accuracy, validation accuracy). The retrained model is then available for download.

5. **Deployment**:  
   The backend is deployed on **Render** and the mobile app interacts with the deployed API. Load testing is conducted using **Locust** to ensure the system can handle high traffic.

## Tech Stack

- **Backend**: FastAPI, Python, TensorFlow, Scikit-learn
- **Mobile Frontend**: Flutter
- **Load Testing**: Locust
- **Deployment**: Render (for backend), 
- **Model**: Neural Network for Diabetes Prediction
- **Data**: Diabetes dataset from the National Institute of Diabetes and Digestive and Kidney Diseases (Pima Indian Heritage) [https://www.kaggle.com/datasets/mathchi/diabetes-data-set]

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/Elhameed/Diabetes_Prediction.git
cd Diabetes_Prediction
```

### 2. Create a Python Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # For Linux/MacOS
venv\Scripts\activate     # For Windows
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Backend Setup
1. Create the necessary directories:

- `data/models` (for saving the models)
- `data/scaler` (for saving the scaler)
  
2. Run the FastAPI server:
```bash
uvicorn app:app --reload
```
Your API should now be running on `http://127.0.0.1:8000`
Yu can also access the deployed link at https://diabetes-prediction-gj1e.onrender.com

### 5.  Flutter Mobile App Setup
1. Install Flutter SDK from Flutter website.
2. Navigate the Flutter app from the repository.
```bash
cd diabetes_prediction_app
```
4. Run the app on an emulator or connected device:
```bash
flutter run
```
The app will communicate with the backend API to make predictions and retrain the model.

## API Endpoints

### 1. Prediction Endpoint

POST /predict/
Request body:

```bash
{
  "pregnancies": 6,
  "glucose": 148,
  "blood_pressure": 72,
  "skin_thickness": 35,
  "insulin": 0,
  "bmi": 33.6,
  "diabetes_pedigree_function": 0.627,
  "age": 50
}
```

Response

```bash
{
  "prediction": 1,
  "prediction_probability": 0.87
}

```

### 2. Retrain Endpoint
POST /retrain/
Upload a CSV file with the required columns (`Pregnancies`, `Glucose`, `BloodPressure`, `SkinThickness`, `Insulin`, `BMI`, `DiabetesPedigreeFunction`, `Age`, `Outcome`).

Response:
```bash
{
  "message": "Model retrained successfully!",
  "accuracy": 0.87,
  "val_accuracy": 0.85,
  "download_url": "https://diabetes-prediction-gj1e.onrender.com/download_model/models/diabetes_model_retrained.h5"
}
```

## Visualizations
The following visualizations are provided:

- **Scatter Plot:** Displays the relationship between two features (e.g., BMI vs. Age).
- **Histogram:** Shows the distribution of a single feature (e.g., Glucose levels).

## Load Testing
Load testing is implemented using Locust to simulate heavy traffic on the API. To run the load test:
1. Install Locust:
```bash
pip install locust
```

2. Run the Locust test:
```bash
locust -f locustfile.py --host=https://diabetes-prediction-gj1e.onrender.com
```
This will open a web interface at http://localhost:8089 to start the load test.


## Contributions
Feel free to contribute to this project! If you'd like to submit changes, follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Push your changes and create a pull request.
