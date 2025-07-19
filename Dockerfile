# Base image
FROM python:3.10

# Avoid tzdata hanging
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages required for video and deep learning
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

# Set working directory
WORKDIR /app

# Copy dependencies
COPY requirements.txt .

# Install Python dependencies (split for reliability)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install OpenPifPaf separately to prevent breaking chain
RUN pip install openpifpaf

# Copy the rest of the code
COPY . .

# Run handler
CMD ["python", "handler.py"]
