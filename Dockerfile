FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

# אפשר התקנת בינאריות בלבד, חוץ מ־openpifpaf
ENV PIP_NO_BUILD_ISOLATION=1
ENV PIP_ONLY_BINARY=:all:
ENV PIP_NO_BINARY=openpifpaf

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

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

CMD ["python", "handler.py"]
