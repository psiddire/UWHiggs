from ROOT import *
import os
import sys

def GetContent(dir):
    tempList = dir.GetListOfKeys()
    retList = []
    for it in range(0,tempList.GetSize()):
       retList.append(tempList.At(it).ReadObj())
    return retList

def MapDirStructure( directory, dirName, objectList ):
    dirContent = GetContent(directory)
    for entry in dirContent:
        if type(entry) is TDirectory or type(entry) is TDirectoryFile:
            subdirName = os.path.join(dirName,entry.GetName())
            MapDirStructure(entry, subdirName,objectList)
        else:
            pathname = os.path.join(dirName,entry.GetName())
            objectList.append(pathname)


files = filter(lambda x: '.root' in x,sys.argv)
for f in files:
    print 'file: %s' % f
    tfile = TFile.Open(f)
    if not tfile:
        print '\t%s cannot be opened! Skipping' % f
        continue
    histos = []
    MapDirStructure(tfile,'',histos)
    if len(histos) == 0:
        print '\tNo histos found!'
    for h in histos:
        th = tfile.Get(h)
        if isinstance(th, TH1):
            if th.GetEntries() == 0:
                print '\thisto %s empty!' % h
            else:
                print '\thisto %s with %s entries!' % (h, th.GetEntries() )
    tfile.Close()
