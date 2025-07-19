# Base image
FROM python:3.10

# Avoid tzdata hanging
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
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

# Install Python + ML packages
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install \
        requests \
        flask \
        torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install openpifpaf

# Copy project files
COPY . .

# Run handler script
CMD ["python", "handler.py"]

