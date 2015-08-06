FROM python:2

MAINTAINER shawnmaten@gmail.com

RUN pip install numpy

WORKDIR /workdir/

COPY example.py ./

CMD ["python", "example.py", "$OUTPUT_FILE"]
