FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_BUILD_ISOLATION=1

# התקנת git וכל שאר התלויות לפני הרצת pip
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

WORKDIR /app

COPY requirements.txt .

# לוודא שה-git באמת מותקן כאן
RUN git --version

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "handler.py"]
