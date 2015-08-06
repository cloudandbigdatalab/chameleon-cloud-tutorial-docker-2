# http://docs.opencv.org/3.0-last-rst/doc/tutorials/introduction/linux_install/linux_install.html

FROM python:2

MAINTAINER shawnmaten@gmail.com

RUN apt-get update -y

RUN apt-get install -y build-essential

RUN apt-get install -y cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

RUN apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

RUN apt-get install -y python-scipy
RUN pip install scikit-image

WORKDIR opencv-build

RUN curl https://codeload.github.com/Itseez/opencv/tar.gz/3.0.0 > opencv-3.0.0.tar.gz

RUN tar -xzvf opencv-3.0.0.tar.gz

RUN curl https://codeload.github.com/Itseez/opencv_contrib/tar.gz/3.0.0 > opencv_contrib-3.0.0.tar.gz

RUN tar -xzvf opencv_contrib-3.0.0.tar.gz

RUN rm opencv-3.0.0.tar.gz && rm opencv_contrib-3.0.0.tar.gz

WORKDIR /opencv-build/opencv-3.0.0/build/

RUN cmake -D CMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=/opencv-build/opencv_contrib-3.0.0/modules/ \
-D PYTHON2_EXECUTABLE=/usr/local/bin/python \
-D PYTHON_INCLUDE_DIR=/usr/local/include/python2.7 \
#-D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.4m/ \
-D PYTHON_LIBRARY=/usr/local/lib/libpython2.7.so \
-D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/lib/python2.7/dist-packages/numpy/core/include/ \
..

RUN make -j8

RUN make install

WORKDIR /

RUN rm -rf /opencv-build
