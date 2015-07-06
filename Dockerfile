FROM ubuntu

MAINTAINER shawnmaten@gmail.com

RUN apt-get update && apt-get upgrade && apt-get dist-upgrade && apt-get autoremove

# build tools
RUN apt-get install build-essential cmake

# media i/o
RUN apt-get install zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

# video i/o
RUN apt-get install libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# parallelism and linear algebra
RUN apt-get install libtbb-dev libeigen3-dev

# python
RUN apt-get install python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

# documentation
RUN apt-get install doxygen sphinx-common texlive-latex-extra

RUN git clone https://github.com/Itseez/opencv.git

WORKDIR opencv/build

RUN cmake -DWITH_OPENGL=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON ..

RUN make -j4

RUN make install

RUN ldconfig
