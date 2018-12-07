from trees import tree_manager   
from ROOT import TFile

def testfun():
    print 'hi'

def thing(a,b,c):
    print a,b,c

f = TFile.Open('Data_WgammaEle_noSihih.root')
tree = f.Get('DataTree')
tm = tree_manager()
tm.importTree('test',tree)

tm['test'].GetEntry(1)

print tm['test'].run, tm['test'].lumis, tm['test'].event
