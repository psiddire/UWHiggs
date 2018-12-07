import sys
inFile = sys.argv[-1]

with open(inFile,'r') as i:
    lines = i.readlines()

print lines

print 1.0/float(lines[0])
