'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import array
from copy import deepcopy
import operator
import mcCorrections
import mcWeights
import Kinematics
import itertools
from math import sqrt, pi
from RecoilCorrector import RecoilCorrector
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuTauBDT(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
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
    self.topPtreweight = Kinematics.topPtreweight

    self.branches="mPt/F:tPt/F:dPhiMuTau/F:dEtaMuTau/F:type1_pfMetEt/F:m_t_collinearMass/F:MTTauMET/F:dPhiTauMET/F:weight/F"
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name="TreeS"
      self.title="TreeS"
    else:
      self.name="TreeB"
      self.title="TreeB"

    super(AnalyzeMuTauBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 29 or abs(row.mEta) >= 2.4:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
 
 
  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  

  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)

  
  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)#VTight


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)


  def filltree(self, myMuon, myMET, myTau, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = myMuon.Pt()
      elif varname=="tPt":
        holder[0] = myTau.Pt()
      elif varname=="dPhiMuTau":
        holder[0] = self.deltaPhi(myMuon.Phi(), myTau.Phi())
      elif varname=="dEtaMuTau":
        holder[0] = self.deltaPhi(myMuon.Eta(), myTau.Eta())
      elif varname=="type1_pfMetEt":
        holder[0] = myMET.Et()
      elif varname=="m_t_collinearMass":
        holder[0] = self.collMass(myMuon, myMET, myTau)
      elif varname=="MTTauMET":
        holder[0] = self.transverseMass(myTau, myMET)
      elif varname=="dPhiTauMET":
        holder[0] = self.deltaPhi(myTau.Phi(), myMET.Phi())
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and (not self.is_DY) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      if self.filters(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue

      if not self.dimuonveto(row):
        continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue

      weight = 1.0
      if self.is_mc:
        mTrk = self.muTracking(myMuon.Eta())[0]
        tEff = self.triggerEff(myMuon.Pt(), abs(myMuon.Eta()))
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mTrk
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.17
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.29
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.14
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.09
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.19
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        weight = self.mcWeight.lumiWeight(weight)

      if self.is_data:
        if not self.obj2_tight(row) and self.obj2_loose(row):# and not self.obj1_tight(row) and self.obj1_loose(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          #frMuon = self.fakeRateMuon(myMuon.Pt())
          if not self.oppositesign(row):
            self.filltree(myMuon, myMET, myTau, weight*frTau)#*frMuon)

      if self.is_mc:
        if self.obj2_tight(row) and self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
          if self.oppositesign(row):
            self.filltree(myMuon, myMET, myTau, weight*mIso)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
