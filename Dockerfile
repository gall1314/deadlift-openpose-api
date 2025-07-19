FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

# שלב קריטי – התקנת git וכל התלויות לפני התקנת הדרישות
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

ENV PIP_NO_BUILD_ISOLATION=1

WORKDIR /app

# העתקת קובץ הדרישות והתקנה
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת שאר הקוד
COPY . .

CMD ["python", "handler.py"]
