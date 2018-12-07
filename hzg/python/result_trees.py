from UWHiggs.hzg.MOOSEY.trees import tree_manager

from ROOT import TLorentzVector
import ctypes as ct
from array import array
import math


z_info = {'procWeight':0,'puWeight':0,'run':0,'lumis':0,'event':0,
          'z':TLorentzVector(),
          'ell1':TLorentzVector(),'ell2':TLorentzVector(),
          'ell1ScaleFac':0,'ell2ScaleFac':0,
          'nGoodVtx':0}
def bestZTree(event,tm):
    bestZ = event.bestZ
    z_info['procWeight'] = event.procWeight
    z_info['puWeight'] = event.puWeight
    
    z_info['run']   = event.run[bestZ]
    z_info['lumis'] = event.lumi[bestZ]
    z_info['event'] = event.evt[bestZ]

    z_info['nGoodVtx'] = event.nvtx[bestZ]

    z_info['ell1ScaleFac'] = event.ell1SF
    z_info['ell1'].SetXYZT(event.ell1[bestZ].X(),
                           event.ell1[bestZ].Y(),
                           event.ell1[bestZ].Z(),
                           event.ell1[bestZ].T())
    z_info['ell1Pt']  = event.ell1[bestZ].Pt()
    z_info['ell1Eta'] = event.ell1[bestZ].Eta()
    z_info['ell1Phi'] = event.ell1[bestZ].Phi()

    z_info['ell2ScaleFac'] = event.ell2SF
    z_info['ell2'].SetXYZT(event.ell2[bestZ].X(),
                           event.ell2[bestZ].Y(),
                           event.ell2[bestZ].Z(),
                           event.ell2[bestZ].T())
    z_info['ell2Pt']  = event.ell2[bestZ].Pt()
    z_info['ell2Eta'] = event.ell2[bestZ].Eta()
    z_info['ell2Phi'] = event.ell2[bestZ].Phi()

    z_info['z'].SetXYZT(event.Z[bestZ].X(),
                        event.Z[bestZ].Y(),
                        event.Z[bestZ].Z(),
                        event.Z[bestZ].T())                        
    z_info['zMass']     = event.Z[bestZ].M()
    z_info['zPt']       = event.Z[bestZ].Pt()
    z_info['zRapidity'] = event.Z[bestZ].Rapidity()

    tm.fillTree('selected_z',z_info)


zg_info = {'procWeight':0,'puWeight':0,'run':0,'lumis':0,'event':0,
           'ell1':TLorentzVector(),'ell2':TLorentzVector(),
           'ell1SCEta':0,'ell2SCEta':0,
           'pho':TLorentzVector(),
           'phoPt':0,'phoSCEta':0,
           'ell1ScaleFac':0,'ell2ScaleFac':0,'phoScaleFac':0,
           'phoR9':0,'phoSihih':0,
           'z':TLorentzVector(),'zg':TLorentzVector(),
           'ell1Pho':TLorentzVector(),'ell2Pho':TLorentzVector(),
           'minDeltaREllPho':0,'nGoodVtx':0,
           'Mzg':0,'Mz':0,'dMzg':0,'dMz':0,
           'r94cat':0,'r94cat_mod':0,
           'phoPdgId':0,'phoMomPdgId':0,'phoFromHiggs':0#,
           #'nPLJet':0,
           #'plJetFoE':array('d',[0 for i in range(15)]),
           #'plJetPt' :array('d',[0 for i in range(15)]),
           #'plJetEta':array('d',[0 for i in range(15)]),
           #'plJetPhi':array('d',[0 for i in range(15)])
           }

def bestZGTree(event,tm):
    bestZ = event.bestZ
    bestPho = event.bestPho

    zg_info['r94cat'] = event.bestZG_r94cat
    zg_info['r94cat_mod'] = event.bestZG_r94cat_mod

    if hasattr(event,'e1SCEta'):
        zg_info['ell1SCEta'] = event.e1SCEta[bestZ]
        zg_info['ell2SCEta'] = event.e2SCEta[bestZ]
    else:
        zg_info['ell1SCEta'] = 0.0
        zg_info['ell2SCEta'] = 0.0
    
    zg_info['procWeight'] = event.procWeight
    zg_info['puWeight'] = event.puWeight

    zg_info['run']   = event.run[bestZ]
    zg_info['lumis'] = event.lumi[bestZ]
    zg_info['event'] = event.evt[bestZ]

    zg_info['nGoodVtx'] = event.nvtx[bestZ]

    zg_info['ell1ScaleFac'] = event.ell1SF    
    zg_info['ell1'].SetXYZT(event.ell1[bestZ].X(),
                            event.ell1[bestZ].Y(),
                            event.ell1[bestZ].Z(),
                            event.ell1[bestZ].T())
    
    zg_info['ell2ScaleFac'] = event.ell2SF
    zg_info['ell2'].SetXYZT(event.ell2[bestZ].X(),
                            event.ell2[bestZ].Y(),
                            event.ell2[bestZ].Z(),
                            event.ell2[bestZ].T())    

    zg_info['phoScaleFac'] = event.phoSF
    zg_info['pho'].SetXYZT(event.gam[bestPho].X(),
                           event.gam[bestPho].Y(),
                           event.gam[bestPho].Z(),
                           event.gam[bestPho].T())
    zg_info['phoPt']    = zg_info['pho'].Pt()
    zg_info['phoSCEta'] = event.gSCEta[bestPho]
    zg_info['phoSihih'] = event.gSigmaIEtaIEta[bestPho]
    zg_info['phoR9'] = event.gR9[bestPho]
    zg_info['phoPdgId'] = event.gPdgId[bestPho]
    zg_info['phoMomPdgId'] = event.gGenMotherPdgId[bestPho]
    zg_info['phoFromHiggs'] = event.gComesFromHiggs[bestPho]

    #zg_info['nPLJet'] = len(event.PLJets)
    #for i in range(15):
    #    zg_info['plJetFoE'][i]  = 0.0
    #    zg_info['plJetPt'][i]  = 0.0
    #    zg_info['plJetEta'][i] = 0.0
    #    zg_info['plJetPhi'][i] = 0.0
    #for i,idx in enumerate(event.PLJets):
    #    zg_info['plJetFoE'][i]  = event.phoFoE[idx]
    #    zg_info['plJetPt'][i]  = event.phoCorEt[idx]
    #    zg_info['plJetEta'][i] = event.phoEta[idx]
    #    zg_info['plJetPhi'][i] = event.phoPhi[idx]
        
    
    zg_info['z'].SetXYZT(event.Z[bestZ].X(),
                         event.Z[bestZ].Y(),
                         event.Z[bestZ].Z(),
                         event.Z[bestZ].T())
    zg_info['Mz'] = zg_info['z'].M()
    zg_info['dMz'] = math.hypot(event.MassErrord1[bestZ],
                                event.MassErrord2[bestZ])

    zg_info['zg'].SetXYZT(event.bestZG.X(),
                          event.bestZG.Y(),
                          event.bestZG.Z(),
                          event.bestZG.T())
    zg_info['Mzg'] = zg_info['zg'].M()
    zg_info['dMzg'] = event.MassError[bestZ]
    

    ell1Pho = event.ell1[bestZ] + event.gam[bestPho]
    zg_info['ell1Pho'].SetXYZT(ell1Pho.X(),
                               ell1Pho.Y(),
                               ell1Pho.Z(),
                               ell1Pho.T())    
    
    ell2Pho = event.ell2[bestZ] + event.gam[bestPho]
    zg_info['ell2Pho'].SetXYZT(ell2Pho.X(),
                               ell2Pho.Y(),
                               ell2Pho.Z(),
                               ell2Pho.T())
    
    zg_info['minDeltaREllPho'] = min(event.gam[bestPho].DeltaR(event.ell1[bestZ]),
                                     event.gam[bestPho].DeltaR(event.ell2[bestZ]))

    tm.fillTree('selected_zg',zg_info)

def bestZGTreeNoSihih(event,tm):
    bestZ = event.bestZ
    zg_info['procWeight'] = event.procWeight
    zg_info['puWeight'] = event.puWeight
    
    zg_info['run']   = event.run
    zg_info['lumis'] = event.lumi
    zg_info['event'] = event.evt
    
    zg_info['nGoodVtx'] = event.nGoodVtx
    
    zg_info['ell1ScaleFac'] = event.ell1SF
    zg_info['ell1'].SetXYZT(event.ell1[bestZ].X(),
                            event.ell1[bestZ].Y(),
                            event.ell1[bestZ].Z(),
                            event.ell1[bestZ].T())    
    
    zg_info['ell2ScaleFac'] = event.ell2SF
    zg_info['ell2'].SetXYZT(event.ell2[bestZ].X(),
                            event.ell2[bestZ].Y(),
                            event.ell2[bestZ].Z(),
                            event.ell2[bestZ].T())    
    
    zg_info['phoScaleFac'] = event.phoNoSihihSF
    zg_info['pho'].SetXYZT(event.bestPhoNoSihih.X(),
                           event.bestPhoNoSihih.Y(),
                           event.bestPhoNoSihih.Z(),
                           event.bestPhoNoSihih.T())
    zg_info['phoPt']    = zg_info['pho'].Pt()
    zg_info['phoSCEta'] = event.gSCEta[event.bestPhoNoSihihIdx]
    zg_info['phoSihih'] = event.gSigmaIEtaIEta[event.bestPhoNoSihihIdx]
    zg_info['phoR9'] = event.gr9[event.bestPhoNoSihihIdx]
        
    zg_info['z'].SetXYZT(event.bestZ.X(),
                         event.bestZ.Y(),
                         event.bestZ.Z(),
                         event.bestZ.T())            

    zg_info['zg'].SetXYZT(event.bestZGNoSihih.X(),
                          event.bestZGNoSihih.Y(),
                          event.bestZGNoSihih.Z(),
                          event.bestZGNoSihih.T())
    
    ell1Pho = event.ell1[bestZ] + event.bestPhoNoSihih
    zg_info['ell1Pho'].SetXYZT(ell1Pho.X(),
                               ell1Pho.Y(),
                               ell1Pho.Z(),
                               ell1Pho.T())    
    
    ell2Pho = event.ell2[bestZ] + event.bestPhoNoSihih
    zg_info['ell2Pho'].SetXYZT(ell2Pho.X(),
                               ell2Pho.Y(),
                               ell2Pho.Z(),
                               ell2Pho.T())
        
    zg_info['minDeltaREllPho'] = min(event.bestPhoNoSihih.DeltaR(event.ell1[bestZ]),
                                     event.bestPhoNoSihih.DeltaR(event.ell2[bestZ]))
    
    tm.fillTree('selected_zg_nosihih',zg_info)
