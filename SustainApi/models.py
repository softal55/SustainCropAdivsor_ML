from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'
    email = db.Column(db.String(255), primary_key=True)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(255), nullable=False)


class Field(db.Model):
    __tablename__ = 'fields'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    creation_date = db.Column(db.DateTime, default=datetime.utcnow)
    area = db.Column(db.Float, nullable=False)
    user_email = db.Column(db.String(255), db.ForeignKey('users.email', ondelete='CASCADE'), nullable=False)

    # Relationships
    points = db.relationship('Point', backref='field', lazy=True, cascade="all, delete-orphan")
    measurement_points = db.relationship('MeasurementPoint', backref='field', lazy=True, cascade="all, delete-orphan")
    measurements = db.relationship('Measurement', backref='field', lazy=True, cascade="all, delete-orphan")
    predictions = db.relationship('Prediction', backref='field', lazy=True, cascade="all, delete-orphan")


class Point(db.Model):
    __tablename__ = 'points'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    field_id = db.Column(db.Integer, db.ForeignKey('fields.id', ondelete='CASCADE'), nullable=False)


class MeasurementPoint(db.Model):
    __tablename__ = 'measurement_points'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    field_id = db.Column(db.Integer, db.ForeignKey('fields.id', ondelete='CASCADE'), nullable=False)

    # Relationships
    measurements = db.relationship('Measurement', backref='measurement_point', lazy=True, cascade="all, delete-orphan")


class Measurement(db.Model):
    __tablename__ = 'measurements'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    field_id = db.Column(db.Integer, db.ForeignKey('fields.id', ondelete='CASCADE'), nullable=False)
    measurement_point_id = db.Column(db.Integer, db.ForeignKey('measurement_points.id', ondelete='CASCADE'), nullable=False)
    n = db.Column(db.Float, nullable=False)
    p = db.Column(db.Float, nullable=False)
    k = db.Column(db.Float, nullable=False)
    ph = db.Column(db.Float, nullable=False)
    rainfall = db.Column(db.Float, nullable=False)
    temperature = db.Column(db.Float, nullable=False)
    humidity = db.Column(db.Float, nullable=False)
    measurement_date = db.Column(db.DateTime, default=datetime.utcnow)


class Prediction(db.Model):
    __tablename__ = 'predictions'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    field_id = db.Column(db.Integer, db.ForeignKey('fields.id', ondelete='CASCADE'), nullable=False)
    crop_name = db.Column(db.String(255), nullable=False)
    confidence = db.Column(db.Float, nullable=False)
    prediction_date = db.Column(db.DateTime, default=datetime.utcnow)

    prediction_measurements = db.relationship('PredictionMeasurement', backref='prediction', lazy=True, cascade="all, delete-orphan")


class PredictionMeasurement(db.Model):
    __tablename__ = 'prediction_measurements'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    prediction_id = db.Column(db.Integer, db.ForeignKey('predictions.id', ondelete='CASCADE'), nullable=False)
    n = db.Column(db.Float, nullable=False)
    p = db.Column(db.Float, nullable=False)
    k = db.Column(db.Float, nullable=False)
    ph = db.Column(db.Float, nullable=False)
    rainfall = db.Column(db.Float, nullable=False)
    temperature = db.Column(db.Float, nullable=False)
    humidity = db.Column(db.Float, nullable=False)
