import numpy
import sys

a = numpy.arange(1,100)

filename = sys.argv[0]

text_file = open("/outdir/" + filename, "a")
for i in a:
    text_file.write(str(i) + "\n")
text_file.close()
