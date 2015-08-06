import numpy

a = numpy.array[range(1,100)]

filename = sys.argv[0]

text_file = open("/outdir/" + filename, "a")
for i in a:
    text_file.write(str(a) + "\n")
text_file.close()
