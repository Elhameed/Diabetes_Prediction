# app.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pickle
import numpy as np
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
def retrain_model(file_path: str):
    """
    Retrain the model with the new data provided.
    """
    try:
        # Preprocess the new data
        X_train, X_test, y_train, y_test, updated_scaler = preprocess_data(file_path)
        
        # Train the model
        updated_model, history = train_model(X_train, y_train, X_test, y_test, updated_scaler)
        
        # Save the updated model and scaler
        with open('diabetes_model.pkl', 'wb') as f:
            pickle.dump(updated_model, f)
        
        with open("scaler.pkl", 'wb') as f:
            pickle.dump(updated_scaler, f)
        
        # Update in-memory references
        global model_pickle, scaler
        model_pickle = updated_model
        scaler = updated_scaler
        
        return {
            "message": "Model retrained successfully!",
            "accuracy": history.history["accuracy"][-1],
            "val_accuracy": history.history["val_accuracy"][-1]
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def read_root():
    return {"message": "Welcome to the Diabetes Prediction API!"}

