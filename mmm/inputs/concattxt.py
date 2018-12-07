import sys
import fileinput
outfile = sys.argv[-1]
filenames = [sys.argv[-2], sys.argv[-3]]
with open(outfile, 'w') as fout:
    fin = fileinput.input(filenames)
    for line in fin:
        fout.write(line)
    fin.close()
