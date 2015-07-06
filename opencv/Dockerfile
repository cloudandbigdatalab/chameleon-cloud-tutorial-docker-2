# http://docs.opencv.org/3.0-last-rst/doc/tutorials/introduction/linux_install/linux_install.html

FROM ubuntu

MAINTAINER shawnmaten@gmail.com

RUN apt-get update -y

RUN apt-get install -y build-essential

RUN apt-get install -y cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

RUN apt-get install -y python3.4 python3.4-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

WORKDIR opencv-build

RUN curl https://codeload.github.com/Itseez/opencv/tar.gz/3.0.0 > opencv-3.0.0.tar.gz

RUN tar -xzvf opencv-3.0.0.tar.gz

RUN curl https://codeload.github.com/Itseez/opencv_contrib/tar.gz/3.0.0 > opencv_contrib-3.0.0.tar.gz

RUN tar -xzvf opencv_contrib-3.0.0.tar.gz

RUN ls

# RUN rm opencv-3.0.0.tar.gz && rm opencv_contrib-3.0.0.tar.gz
