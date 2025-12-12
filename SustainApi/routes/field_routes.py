from flask import Blueprint, request, jsonify
from models import db, Field, Point, Measurement, Prediction, PredictionMeasurement, MeasurementPoint
from flask_jwt_extended import jwt_required, get_jwt_identity

field_bp = Blueprint('field', __name__)

# Get all fields for the authenticated user
@field_bp.route('/', methods=['GET'])
@jwt_required()
def get_user_fields():
    user_email = get_jwt_identity()
    fields = Field.query.filter_by(user_email=user_email).all()
    field_list = [{
        "id": field.id,
        "name": field.name,
        "area": field.area,
        "creation_date": field.creation_date.isoformat() if field.creation_date else None,
        "points": [{"id": pt.id, "latitude": pt.latitude, "longitude": pt.longitude} for pt in field.points],
        "predictions": [{
            "id": pred.id,
            "crop_name": pred.crop_name,
            "confidence": pred.confidence,
            "prediction_date": pred.prediction_date.isoformat() if pred.prediction_date else None
        } for pred in field.predictions]
    } for field in fields]
    return jsonify(field_list), 200

# Add a new field with mandatory points
@field_bp.route('/', methods=['POST'])
@jwt_required()
def add_field():
    user_email = get_jwt_identity()
    data = request.get_json()

    # Check if points are provided
    points = data.get('points', [])
    if not points or not isinstance(points, list):
        return jsonify({"message": "Points must be provided and should be a list"}), 400

    new_field = Field(
        name=data['name'],
        area=data['area'],
        user_email=user_email
    )

    try:
        db.session.add(new_field)
        db.session.flush()  # Get the field ID before committing

        # Add points
        for point in points:
            if 'latitude' not in point or 'longitude' not in point:
                return jsonify({"message": "Each point must have latitude and longitude"}), 400

            new_point = Point(
                field_id=new_field.id,
                latitude=point['latitude'],
                longitude=point['longitude']
            )
            db.session.add(new_point)

        db.session.commit()
        return jsonify({"message": "Field added successfully", "field_id": new_field.id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Edit an existing field
@field_bp.route('/<int:field_id>', methods=['PUT'])
@jwt_required()
def edit_field(field_id):
    user_email = get_jwt_identity()
    data = request.get_json()

    field = Field.query.filter_by(id=field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    field.name = data.get('name', field.name)
    field.area = data.get('area', field.area)

    try:
        db.session.commit()
        return jsonify({"message": "Field updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Delete a field
@field_bp.route('/<int:field_id>', methods=['DELETE'])
@jwt_required()
def delete_field(field_id):
    user_email = get_jwt_identity()
    field = Field.query.filter_by(id=field_id, user_email=user_email).first()

    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    try:
        db.session.delete(field)
        db.session.commit()
        return jsonify({"message": "Field deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Get measurements for a field
@field_bp.route('/<int:field_id>/measurements', methods=['GET'])
@jwt_required()
def get_measurements(field_id):
    user_email = get_jwt_identity()
    field = Field.query.filter_by(id=field_id, user_email=user_email).first()

    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    measurements = Measurement.query.filter_by(field_id=field_id).all()
    measurement_list = [
        {
            "id": measurement.id,
            "field_id": measurement.field_id,
            "measurement_point": {
                "id": measurement.measurement_point.id,
                "latitude": measurement.measurement_point.latitude,
                "longitude": measurement.measurement_point.longitude
            },
            "n": measurement.n,
            "p": measurement.p,
            "k": measurement.k,
            "ph": measurement.ph,
            "rainfall": measurement.rainfall,
            "temperature": measurement.temperature,
            "humidity": measurement.humidity,
            "measurement_date": measurement.measurement_date.isoformat() if measurement.measurement_date else None
        }
        for measurement in measurements
    ]

    return jsonify(measurement_list), 200

# Add a measurement to a field
@field_bp.route('/<int:field_id>/measurements', methods=['POST'])
@jwt_required()
def add_measurement(field_id):
    user_email = get_jwt_identity()
    data = request.get_json()

    # Validate that the field exists and belongs to the user
    field = Field.query.filter_by(id=field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    # Extract latitude and longitude from the request
    latitude = data.get('latitude')
    longitude = data.get('longitude')
    if latitude is None or longitude is None:
        return jsonify({"message": "Latitude and Longitude are required"}), 400

    # Validate and create a new MeasurementPoint
    try:
        measurement_point = MeasurementPoint(
            latitude=latitude,
            longitude=longitude,
            field_id=field_id
        )
        db.session.add(measurement_point)
        db.session.flush()  # Generate the ID for the MeasurementPoint without committing

        # Create a new Measurement
        measurement = Measurement(
            field_id=field_id,
            measurement_point_id=measurement_point.id,
            n=data['n'],
            p=data['p'],
            k=data['k'],
            ph=data['ph'],
            rainfall=data['rainfall'],
            temperature=data['temperature'],
            humidity=data['humidity']
        )
        db.session.add(measurement)
        db.session.commit()

        return jsonify({"message": "Measurement added successfully", "measurement_id": measurement.id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Edit a measurement
@field_bp.route('/measurements/<int:measurement_id>', methods=['PUT'])
@jwt_required()
def edit_measurement(measurement_id):
    user_email = get_jwt_identity()
    data = request.get_json()

    measurement = Measurement.query.filter_by(id=measurement_id).first()
    if not measurement:
        return jsonify({"message": "Measurement not found"}), 404

    field = Field.query.filter_by(id=measurement.field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Unauthorized to edit this measurement"}), 403

    measurement.n = data.get('n', measurement.n)
    measurement.p = data.get('p', measurement.p)
    measurement.k = data.get('k', measurement.k)
    measurement.ph = data.get('ph', measurement.ph)
    measurement.rainfall = data.get('rainfall', measurement.rainfall)
    measurement.temperature = data.get('temperature', measurement.temperature)
    measurement.humidity = data.get('humidity', measurement.humidity)

    try:
        db.session.commit()
        return jsonify({"message": "Measurement updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Delete a measurement
@field_bp.route('/measurements/<int:measurement_id>', methods=['DELETE'])
@jwt_required()
def delete_measurement(measurement_id):
    user_email = get_jwt_identity()
    measurement = Measurement.query.filter_by(id=measurement_id).first()

    if not measurement:
        return jsonify({"message": "Measurement not found"}), 404

    field = Field.query.filter_by(id=measurement.field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Unauthorized to delete this measurement"}), 403

    try:
        db.session.delete(measurement)
        db.session.commit()
        return jsonify({"message": "Measurement deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Get predictions for a field
@field_bp.route('/<int:field_id>/predictions', methods=['GET'])
@jwt_required()
def get_predictions(field_id):
    user_email = get_jwt_identity()
    field = Field.query.filter_by(id=field_id, user_email=user_email).first()

    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    predictions = Prediction.query.filter_by(field_id=field_id).all()
    prediction_list = [{
        "id": prediction.id,
        "field_id": prediction.field_id,
        "crop_name": prediction.crop_name,
        "confidence": prediction.confidence,
        "prediction_date": prediction.prediction_date.isoformat() if prediction.prediction_date else None,
        "measurements": [{
            "n": pm.n,
            "p": pm.p,
            "k": pm.k,
            "ph": pm.ph,
            "rainfall": pm.rainfall,
            "temperature": pm.temperature,
            "humidity": pm.humidity
        } for pm in prediction.prediction_measurements]
    } for prediction in predictions]
    print(prediction_list)

    return jsonify(prediction_list), 200

# Add a prediction to a field
@field_bp.route('/<int:field_id>/predictions', methods=['POST'])
@jwt_required()
def add_prediction(field_id):
    user_email = get_jwt_identity()
    data = request.get_json()

    field = Field.query.filter_by(id=field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Field not found or unauthorized"}), 404

    prediction = Prediction(
        field_id=field_id,
        crop_name=data['crop_name'],
        confidence=data['confidence']
    )

    try:
        db.session.add(prediction)
        db.session.flush()  # Get prediction.id before commit

        # Add prediction measurements if provided
        if 'measurements' in data:
            for measurement in data['measurements']:
                pm = PredictionMeasurement(
                    prediction_id=prediction.id,
                    n=measurement['n'],
                    p=measurement['p'],
                    k=measurement['k'],
                    ph=measurement['ph'],
                    rainfall=measurement['rainfall'],
                    temperature=measurement['temperature'],
                    humidity=measurement['humidity']
                )
                db.session.add(pm)

        db.session.commit()
        return jsonify({
            "message": "Prediction added successfully",
            "prediction_id": prediction.id
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

# Delete a prediction
@field_bp.route('/predictions/<int:prediction_id>', methods=['DELETE'])
@jwt_required()
def delete_prediction(prediction_id):
    user_email = get_jwt_identity()
    prediction = Prediction.query.get(prediction_id)

    if not prediction:
        return jsonify({"message": "Prediction not found"}), 404

    # Verify the prediction belongs to the user's field
    field = Field.query.filter_by(id=prediction.field_id, user_email=user_email).first()
    if not field:
        return jsonify({"message": "Unauthorized to delete this prediction"}), 403

    try:
        db.session.delete(prediction)
        db.session.commit()
        return jsonify({"message": "Prediction deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500
