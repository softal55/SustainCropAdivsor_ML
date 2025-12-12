from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token
from models import db, User

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    email = data.get('email')
    password = data.get('password')

    if not all([first_name, last_name, email, password]):
        return jsonify({"message": "Missing required fields"}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({"message": "Email already in use"}), 400

    # Create the user directly
    new_user = User(first_name=first_name, last_name=last_name, email=email, password=password)

    try:
        # Add to database and commit
        db.session.add(new_user)
        db.session.commit()

        # Create access token and log the user in immediately
        access_token = create_access_token(identity=email)
        return jsonify({"message": "User registered successfully", "access_token": access_token}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"message": f"Error creating user: {str(e)}"}), 500


# The '/verify-otp' endpoint is no longer needed and has been deleted.


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email, password = data.get('email'), data.get('password')

    if not email or not password:
        return jsonify({"message": "Missing required fields"}), 400

    user = User.query.filter_by(email=email).first()
    if not user or user.password != password:
        return jsonify({"message": "Invalid credentials"}), 401

    access_token = create_access_token(identity=email)
    return jsonify({"message": "Login successful", "access_token": access_token}), 200