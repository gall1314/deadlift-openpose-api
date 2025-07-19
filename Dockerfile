FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

# הוספת משתנים שמונעים בנייה מקומית של חבילות
ENV PIP_NO_BUILD_ISOLATION=1
ENV PIP_ONLY_BINARY=:all:

# התקנת ספריות מערכת
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    wget \
    unzip \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    libopencv-dev \
    tzdata

# תיקיית עבודה
WORKDIR /app

# העתקת הדרישות
COPY requirements.txt .

# התקנת חבילות פייתון (רק בינאריות, ללא קומפילציה)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת שאר הקבצים
COPY . .

# קובץ ראשי להרצה
CMD ["python", "handler.py"]
