FROM python:3.10

# להימנע משאלות התקנה
ENV DEBIAN_FRONTEND=noninteractive

# התקנת כל התלויות הדרושות, כולל git (חשוב!)
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    wget \
    unzip \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    libopencv-dev \
    tzdata

# מאפשר התקנה מהמקור בלי בידוד
ENV PIP_NO_BUILD_ISOLATION=1

# מאלץ בנייה מחדש – כדי לשבור קאש
ENV FORCE_REBUILD=1

# תיקיית עבודה
WORKDIR /app

# העתקת קובץ הדרישות
COPY requirements.txt .

# התקנת pip ותלויות
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת הקוד שלך
COPY . .

# הפעלת ההנדלר
CMD ["python", "handler.py"]
