from flask import Flask, request, jsonify
import os
import subprocess
import uuid
import json
import cv2

app = Flask(__name__)

MEDIA_DIR = "media"
os.makedirs(MEDIA_DIR, exist_ok=True)

@app.route('/analyze', methods=['POST'])
def analyze():
    # Save uploaded video
    video = request.files.get('video')
    if not video:
        return jsonify({"error": "No video uploaded"}), 400

    video_id = str(uuid.uuid4())
    video_path = os.path.join(MEDIA_DIR, f"{video_id}.mp4")
    video.save(video_path)

    # Run OpenPose on video using subprocess (assumes openpose binary is installed)
    output_json_dir = os.path.join(MEDIA_DIR, f"{video_id}_json")
    os.makedirs(output_json_dir, exist_ok=True)

    try:
        subprocess.run([
            "./openpose/build/examples/openpose/openpose.bin",
            "--video", video_path,
            "--write_json", output_json_dir,
            "--display", "0",
            "--render_pose", "0",
            "--model_pose", "BODY_25",
            "--hand", "false",
            "--face", "false"
        ], check=True)
    except subprocess.CalledProcessError:
        return jsonify({"error": "OpenPose failed to run"}), 500

    # Analyze output keypoints (simplified)
    spine_angles = []
    for file in sorted(os.listdir(output_json_dir)):
        if file.endswith(".json"):
            with open(os.path.join(output_json_dir, file)) as f:
                data = json.load(f)
                people = data.get("people", [])
                if not people:
                    continue

                keypoints = people[0].get("pose_keypoints_2d", [])
                if len(keypoints) < 75:
                    continue

                # BODY_25 indices
                NECK = 1
                MIDHIP = 8
                CHEST = 17

                def get_point(index):
                    return keypoints[index * 3], keypoints[index * 3 + 1]  # x, y

                neck = get_point(NECK)
                chest = get_point(CHEST)
                midhip = get_point(MIDHIP)

                a = cv2.norm(np.array(chest) - np.array(neck))
                b = cv2.norm(np.array(chest) - np.array(midhip))
                c = cv2.norm(np.array(midhip) - np.array(neck))

                if a == 0 or b == 0:
                    continue

                cos_angle = (a**2 + b**2 - c**2) / (2 * a * b)
                cos_angle = np.clip(cos_angle, -1, 1)
                angle = np.degrees(np.arccos(cos_angle))
                spine_angles.append(angle)

    if not spine_angles:
        return jsonify({"error": "No pose data detected"}), 422

    min_angle = min(spine_angles)
    feedback = []
    if min_angle > 170:
        score = 10
    elif min_angle > 160:
        score = 8.5
        feedback.append("Try to keep your back a bit straighter")
    else:
        score = 7
        feedback.append("Warning: Significant back rounding detected")

    return jsonify({
        "technique_score": round(score, 1),
        "feedback": feedback
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
