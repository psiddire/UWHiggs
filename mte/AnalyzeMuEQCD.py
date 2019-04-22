'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import itertools
import operator
import mcCorrections
from RecoilCorrector import RecoilCorrector
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
import FinalStateAnalysis.TagAndProbe.NvtxWeight as NvtxWeight
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v1.root")
w1 = f1.Get("w")

f2 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
w2 = f2.Get("w")

f3 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v3.root")
w3 = f3.Get("w")

fe = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v17_5.root")
we = fe.Get("w")

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)
  
def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)

def visibleMass(row):
  vm = ROOT.TLorentzVector()
  ve = ROOT.TLorentzVector()
  vm.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
  ve.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
  return (vm+ve).M()

def collMass(row, tmpMET):
  met = tmpMET[0]
  metPhi = tmpMET[1]
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row.ePhi)))
  visfrac = row.ePt/(row.ePt+ptnu)
  m_e_Mass = visibleMass(row)
  return (m_e_Mass/sqrt(visfrac))

def transverseMass(objPt, objEta, objPhi, objMass, MetEt, MetPhi):
  vobj = ROOT.TLorentzVector()
  vmet = ROOT.TLorentzVector()
  vobj.SetPtEtaPhiM(objPt, objEta, objPhi, objMass)
  vmet.SetPtEtaPhiM(MetEt, 0, MetPhi, 0)
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def topPtreweight(pt1, pt2):
  if pt1 > 400 : pt1 = 400
  if pt2 > 400 : pt2 = 400
  a = 0.0615
  b = -0.0005
  wt1 = math.exp(a + b * pt1)
  wt2 = math.exp(a + b * pt2)
  wt = sqrt(wt1 * wt2)
  return wt

if bool('DYJetsToLL_M-50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY10')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY4')
elif bool('WJetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W')
elif bool('W1JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W1')
elif bool('W2JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W2')
elif bool('W3JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W3')
elif bool('W4JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W4')
elif bool('WGToLNuG' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WG')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZZ')
elif bool('EWKWMinus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wminusv2')
elif bool('EWKWPlus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wplusv2')
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Zllv2')
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Znunuv2')
elif bool('ZHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZHTT')
elif bool('ttHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ttH')
elif bool('Wminus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WminusHTT')
elif bool('Wplus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WplusHTT')
elif bool('ST_t-channel_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtantitop')
elif bool('ST_t-channel_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STttop')
elif bool('ST_tW_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWantitop')
elif bool('ST_tW_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWtop')
elif bool('TTTo2L2Nu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTTo2L2Nu')
elif bool('TTToHadronic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToHadronic')
elif bool('TTToSemiLeptonic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToSemiLeptonic')
elif bool('VBFHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHTT')
elif bool('VBF_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHMT')
elif bool('GluGluHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHTTv2')
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHMT')
elif bool('QCD' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'QCD')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')

class AnalyzeMuEQCD(MegaBase):
  tree = 'em/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_embed = target.startswith('embedded_')
    self.is_mc = not self.is_data and not self.is_embed
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_GluGlu = bool('GluGlu_LFV' in target)
    self.is_VBF = bool('VBF_LFV' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WG = bool('WGToLNuG' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.is_EWKWMinus = bool('EWKWMinus' in target)
    self.is_EWKWPlus = bool('EWKWPlus' in target)
    self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
    self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
    self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
    self.is_ZHTT = bool('ZHToTauTau' in target)
    self.is_ttH = bool('ttHToTauTau' in target)
    self.is_Wminus = bool('Wminus' in target)
    self.is_Wplus = bool('Wplus' in target)
    self.is_STtantitop = bool('ST_t-channel_antitop' in target)
    self.is_STttop = bool('ST_t-channel_top' in target)
    self.is_STtWantitop = bool('ST_tW_antitop' in target)
    self.is_STtWtop = bool('ST_tW_top' in target)
    self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
    self.is_TTToHadronic = bool('TTToHadronic' in target)
    self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
    self.is_VBFH = bool('VBFHToTauTau' in target)
    self.is_GluGluH = bool('GluGluHToTauTau' in target)
    self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_W)
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeMuEQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}

    self.DYweight = {
      0 : 2.667,
      1 : 0.465803642,
      2 : 0.585042564,
      3 : 0.609127575,
      4 : 0.419146762
      }

    self.Wweight = {
      0 : 33.17540884,
      1 : 7.148659335,
      2 : 14.08112642,
      3 : 2.308770158,
      4 : 2.072164726
      }

  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 28 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 10 or abs(row.eEta) >= 2.4:
      return False
    return True


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20TightMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045)) 
  

  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
    

  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj1_loose(self, row):                                                                                                                                                                                                                                                  
    return bool(row.mRelPFIsoDBDefaultR04 < 0.5)                                                                                                                                                                                                                               
  
  def obj2_loose(self, row):                                                                                                                                                                                                           
    return bool(row.eRelPFIsoRho < 0.5) 


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2)) 


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Medium < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names=['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet', 'TightOS2Jet', 'TightSS2Jet']
    vbfnames=['TightOS2JetVBF', 'TightSS2JetVBF']
    namesize = len(names)
    vbfnamesize = len(vbfnames)

    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 20, 0, 200)
      self.book(names[x], "ePt", "Electron Pt", 20, 0, 200)
      self.book(names[x], "mEta", "Muon Eta", 20, -3, 3)
      self.book(names[x], "eEta", "Electron Eta", 20, -3, 3)
      self.book(names[x], "mPhi", "Muon Phi", 20, -4, 4)
      self.book(names[x], "ePhi", "Electron Phi", 20, -4, 4)
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
      self.book(names[x], "type1_pfMetPhi", "Type1 MET Phi", 20, -4, 4)
      self.book(names[x], "m_e_Mass", "Muon + Electron Mass", 30, 0, 300)
      self.book(names[x], "m_e_CollinearMass", "Muon + Electron Collinear Mass", 30, 0, 300)      
      self.book(names[x], "numOfJetsWO", "Number of Jets WO", 5, 0, 5) 
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "dEtaMuE", "Delta Eta Mu E", 50, 0, 5)
      self.book(names[x], "dPhiEMET", "Delta Phi E MET", 40, 0, 4)
      self.book(names[x], "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(names[x], "dPhiMuE", "Delta Phi Mu E", 40, 0, 4)
      self.book(names[x], "MTEMET", "Electron MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTMuMET", "Mu MET Transverse Mass", 20, 0, 200)

    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], "mPt", "Muon  Pt", 10, 0, 200)
      self.book(vbfnames[x], "ePt", "Electron Pt", 10, 0, 200)
      self.book(vbfnames[x], "mEta", "Muon Eta", 10, -3, 3)
      self.book(vbfnames[x], "eEta", "Electron Eta", 10, -3, 3)
      self.book(vbfnames[x], "mPhi", "Muon Phi", 10, -4, 4)
      self.book(vbfnames[x], "ePhi", "Electron Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
      self.book(vbfnames[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "m_e_Mass", "Muon + Electron Mass", 15, 0, 300)
      self.book(vbfnames[x], "m_e_CollinearMass", "Muon + Electron Collinear Mass", 15, 0, 300)
      self.book(vbfnames[x], "numOfJetsWO", "Number of Jets WO", 5, 0, 5) 
      self.book(vbfnames[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(vbfnames[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(vbfnames[x], "dEtaMuE", "Delta Eta Mu E", 25, 0, 5)
      self.book(vbfnames[x], "dPhiEMET", "Delta Phi E MET", 20, 0, 4)
      self.book(vbfnames[x], "dPhiMuMET", "Delta Phi Mu MET", 20, 0, 4)
      self.book(vbfnames[x], "dPhiMuE", "Delta Phi Mu E", 20, 0, 4)
      self.book(vbfnames[x], "MTEMET", "Electron MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "MTMuMET", "Mu MET Transverse Mass", 10, 0, 200)

  def fill_histos(self, row, tmpMET, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(row.mPt, weight)
    histos[name+'/ePt'].Fill(row.ePt, weight)
    histos[name+'/mEta'].Fill(row.mEta, weight)
    histos[name+'/eEta'].Fill(row.eEta, weight)
    histos[name+'/mPhi'].Fill(row.mPhi, weight)
    histos[name+'/ePhi'].Fill(row.ePhi, weight)
    histos[name+'/type1_pfMetEt'].Fill(tmpMET[0], weight)
    histos[name+'/type1_pfMetPhi'].Fill(tmpMET[1], weight)
    histos[name+'/m_e_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_e_CollinearMass'].Fill(collMass(row, tmpMET), weight)
    histos[name+'/numOfJetsWO'].Fill(row.jetVeto30WoNoisyJets, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuE'].Fill(deltaEta(row.mEta, row.eEta), weight)
    histos[name+'/dPhiEMET'].Fill(deltaPhi(row.ePhi, tmpMET[1]), weight)
    histos[name+'/dPhiMuMET'].Fill(deltaPhi(row.mPhi, tmpMET[1]), weight)
    histos[name+'/dPhiMuE'].Fill(deltaPhi(row.mPhi, row.ePhi), weight)
    histos[name+'/MTEMET'].Fill(transverseMass(row.ePt, row.eEta, row.ePhi, row.eMass, tmpMET[0], tmpMET[1]), weight)
    histos[name+'/MTMuMET'].Fill(transverseMass(row.mPt, row.mEta, row.mPhi, row.mMass, tmpMET[0], tmpMET[1]), weight)


  def process(self):

    for row in self.tree:
      
      if row.Flag_goodVertices:
        continue

      if row.Flag_globalTightHalo2016Filter:
        continue

      if row.Flag_HBHENoiseFilter:
        continue

      if row.Flag_HBHENoiseIsoFilter:
        continue

      if row.Flag_EcalDeadCellTriggerPrimitiveFilter:
        continue

      if row.Flag_BadPFMuonFilter:
        continue

      if row.Flag_BadChargedCandidateFilter:
        continue

      if self.is_data and row.Flag_eeBadScFilter:
        continue

      if row.Flag_ecalBadCalibFilter:
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      if row.jetVeto30WoNoisyJets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue

      #if self.is_DY or self.is_DYlow:
      #  if not bool(row.isZmumu or row.isZee):
      #    continue

      tmpMetEt = row.type1_pfMetEt
      tmpMetPhi = row.type1_pfMetPhi

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
        tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])

      tmpMET = [tmpMetEt, tmpMetPhi]

      #if self.is_data:
      nbtag = row.bjetDeepCSVVeto20MediumWoNoisyJets
      #else:
      #  nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue 

      weight = 1.0
      if not self.is_data and not self.is_embed:

        w2.var("m_pt").setVal(row.mPt)                                                                                                                                                                                                                             
        w2.var("m_eta").setVal(row.mEta)
        #w2.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        mIso = w2.function("m_iso_kit_ratio").getVal()
        mID = w2.function("m_id_kit_ratio").getVal()
        tEff = w2.function("m_trg27_kit_data").getVal()/w2.function("m_trg27_kit_mc").getVal()
        #print "mIso: ", mIso, row.mPt, row.mEta
        w2.var("e_pt").setVal(row.ePt)
        w2.var("e_eta").setVal(row.eEta)
        eIso = w2.function("e_iso_kit_ratio").getVal()
        eID = w2.function("e_id80_kit_ratio").getVal()       
        eTrk = w2.function("e_trk_ratio").getVal()
        weight = weight*row.GenWeight*pucorrector(row.nTruePU)*tEff*mID*mIso*eID*eTrk*eIso

        if self.is_DY:
          w2.var("z_gen_mass").setVal(row.genMass)
          w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          w2.var("z_gen_mass").setVal(row.genMass)
          w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*11.47563472*dyweight
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_WG:
          weight = weight*3.094
        if self.is_GluGlu:
          weight = weight*0.0005
        if self.is_VBF:
          weight = weight*0.000214
        if self.is_WW:
          weight = weight*0.407
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261
        if self.is_EWKWMinus:
          weight = weight*0.191
        if self.is_EWKWPlus:
          weight = weight*0.343
        if self.is_EWKZToLL:
          weight = weight*0.175
        if self.is_EWKZToNuNu:
          weight = weight*0.140
        if self.is_ZHTT:
          weight = weight*0.000598
        if self.is_ttH:
          weight = weight*0.000116
        if self.is_Wminus:
          weight = weight*0.000670
        if self.is_Wplus:
          weight = weight*0.000636
        if self.is_STtantitop:
          weight = weight*0.922
        if self.is_STttop:
          weight = weight*0.952
        if self.is_STtWantitop:
          weight = weight*0.00538
        if self.is_STtWtop:
          weight = weight*0.00552
        if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6:
            continue
        if self.is_TTTo2L2Nu:
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          weight = weight*0.00117*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.00203

      if self.is_embed:
        we.var("gt_pt").setVal(row.mPt)
        we.var("gt_eta").setVal(row.mEta)
        msel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt_pt").setVal(row.ePt)
        we.var("gt_eta").setVal(row.eEta)
        esel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt1_pt").setVal(row.mPt)
        we.var("gt1_eta").setVal(row.mEta)
        we.var("gt2_pt").setVal(row.ePt)
        we.var("gt2_eta").setVal(row.eEta)
        trgsel = we.function("m_sel_trg_ratio").getVal()
        we.var("m_pt").setVal(row.mPt)
        we.var("m_eta").setVal(row.mEta)
        we.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_iso_sf = we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = we.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = we.function("m_trg27_embed_kit_ratio").getVal()
        we.var("e_pt").setVal(row.ePt)
        we.var("e_eta").setVal(row.eEta)
        we.var("e_iso").setVal(row.eRelPFIsoRho)
        e_iso_sf = we.function("e_iso_binned_embed_kit_ratio").getVal()
        e_id_sf = we.function("e_id80_embed_kit_ratio").getVal()
        weight = weight*row.GenWeight*m_trg_sf*m_id_sf*m_iso_sf*msel*esel*trgsel*e_id_sf*e_iso_sf

      w3.var("njets").setVal(row.jetVeto30WoNoisyJets)
      w3.var("dR").setVal(deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta))
      w3.var("e_pt").setVal(row.ePt)
      w3.var("m_pt").setVal(row.mPt)
      osss = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()

      nj = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      if self.obj1_iso(row) and self.obj2_loose(row) and not self.obj2_iso(row):
        if self.oppositesign(row):
          self.fill_histos(row, tmpMET, weight, 'TightOS')
          if nj==0:
            self.fill_histos(row, tmpMET, weight, 'TightOS0Jet')
          elif nj==1:
            self.fill_histos(row, tmpMET, weight, 'TightOS1Jet')
          elif nj==2 and mjj < 550:
            self.fill_histos(row, tmpMET, weight, 'TightOS2Jet')
          elif nj==2 and mjj > 550:
            self.fill_histos(row, tmpMET, weight, 'TightOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, tmpMET, weight*osss, 'TightSS')
          if nj==0:
            self.fill_histos(row, tmpMET, weight*osss, 'TightSS0Jet')
          elif nj==1:
            self.fill_histos(row, tmpMET, weight*osss, 'TightSS1Jet')
          elif nj==2 and mjj < 550:
            self.fill_histos(row, tmpMET, weight*osss, 'TightSS2Jet')
          elif nj==2 and mjj > 550:
            self.fill_histos(row, tmpMET, weight*osss, 'TightSS2JetVBF')                                                        

  def finish(self):
    self.write_histos()
