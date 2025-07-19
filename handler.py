import requests
import cv2
import tempfile

def handler(event):
    video_url = event.get("input", {}).get("video_url")
    if not video_url:
        return {"error": "Missing 'video_url'"}

    try:
        response = requests.get(video_url, stream=True)
        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
            path = f.name

        cap = cv2.VideoCapture(path)
        if not cap.isOpened():
            return {"error": "Cannot open video"}

        return {"frame_count": int(cap.get(cv2.CAP_PROP_FRAME_COUNT))}
    except Exception as e:
        return {"error": str(e)}

