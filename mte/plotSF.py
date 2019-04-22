import os
from sys import argv, stdout, stderr                                                                                                                                                                                                                                           
from ROOT import gROOT, TFile, TList, TObject, TH1F 
import mcCorrections
import sys                                                                                                                                                                                                                                                                    
gROOT.SetStyle("Plain")                                                                                                                                                                                                                                                       
gROOT.SetBatch(True)    
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

f1 = TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v1.root")
w1 = f1.Get("w")

f2 = TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
w2 = f2.Get("w")

f3 = TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v3.root")
w3 = f3.Get("w")

fe = TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v17_5.root")
we = fe.Get("w")

triggerEff = mcCorrections.efficiency_trigger_mu_2017
muonTightID = mcCorrections.muonID_tight
muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
eReco = mcCorrections.eReco

hmIso1 = TH1F("hmIso1","hmIso1",199,1,200) 
hmID1 = TH1F("hmID1","hmID1",199,1,200)
hmTrg1 = TH1F("hmTrg1","hmTrg1",199,1,200)
hmIso2 = TH1F("hmIso2","hmIso2",199,1,200)
hmID2 = TH1F("hmID2","hmID2",199,1,200)
hmTrg2 = TH1F("hmTrg2","hmTrg2",199,1,200)

heIso1 = TH1F("heIso1","heIso1",199,1,200)
heID1 = TH1F("heID1","heID1",199,1,200)                                                                                                                                                                                                                                        
heTrk1 = TH1F("heTrk1","heTrk1",199,1,200)                                                                                                                                                                                                                                    
heID2 = TH1F("heID2","heID2",199,1,200)                                                                                                                                                                                                                                       
heTrk2 = TH1F("heTrk2","heTrk2",199,1,200) 

f = TFile("histlist.root","RECREATE")

j  = 0.5

for i in range(1, 200):
    w2.var("m_pt").setVal(i)
    w2.var("m_eta").setVal(j)
    hmIso1.Fill(i, w2.function("m_iso_kit_ratio").getVal())
    hmID1.Fill(i, w2.function("m_id_kit_ratio").getVal())
    hmTrg1.Fill(i, w2.function("m_trg27_kit_data").getVal()/w2.function("m_trg27_kit_mc").getVal())
    
    hmTrg2.Fill(i, triggerEff(i, j))
    hmID2.Fill(i, muonTightID(i, j)) 
    hmIso2.Fill(i, muonTightIsoTightID(i, j)) 

for i in range(1, 200):
    w2.var("e_pt").setVal(i)
    w2.var("e_eta").setVal(j)                                                                                                                                                                                                                                  
    heIso1.Fill(i, w2.function("e_iso_kit_ratio").getVal())                                                                                                                                                                                                                   
    heID1.Fill(i, w2.function("e_id80_kit_ratio").getVal())                                                                                                                                                                                                                  
    heTrk1.Fill(i, w2.function("e_trk_ratio").getVal())  
    
    heID2.Fill(i, eIDnoIsoWP80(i, j))
    heTrk2.Fill(i, eReco(i, j))

#hmIso1.Draw()
hmIso1.Write() 

#hmID1.Draw()                                                                                                                                                                                                                                                                  
hmID1.Write()                                                                                                                                                                                                                                                                  

#hmTrg1.Draw()
hmTrg1.Write()

#hmIso2.Draw()                                                                                                                                                                                                                                                                 
hmIso2.Write()  

#hmID2.Draw()                                                                                                                                                                                                                                                                  
hmID2.Write()                                                                                                                                                                                                                                                                  

#hmTrg2.Draw()                                                                                                                                                                                                                                                                 
hmTrg2.Write()

#heIso1.Draw()                                                                                                                                                                                                                                                                 
heIso1.Write()

#heID1.Draw()                                                                                                                                                                                                                                                                  
heID1.Write()

#heTrk1.Draw()                                                                                                                                                                                                                                                                
heTrk1.Write()

#heID2.Draw()                                                                                                                                                                                                                                                                  
heID2.Write()

#heTrk2.Draw()                                                                                                                                                                                                                                                                 
heTrk2.Write()

f.Print()
