FROM python:2

MAINTAINER shawnmaten@gmail.com

RUN pip install numpy

WORKDIR /workdir/

RUN mkdir /outdir/

COPY example.py ./

CMD ["python", "example.py", "$OUTPUT_FILE"]
