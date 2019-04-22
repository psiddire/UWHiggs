import EMMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
from math import sqrt, pi
import array as arr
import copy
import operator
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])


def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)

 
def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)


def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

  
def visibleMass(row):
  vm1 = ROOT.TLorentzVector()
  vm2 = ROOT.TLorentzVector()
  vm1.SetPtEtaPhiM(row.m1Pt,row.m1Eta,row.m1Phi,row.m1Mass)
  vm2.SetPtEtaPhiM(row.m2Pt,row.m2Eta,row.m2Phi,row.m2Mass)
  return (vm1+vm2).M()


if bool('DYJetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY4')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY10')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZZ')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeEMM(MegaBase):
  tree = 'emm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not self.is_data
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeEMM, self).__init__(tree, outfile, **kwargs)
    self.tree = EMMTree.EMMTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonTightID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonMediumID = mcCorrections.muonID_medium if not self.is_data else 1.
    self.muonLooseID = mcCorrections.muonID_loose if not self.is_data else 1.
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid if not self.is_data else 1.
    self.muonTightIsoMediumID = mcCorrections.muonIso_tight_mediumid if not self.is_data else 1.
    self.muonLooseIsoLooseID = mcCorrections.muonIso_loose_looseid if not self.is_data else 1.
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid if not self.is_data else 1.
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid if not self.is_data else 1.
    self.muTracking = mcCorrections.muonTracking
    self.DYreweight = mcCorrections.DYreweight
    self.elReco = mcCorrections.electronReco if not self.is_data else 1.
    self.eIDnoIsoWP90 = mcCorrections.eIDnoIsoWP90 if not self.is_data else 1.
    self.eIDIsoWP90 = mcCorrections.eIDIsoWP90 if not self.is_data else 1.
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80 if not self.is_data else 1.
    self.eIDIsoWP80 = mcCorrections.eIDIsoWP80 if not self.is_data else 1.    

    self.DYweight = {
      0 : 2.666650438,
      1 : 0.465803642,
      2 : 0.585042564,
      3 : 0.609127575,
      4 : 0.419146762
      }


  def oppositesign(self,row):
    if row.m1Charge*row.m2Charge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.m1Pt < 29 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 10 or abs(row.m2Eta) >= 2.4:
      return False
    if row.ePt < 10 or abs(row.eEta) >= 2.4:
      return False
    return True


  def obj1_id(self,row):
    return bool(row.m1PFIDTight) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045)
 
 
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj2_id(self, row):
    return bool(row.m2PFIDTight) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045)


  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.15)


  def obj3_id(self, row):
    return (row.eMVANoisoWP90 > 0) and (abs(row.ePVDXY) < 0.045) and (abs(row.ePVDZ) < 0.2) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2)


  def obj3_tightid(self, row):
    return (row.eMVANoisoWP80 > 0)# and (abs(row.ePVDXY) < 0.045) and (abs(row.ePVDZ) < 0.2) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2) 


  def obj3_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj3_tightiso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20Loose3HitsVtx < 0.5))


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Medium < 0.5)


  def begin(self):
    names=['initial', 'eleloose', 'eletight']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "ePt", "Electron Pt", 20, 0, 200)
      self.book(names[x], "eEta", "Electron Eta", 20, -3.0, 3.0)
      self.book(names[x], "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(names[x], "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 20, -3.0, 3.0)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 20, -3.0, 3.0)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(row.ePt, weight)
    histos[name+'/eEta'].Fill(row.eEta, weight)
    histos[name+'/m1_m2_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
    histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
    histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
    histos[name+'/m2Eta'].Fill(row.m2Eta, weight)

  def process(self):
    preevt=0

    for row in self.tree:

      weight = 1.0
      if not self.is_data:
        m1trk = self.muTracking(row.m1Eta)[0]
        m2trk = self.muTracking(row.m2Eta)[0]
        tEff = self.triggerEff(row.m1Pt, abs(row.m1Eta))
        m1ID = self.muonTightID(row.m1Pt, abs(row.m1Eta))
        m1Iso = self.muonTightIsoTightID(row.m1Pt, abs(row.m1Eta))
        m2ID = self.muonTightID(row.m2Pt, abs(row.m2Eta))
        m2Iso = self.muonTightIsoTightID(row.m2Pt, abs(row.m2Eta))
        weight = row.GenWeight*pucorrector(row.nTruePU)*tEff*m2ID*m2Iso*m1ID*m1Iso*m1trk*m2trk
        if self.is_DY:
          dyweight = self.DYreweight(row.genMass, row.genpT)
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight*26.747*dyweight
        if self.is_WW:
          weight = weight*0.407
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261

      if not self.oppositesign(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.obj2_iso(row):
        continue

      if visibleMass(row) < 70 or visibleMass(row) > 110:
        continue

      if not self.vetos(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue    

      if row.evt==preevt:
        continue

      self.fill_histos(row, weight, 'initial')

      if not self.obj3_id(row):
        continue

      eID = 1.
      if not self.is_data:
        eID = self.eIDnoIsoWP90(row.ePt, abs(row.eEta))
        weight = weight*eID

      if not self.obj3_iso(row):
        continue
      self.fill_histos(row, weight, 'eleloose')

      if not self.obj3_tightiso(row):
        continue
      self.fill_histos(row, weight, 'eletight')

      preevt = row.evt


  def finish(self):
    self.write_histos()
