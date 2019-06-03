import MuMuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from math import sqrt, pi
from bTagSF import PromoteDemote

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMMM(MegaBase):
  tree = 'mmm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco

    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeMMM, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuMuTree.MuMuMuTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self,row):
    if row.m1Charge * row.m2Charge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.m1Pt < 10 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 10 or abs(row.m2Eta) >= 2.4:
      return False
    if row.m3Pt < 10 or abs(row.m3Eta) >= 2.4:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def obj1_id(self,row):
    return bool(row.m1PFIDTight) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045)
 
 
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj2_id(self, row):
    return bool(row.m2PFIDTight) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045)


  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.15)


  def obj3_id(self, row):
    return bool(row.m3PFIDTight) and bool(abs(row.m3PVDZ) < 0.2) and bool(abs(row.m3PVDXY) < 0.045)


  def obj3_tight(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.15)


  def obj3_loose(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.2)


  def vetos(self, row):
    return bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names=['initial', 'muonloose', 'muontight']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "m3Pt", "Muon 3 Pt", 20, 0, 200)
      self.book(names[x], "m3Eta", "Muon 3 Eta", 20, -3, 3)
      self.book(names[x], "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(names[x], "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 20, -3, 3)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 20, -3, 3)


  def fill_histos(self, row, myMuon1, myMuon2, myMuon3, weight, name=''):
    histos = self.histograms
    histos[name+'/m3Pt'].Fill(myMuon3.Pt(), weight)
    histos[name+'/m3Eta'].Fill(myMuon3.Eta(), weight)
    histos[name+'/m1_m2_Mass'].Fill(self.visibleMass(myMuon1, myMuon2), weight)
    histos[name+'/m1Pt'].Fill(myMuon1.Pt(), weight)
    histos[name+'/m1Eta'].Fill(myMuon1.Eta(), weight)
    histos[name+'/m2Pt'].Fill(myMuon2.Pt(), weight)
    histos[name+'/m2Eta'].Fill(myMuon2.Eta(), weight)


  def process(self):

    for row in self.tree:

      if self.filters(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if not self.vetos(row):
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.obj2_iso(row):
        continue

      myMuon1 = ROOT.TLorentzVector()
      myMuon1.SetPtEtaPhiM(row.m1Pt, row.m1Eta, row.m1Phi, row.m1Mass)
      myMuon2 = ROOT.TLorentzVector()
      myMuon2.SetPtEtaPhiM(row.m2Pt, row.m2Eta, row.m2Phi, row.m2Mass)
      myMuon3 = ROOT.TLorentzVector()
      myMuon3.SetPtEtaPhiM(row.m3Pt, row.m3Eta, row.m3Phi, row.m3Mass)

      z1diff = abs(91.19 - self.visibleMass(myMuon1, myMuon2))
      z2diff = abs(91.19 - self.visibleMass(myMuon1, myMuon3))
      z3diff = abs(91.19 - self.visibleMass(myMuon2, myMuon3))

      if z1diff > z2diff: continue
      if z1diff > z3diff: continue

      if row.m1Pt > row.m2Pt and row.m1Pt < 29:
        continue

      if row.m2Pt > row.m1Pt and row.m2Pt < 29:
        continue

      if self.visibleMass(myMuon1, myMuon2) < 70 or self.visibleMass(myMuon1, myMuon2) > 110:
        continue

      if not self.obj3_id(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (self.is_mc and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue 

      weight = 1.0
      if self.is_mc:
        tEff = self.triggerEff(row.m1Pt, abs(row.m1Eta)) if row.m1Pt > row.m2Pt else self.triggerEff(row.m2Pt, abs(row.m2Eta))
        m1ID = self.muonTightID(row.m1Pt, abs(row.m1Eta))
        m1Iso = self.muonTightIsoTightID(row.m1Pt, abs(row.m1Eta))
        m1Trk = self.muTracking(row.m1Eta)[0]
        m2ID = self.muonTightID(row.m2Pt, abs(row.m2Eta))
        m2Iso = self.muonTightIsoTightID(row.m2Pt, abs(row.m2Eta))
        m2Trk = self.muTracking(row.m2Eta)[0]
        m3ID = self.muonTightID(row.m3Pt, abs(row.m3Eta))
        m3Trk = self.muTracking(row.m3Eta)[0]
        weight = weight * tEff * m1ID * m1Iso * m1Trk * m2ID * m2Iso * m2Trk * m3ID * m3Trk
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        weight = self.mcWeight.lumiWeight(weight)

      self.fill_histos(row, myMuon1, myMuon2, myMuon3, weight, 'initial')

      if self.obj3_loose(row):
        if self.is_mc:
          m3Iso = self.muonLooseIsoTightID(row.m3Pt, abs(row.m3Eta))
          weight = weight * m3Iso
        self.fill_histos(row, myMuon1, myMuon2, myMuon3, weight, 'muonloose')

      if self.obj3_tight(row):
        if self.is_mc:
          m3Iso = self.muonTightIsoTightID(row.m3Pt, abs(row.m3Eta))
          weight = weight * m3Iso
        self.fill_histos(row, myMuon1, myMuon2, myMuon3, weight, 'muontight')


  def finish(self):
    self.write_histos()
