# taken from http://milq.github.io/install-opencv-ubuntu-debian/

FROM ubuntu

MAINTAINER shawnmaten@gmail.com

RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y

# build tools
RUN apt-get install -y build-essential cmake

# media i/o
RUN apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

# video i/o
RUN apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# parallelism and linear algebra
RUN apt-get install -y libtbb-dev libeigen3-dev

# python
RUN apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

# documentation
RUN apt-get install -y doxygen sphinx-common texlive-latex-extra

# git
RUN apt-get install -y git

RUN git clone https://github.com/Itseez/opencv.git

RUN git clone https://github.com/Itseez/opencv_contrib.git

WORKDIR opencv/build

RUN cmake -DWITH_OPENGL=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules -DBUILD_opencv_legacy=OFF ..

RUN make -j5

RUN make install

RUN ldconfig

WORKDIR /
