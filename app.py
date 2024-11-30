# app.py
from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
import pickle
import numpy as np
import pandas as pd
import io
from src.preprocessing import preprocess_data
from src.prediction import predict
from src.model import train_model

# Initialize FastAPI app
app = FastAPI()

# Load the model
with open('models/diabetes_model.pkl', 'rb') as f:
    model_pickle = pickle.load(f)

# Load scaler
with open("data/scaler/scaler.pkl", "rb") as f:
    scaler = pickle.load(f)

# Create a Pydantic model for the request body
class DiabetesData(BaseModel):
    pregnancies: float
    glucose: float
    blood_pressure: float
    skin_thickness: float
    insulin: float
    bmi: float
    diabetes_pedigree_function: float
    age: float

@app.post("/predict/")
def make_prediction(data: DiabetesData):
    input_data = [
        data.pregnancies,
        data.glucose,
        data.blood_pressure,
        data.skin_thickness,
        data.insulin,
        data.bmi,
        data.diabetes_pedigree_function,
        data.age
    ]
    
    # Make prediction
    prediction, prediction_prob = predict(model_pickle, scaler, input_data)
    
    # Convert numpy.float32 to float for serialization
    return {
        "prediction": float(prediction),
        "prediction_probability": float(prediction_prob)
    }

@app.post("/retrain/")
async def retrain_model(file: UploadFile = File(...)):
    """
    Retrain the model with new data uploaded as a CSV file.
    """
    # Check if the uploaded file is a CSV
    if not file.filename.endswith('.csv'):
        raise HTTPException(status_code=400, detail="Only CSV files are supported.")
    
    # Read the uploaded CSV file into a DataFrame
    contents = await file.read()
    try:
        data = pd.read_csv(io.BytesIO(contents))
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error reading the CSV file: {str(e)}")
    
    # Validate columns in the uploaded data
    required_columns = [
        "Pregnancies", "Glucose", "BloodPressure", "SkinThickness",
        "Insulin", "BMI", "DiabetesPedigreeFunction", "Age", "Outcome"
    ]
    if not all(col in data.columns for col in required_columns):
        raise HTTPException(status_code=400, detail="Uploaded data must contain all required columns.")
    
    # Save the uploaded data to a temporary CSV file
    temp_file_path = "data/temp_retrain_data.csv"
    data.to_csv(temp_file_path, index=False)
    
    # Preprocess the new data
    X_train, X_test, y_train, y_test, scaler = preprocess_data(file_path=temp_file_path)
    
    # Train the model using the new data
    model, history = train_model(X_train, y_train, X_test, y_test, scaler)
    
    # Save the updated model and scaler
    model.save("data/models/diabetes_model_updated.h5")
    with open("data/scaler/scaler.pkl", "wb") as f:
        pickle.dump(scaler, f)
        
    return {
        "message": "Model retrained successfully!",
        "accuracy": history.history["accuracy"][-1],
        "val_accuracy": history.history["val_accuracy"][-1]
    }

@app.get("/")
def read_root():
    return {"message": "Welcome to the Diabetes Prediction API!"}

