FROM python:3.10

# להימנע משאלות התקנה
ENV DEBIAN_FRONTEND=noninteractive

# התקנת כל התלויות הדרושות כולל git
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

# משתנים שמאפשרים לבנות openpifpaf מהמקור
ENV PIP_NO_BUILD_ISOLATION=1

# תיקיית העבודה
WORKDIR /app

# העתקת דרישות ההתקנה
COPY requirements.txt .

# התקנת pip ותלויות
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# העתקת שאר הקוד
COPY . .

# הרצת הקובץ הראשי
CMD ["python", "handler.py"]
