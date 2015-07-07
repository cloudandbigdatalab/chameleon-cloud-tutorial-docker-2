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

RUN rm opencv-3.0.0.tar.gz && rm opencv_contrib-3.0.0.tar.gz

WORKDIR /opencv-build/opencv-3.0.0/build/

RUN cmake -D CMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=/opencv-build/opencv_contrib-3.0.0/modules/ \
-D PYTHON3_EXECUTABLE=/usr/bin/python3 \
-D PYTHON_INCLUDE_DIR=/usr/include/python3.4 \
-D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.4m/ \
-D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.4m.so \
-D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
..

RUN make -j8

RUN make install

WORKDIR /

RUN rm -rf /opencv-build

RUN apt-get install -y python3-pip python-django

RUN pip3 install uwsgi

EXPOSE 3031

COPY opencv /opencv/

CMD /usr/local/bin/uwsgi /opencv/opencv.ini
