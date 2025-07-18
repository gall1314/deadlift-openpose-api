# Dockerfile for OpenPose Flask API on RunPod

FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    unzip \
    libopencv-dev \
    python3-dev \
    python3-pip \
    python3-opencv \
    libprotobuf-dev \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Set Python aliases
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

# Download and build OpenPose
WORKDIR /app
RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git && \
    cd openpose && \
    git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake .. -DBUILD_PYTHON=OFF -DBUILD_EXAMPLES=OFF -DUSE_CUDNN=ON && \
    make -j"$(nproc)"

# Copy application code
COPY app.py /app/app.py
RUN mkdir /app/media

# Expose API port
EXPOSE 5000

# Start app
CMD ["python", "/app/app.py"]
