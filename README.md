SustainCropAdvisor

SustainCropAdvisor is an AI-powered crop recommendation system that helps farmers choose the most suitable and sustainable crops based on real soil measurements. This project was developed as part of a final-year Bachelor's thesis in Computer Science. It integrates Machine Learning, Flask backend services, MySQL database design, and a Flutter mobile application.

Overview

The system analyzes soil and environmental data collected from sensors and predicts the top three optimal crops for a given field. The mobile application allows farmers to define fields on a map, record on-site measurements, and view recommended crops.

Features

Machine Learning

Predicts optimal crops using seven agronomic measurements:

Nitrogen (N)

Phosphorus (P)

Potassium (K)

Soil pH

Soil moisture

Temperature

Rainfall

Trained on real agricultural datasets

Multiple models evaluated: Random Forest, SVM, Naive Bayes, k-NN

Random Forest selected as the final model based on performance

Backend (Flask)

REST API for:

User authentication

Field management

Measurement storage

Crop prediction

History tracking

Integration with the ML model

Communication with MySQL database

Database (MySQL)

Stores the following:

Users

Agricultural fields

GPS coordinates

Soil measurements

Predictions

Selected crop history

Mobile Application (Flutter)

Map-based field creation

Measurement input forms

Display of top three predicted crops

Crop history management

(Flutter interface developed by saidi21.)

Machine Learning Details

Dataset

The model was trained using the "Machine Learning in Agriculture" dataset from Kaggle. The dataset contains approximately 2200 samples with various crop-related measurements.

Dataset link: https://www.kaggle.com/datasets/dhamur/machine-learning-in-agriculture

Models Tested

Random Forest

Support Vector Machine (SVM)

Naive Bayes

k-Nearest Neighbors (k-NN)

Model Selection

After evaluating several algorithms, Random Forest was selected due to:

High accuracy (0.996)

High F1-score (0.991)

Stability across different classes

Robustness against overfitting

Hyperparameters were tuned using GridSearchCV. The dataset was split into 70% training and 30% testing.

Architecture

The system architecture consists of:

Flutter application (user interface)

Flask REST API

Machine Learning model (scikit-learn)

MySQL relational database

Workflow:

The user defines a field and enters soil measurements.

Measurements are sent to the Flask backend.

The backend passes them to the ML model.

The model predicts the top three crops.

The backend stores predictions and returns results to the mobile app.

Technologies Used

Machine Learning

Python

Scikit-learn

Pandas

NumPy

Backend

Python Flask

MySQL Connector

REST API architecture

Frontend

Flutter (Dart)

Tools

Git / GitHub

Postman

VS Code

PyCharm
