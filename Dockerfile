FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_BUILD_ISOLATION=1

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
    python3-dev \
    tzdata

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install numpy cython && \
    pip install -r requirements.txt

# 👇 שלב קריטי: הורדה ידנית של openpifpaf
RUN git clone --branch v0.13.7 https://github.com/openpifpaf/openpifpaf.git && \
    pip install ./openpifpaf

COPY . .

CMD ["python", "handler.py"]
