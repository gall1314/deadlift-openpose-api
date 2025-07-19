FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV PIP_NO_BUILD_ISOLATION=1

# התקנת Python וכל התלויות
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    ffmpeg \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    wget \
    unzip \
    git \
    cmake \
    build-essential \
    tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --upgrade pip && \
    pip3 install numpy cython && \
    pip3 install -r requirements.txt

COPY . .

CMD ["python3", "handler.py"]

