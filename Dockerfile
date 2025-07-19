FROM python:3.10

# למנוע אינטראקציה בהתקנת חבילות
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_BUILD_ISOLATION=1

# התקנת כל הספריות הנדרשות כולל libgl1
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    wget \
    unzip \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    libgl1-mesa-glx \
    libopencv-dev \
    python3-dev \
    tzdata

# תיקיית עבודה
WORKDIR /app

# העתקת הדרישות
COPY requirements.txt .

# התקנת pip וחבילות חשובות קודם (numpy, cython)
RUN pip install --upgrade pip && \
    pip install numpy cython && \
    pip install -r requirements.txt

# העתקת שאר הקבצים (כולל handler.py)
COPY . .

# נריץ את הקובץ דרך python (לא ישירות) כדי לעקוף בעיות BOM והרשאות
CMD python3 handler.py
