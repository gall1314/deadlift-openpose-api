# handler.py

import requests
import cv2
import tempfile
import numpy as np

def handler(event):
    video_url = event.get("input", {}).get("video_url")
    if not video_url:
        return {"error": "Missing 'video_url' in input."}

    try:
        # הורד את הסרטון
        response = requests.get(video_url, stream=True)
        if response.status_code != 200:
            return {"error": "Failed to download video."}

        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as temp_video:
            for chunk in response.iter_content(chunk_size=8192):
                temp_video.write(chunk)
            video_path = temp_video.name

        # פתח את הסרטון (כרגע רק בודק שנפתח)
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            return {"error": "Cannot open downloaded video."}
        
        frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        cap.release()

        return {
            "message": "Video processed successfully!",
            "frame_count": frame_count
        }

    except Exception as e:
        return {"error": str(e)}
