from flask import Flask
from flask_jwt_extended import JWTManager

from config import Config
from models import db
from routes import auth_bp, field_bp

app = Flask(__name__)
app.config.from_object(Config)

# Initialize Extensions
db.init_app(app)
jwt = JWTManager(app)

# Register Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(field_bp, url_prefix='/fields')

# Main Entry Point
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=5000)
