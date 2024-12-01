from locust import HttpUser, task, between
import random

class DiabetesPredictionUser(HttpUser):
    # Wait time between tasks (in seconds)
    wait_time = between(1, 3)

    @task
    def make_prediction(self):
        # Random data for testing
        data = {
            "pregnancies": random.uniform(0, 10),
            "glucose": random.uniform(50, 200),
            "blood_pressure": random.uniform(40, 130),
            "skin_thickness": random.uniform(10, 50),
            "insulin": random.uniform(10, 800),
            "bmi": random.uniform(15, 50),
            "diabetes_pedigree_function": random.uniform(0.1, 2.5),
            "age": random.randint(21, 80)
        }
        response = self.client.post("/predict/", json=data)
        print(f"Prediction: {response.json()}")

    @task
    def retrain_model(self):
        # Simulate uploading a CSV file for retraining
        with open("data/diabetes.csv", "rb") as f:
            files = {'file': f}
            response = self.client.post("/retrain/", files=files)
            print(f"Retrain status: {response.json()}")
