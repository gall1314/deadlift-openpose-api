# Base image
FROM python:3.10

# Prevent tzdata from waiting for user input
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    wget \
    unzip \
    git \
    libopencv-dev \
    tzdata

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port if needed (for Flask)
EXPOSE 5000

# Run the handler script (RunPod expects this if using entrypoint "handler.py")
CMD ["python", "handler.py"]
