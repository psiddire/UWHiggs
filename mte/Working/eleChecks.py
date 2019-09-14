# import ROOT in batch mode
import sys
oldargv = sys.argv[:]
sys.argv = [ '-b-' ]
import ROOT
ROOT.gROOT.SetBatch(True)
sys.argv = oldargv

# load FWLite C++ libraries
ROOT.gSystem.Load("libFWCoreFWLite.so");
ROOT.gSystem.Load("libDataFormatsFWLite.so");
ROOT.FWLiteEnabler.enable()

# load FWlite python libraries
from DataFormats.FWLite import Handle, Events

# open file (you can use 'edmFileUtil -d /store/whatever.root' to get the physical file name)
events = Events("root://xrootd-cms.infn.it//store/mc/RunIIFall17MiniAODv2/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8/MINIAODSIM/PU2017_12Apr2018_94X_mc2017_realistic_v14-v1/90000/FAF5C76A-EA85-E811-A3D4-FA163E69288A.root")

electrons, electronLabel = Handle("std::vector<pat::Electron>"), "slimmedElectrons"



for i,event in enumerate(events):
    event.getByLabel(electronLabel, electrons)
    #print "\nEvent", i
    
    for ie,el in enumerate(electrons.product()):
        if el.pt() < 5: continue
        if el.electronID("mvaEleID-Fall17-noIso-V1-wp80")< 0.5 : continue
        corrEt = el.et() * el.userFloat("ecalEnergyPostCorr")/el.ecalEnergy();
        print i, ':', el.et(), el.pt(), el.userFloat("ecalEnergyPreCorr") , el.userFloat("ecalEnergyPostCorr"), el.energy(), el.ecalEnergy(), corrEt
        
    if i > 100: break


