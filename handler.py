import requests
import cv2
import tempfile
import numpy as np
import openpifpaf

def handler(event):
    video_url = event.get("input", {}).get("video_url")
    if not video_url:
        return {"error": "Missing 'video_url' in input."}

    try:
        # הורדת הסרטון
        response = requests.get(video_url, stream=True)
        if response.status_code != 200:
            return {"error": "Failed to download video."}

        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as temp_video:
            for chunk in response.iter_content(chunk_size=8192):
                temp_video.write(chunk)
            video_path = temp_video.name

        # טעינת הסרטון
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            return {"error": "Cannot open downloaded video."}

        # אתחול openpifpaf
        predictor = openpifpaf.Predictor(checkpoint='resnet50')

        total_frames = 0
        detected_frames = 0

        while True:
            ret, frame = cap.read()
            if not ret:
                break
            total_frames += 1

            # המרה ל-RGB
            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            # ניתוח תנוחה
            predictions, _, _ = predictor.numpy_image(rgb)

            # אם נמצאה לפחות דמות אחת עם keypoints
            if predictions and len(predictions[0].data) > 0:
                detected_frames += 1

        cap.release()

        return {
            "message": "Video processed successfully!",
            "total_frames": total_frames,
            "frames_with_detections": detected_frames
        }

    except Exception as e:
        return {"error": str(e)}
