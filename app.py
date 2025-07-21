from flask import Flask, request, jsonify
from analysis.deadlift import analyze_deadlift

app = Flask(__name__)

@app.route("/analyze", methods=["POST"])
def analyze():
    video_file = request.files.get("video")
    exercise = request.form.get("exercise", "deadlift")

    if not video_file:
        return jsonify({"error": "No video uploaded"}), 400

    # נשמור זמנית את הווידאו
    filepath = f"/tmp/{video_file.filename}"
    video_file.save(filepath)

    if exercise == "deadlift":
        result = analyze_deadlift(filepath)
    else:
        return jsonify({"error": f"Unsupported exercise: {exercise}"}), 400

    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
