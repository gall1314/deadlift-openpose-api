
from flask import Flask, request, jsonify
from deadlift import analyze_deadlift
import os
import uuid

app = Flask(__name__)

@app.route("/analyze", methods=["POST"])
def analyze():
    video = request.files.get("video")
    if not video:
        return jsonify({"error": "No video uploaded"}), 400

    # שמירת קובץ זמנית
    filename = f"/tmp/{uuid.uuid4()}.mp4"
    video.save(filename)

    try:
        result = analyze_deadlift(filename)
    finally:
        if os.path.exists(filename):
            os.remove(filename)

    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
