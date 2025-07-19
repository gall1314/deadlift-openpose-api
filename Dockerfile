FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_BUILD_ISOLATION=1

RUN apt-get update && apt-get install -y     git     cmake     build-essential     wget     unzip     ffmpeg     libsm6     libxext6     libgl1-mesa-glx     libopencv-dev     python3-dev     tzdata

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip &&     pip install numpy cython &&     pip install -r requirements.txt

COPY . .

# בדיקת נוכחות handler.py לפני הרצה
RUN ls -l /app

CMD ["python3", "-u", "/app/handler.py"]

