FROM python:3.10

# למנוע בעיות התקנה
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_BUILD_ISOLATION=1

# התקנת git לפני הכל
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

# תיקיית העבודה
WORKDIR /app

# העתקת דרישות ההתקנה
COPY requirements.txt .

# בדיקה שה־git באמת מותקן
RUN git --version

# התקנת תלויות
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת הקוד
COPY . .

# הרצה
CMD ["python", "handler.py"]
