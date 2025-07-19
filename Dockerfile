FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV PIP_NO_BUILD_ISOLATION=1

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    git \
    ffmpeg \
    wget \
    unzip \
    cmake \
    build-essential \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    tzdata

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --upgrade pip && \
    pip3 install numpy cython && \
    pip3 install -r requirements.txt

COPY . .

CMD ["python3", "handler.py"]
