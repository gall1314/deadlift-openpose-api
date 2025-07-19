FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

# התקנת git (נדרש עבור openpifpaf מה-GitHub)
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

# מונע בעיות בידוד בעת בנייה של חבילות כמו openpifpaf
ENV PIP_NO_BUILD_ISOLATION=1

WORKDIR /app

COPY requirements.txt .

# התקנת pip והדרישות
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

CMD ["python", "handler.py"]
