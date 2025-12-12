from flask import Flask, request, jsonify
import joblib
import numpy as np
import pandas as pd

app = Flask(__name__)

# Load model and encoder
model = joblib.load("crop_model.pkl")
label_encoder = joblib.load("label_encoder.pkl")

@app.route('/recommend', methods=['POST'])
def recommend_crops():
    try:
        data = request.json
        if not isinstance(data, list) or len(data) == 0:
            return jsonify({"error": "Input should be a list of measurements."}), 400

        required_params = ['n', 'p', 'k', 'temperature', 'humidity', 'ph', 'rainfall']
        predictions = []

        for measurement in data:
            if not all(param in measurement for param in required_params):
                return jsonify({"error": "Missing required parameters."}), 400

            input_data = pd.DataFrame([measurement], columns=required_params)
            probabilities = model.predict_proba(input_data)[0]
            predictions.append({"probabilities": probabilities})

        crop_confidence_sum = {crop: 0.0 for crop in label_encoder.classes_}
        crop_prediction_count = {crop: 0 for crop in label_encoder.classes_}

        for pred in predictions:
            for crop in crop_confidence_sum:
                crop_index = np.where(label_encoder.classes_ == crop)[0][0]
                confidence = pred["probabilities"][crop_index]
                crop_confidence_sum[crop] += confidence
                if confidence > 0:
                    crop_prediction_count[crop] += 1

        crops_with_data = [
            {
                "crop": crop,
                "avg_confidence": crop_confidence_sum[crop] / crop_prediction_count[crop],
                "count": crop_prediction_count[crop]
            }
            for crop in crop_confidence_sum if crop_prediction_count[crop] > 0
        ]

        if not crops_with_data:
            return jsonify({"error": "No valid predictions."}), 400

        max_count = max(c["count"] for c in crops_with_data)
        for c in crops_with_data:
            c["combined_score"] = 0.7 * c["avg_confidence"] + 0.3 * (c["count"] / max_count)

        top_crops = sorted(crops_with_data, key=lambda x: x["combined_score"], reverse=True)[:3]
        recommendations = [{"crop_name": c["crop"], "confidence": round(c["combined_score"], 4)} for c in top_crops]

        return jsonify({"recommendations": recommendations})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4000, debug=True)
