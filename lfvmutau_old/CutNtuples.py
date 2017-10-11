#CutNtuple.py
#Author: Aaron Levine, UW Madison
#Copy events from original TTrees that pass the selected cuts. Significantly speeds up AnalyzeMuTauTightvbf.py



from sys import argv, stdout, stderr
import ROOT
import math
#Returns the number of lines in the files
def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

counter = 0



savename = argv[1]
#define the file
fname = "/afs/hep.wisc.edu/cms/aglevine/hlfv_5_3_9/src/UWHiggs/lfvmutau/inputs/MuTauSingleMuJetReReco/"+argv[1]+".txt"
numfiles = file_len(fname)
print "Processing: " + savename
with open(fname) as f:
	for x in f:
		if counter % 10 == 0:
			print "Processed " + str(counter) + " out of " + str(numfiles) + " files"
		#get file of current ntuples from input directory
		x = x.rstrip()
		new_fname = "/afs/hep.wisc.edu/cms/aglevine/hlfv_5_3_9/src/UWHiggs/lfvmutau/data/MuTauSingleMuJetReReco/"+savename+"/"+savename+"-"+str(counter)+".root"
		ntuple_file = ROOT.TFile(x)
		ntuple_file_spot = 'mt/final/Ntuple'
		tree = ntuple_file.Get(ntuple_file_spot)
		cut_str = "isoMu24eta2p1Pass && mPt > 30 && abs(mEta) <= 2.1 && tPt > 20 && abs(tEta) <= 2.3 && mPFIDTight  && abs(mDZ) < 0.2 && tAntiElectronLoose  && tAntiMuonTight2  && tDecayFinding && eVetoCicTightIso<1"
		Smalltree_file = ROOT.TFile(new_fname,"RECREATE","asdf")
		new_ttree = ROOT.TTree("new_ttree","new_ttree")
		new_ttree = tree.CopyTree(cut_str)
		new_ttree.SetName("New_Tree")
		#new_ttree.Print()
		tree.Delete()
		Smalltree_file.cd()
		new_ttree.Write("Overwrite")
		Smalltree_file.Write()
		if new_ttree.GetEntries() == 0:
			print new_ttree.GetEntries()
			

		
		counter = counter+1



