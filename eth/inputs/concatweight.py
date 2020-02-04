import sys
import fileinput
print sys.argv[-1]
outfile = sys.argv[-1]
print sys.argv[-2]
file1 = open(sys.argv[-2]).readlines()

for lines in file1:
    k=lines.split()
    print k[1]

print sys.argv[-3]
file2 = open(sys.argv[-3]).readlines()
for lines in file2:
    l=lines.split()
    print l[1]

m = str(format(float(k[1])+float(l[1]), '.6f'))
print m

with open(outfile, 'w') as fout:
    fout.write(k[0] + ' ' + m)
