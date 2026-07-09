# Keep 22.04 (jammy): python3 stays 3.10 to match the 2023-01-18 frozen state.
# "latest" (24.04 / python 3.12) breaks these pinned projects; 22.04 also has
# native aarch64, avoiding amd64-under-QEMU crashes on ARM hosts.
FROM ubuntu:22.04

WORKDIR /DyPyBench

RUN apt-get update

RUN apt-get install python3 -yq

RUN apt install python3-pip -yq

RUN apt install python3-virtualenv -yq

RUN apt install libjpeg8-dev -yq

RUN apt install git -yq

RUN apt install nano -yq

RUN apt-get install ffmpeg libavcodec-extra -yq

RUN pip install --upgrade pip setuptools wheel

COPY . .

RUN chmod -R 777 ./scripts 