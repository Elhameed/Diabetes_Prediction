# model.py
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras.regularizers import l2
import pickle

def train_model(X_train, y_train, X_test, y_test, scaler):
    # Define the neural network model
    model = Sequential([
        Dense(16, activation='relu', input_shape=(X_train.shape[1],), kernel_regularizer=l2(0.01)),
        Dense(32, activation='relu', kernel_regularizer=l2(0.01)),
        Dense(16, activation='relu', kernel_regularizer=l2(0.01)),
        Dense(1, activation='sigmoid')
    ])
    
    # Compile the model
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
    
    # Add early stopping to prevent overfitting
    early_stopping = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)
    
    # Train the model
    history = model.fit(X_train, y_train,
                        validation_split=0.2,
                        epochs=50,
                        batch_size=32,
                        callbacks=[early_stopping],
                        verbose=1)
    
    # Evaluate the model on the test set
    test_loss, test_accuracy = model.evaluate(X_test, y_test, verbose=0)
    print(f"\nTest Accuracy: {test_accuracy:.2f}")
    
    # # Save the model in TensorFlow format
    # model.save('diabetes_model.h5')
    
    # # Save the model as a Pickle .pkl file
    # with open('diabetes_model.pkl', 'wb') as f:
    #     pickle.dump(model, f)
    
    return model, history
