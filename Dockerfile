FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

# התקנת כל הספריות הדרושות, כולל git ל-openpifpaf
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

# עבודה בתיקיית /app
WORKDIR /app

# העתקת דרישות
COPY requirements.txt .

# התקנת כל הספריות
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת שאר הקבצים (כולל handler.py)
COPY . .

# הרצת הסקריפט הראשי
CMD ["python", "handler.py"]
