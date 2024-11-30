# prediction.py
from tensorflow.keras.models import load_model
import pickle

def predict(model, scaler, input_data):
    """
    Predicts the outcome (diabetes or not) using the model and scaler.
    """
    input_data = scaler.transform([input_data])
    prediction_prob = model.predict(input_data)[0][0]
    prediction = 1 if prediction_prob > 0.5 else 0
    return prediction, prediction_prob
