'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import itertools
import mcCorrections
import mcWeights
import Kinematics
import FakeRate
from bTagSF import bTagEventWeight
import random

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuTauSysDeep(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.deepTauVSe = mcCorrections.deepTauVSe
    self.deepTauVSmu = mcCorrections.deepTauVSmu
    self.deepTauVSjet_tight = mcCorrections.deepTauVSjet_tight
    self.deepTauVSjet_vloose = mcCorrections.deepTauVSjet_vloose
    self.deepTauVSjet_Emb_tight = mcCorrections.deepTauVSjet_Emb_tight
    self.deepTauVSjet_Emb_vloose = mcCorrections.deepTauVSjet_Emb_vloose
    self.esTau = mcCorrections.esTau
    self.FesTau = mcCorrections.FesTau
    self.ScaleTau = mcCorrections.ScaleTau
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.fakeRate = FakeRate.fakerateDeep_weight
    self.fakeRateMuon = FakeRate.fakerateMuon_weight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    self.names = Kinematics.names
    self.loosenames = Kinematics.loosenames
    self.jes = Kinematics.jes
    self.ues = Kinematics.ues
    self.fakes = Kinematics.fakesDeep
    self.sys = Kinematics.sysDeep
    self.fakeSys = Kinematics.fakeDeepSys
    self.scaleSys = Kinematics.scaleDeepSys

    super(AnalyzeMuTauSysDeep, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 26 or abs(row.mEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tVLooseDeepTau2017v2p1VSe > 0.5) and bool(row.tTightDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)


  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ues in itertools.product(self.names, self.ues):
      folder.append(os.path.join(*tuple_path_ues))
    for tuple_path_fakes in itertools.product(self.loosenames, self.fakes):
      folder.append(os.path.join(*tuple_path_fakes))
    for f in folder:
      self.book(f, 'm_t_CollinearMass', 'Muon + Tau Collinear Mass', 60, 0, 300)


  def fill_histos(self, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/m_t_CollinearMass'].Fill(self.collMass(myMuon, myMET, myTau), weight)


  def fill_categories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon
      self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet'+name)
      elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet'+name)
      elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon*frTau
      self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF'+name)


  def fill_sys(self, row, myMuon, myMET, myTau, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpTau = ROOT.TLorentzVector()
    uncorTau = ROOT.TLorentzVector()
    uncorTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    tmpMET = ROOT.TLorentzVector()
    njets = row.jetVeto30
    mjj = row.vbfMass

    if self.is_mc:

      # Recoil Response and Resolution
      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoDown')

      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      # B-Tagged Scale Factor
      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, -1, 0)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      # Pileup
      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      if puweight==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      # Prefiring
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      # Tau ID
      if row.tZTTGenMatching==5:
        tW = self.deepTauVSjet_tight(myTau.Pt())
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * tW[1]/tW[0], '/tidUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * tW[2]/tW[0], '/tidDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/tidUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/tidDown')

      # Against Muon Discriminator
      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        mW = self.deepTauVSmu(myTau.Eta())
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * mW[1]/mW[0], '/mtfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * mW[2]/mW[0], '/mtfakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeDown')

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        # Against Electron Discriminator
        eW = self.deepTauVSe(myTau.Eta())
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * eW[1]/eW[0], '/etfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * eW[2]/eW[0], '/etfakeDown')
        # Electron Fake Tau Energy Scale
        fes = self.FesTau(myTau.Eta(), row.tDecayMode)
        myMETpx = myMET.Px() - fes[1] * myTau.Px()
        myMETpy = myMET.Py() - fes[1] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 + fes[1])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeUp')
        myMETpx = myMET.Px() + fes[2] * myTau.Px()
        myMETpy = myMET.Py() + fes[2] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 - fes[2])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeDown')

      # Muon Energy Scale
      myMETpx = myMET.Px() - 0.002 * myMuon.Px()
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesUp')
      myMETpx = myMET.Px() + 0.002 * myMuon.Px()
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesDown')

      # Tau Energy Scale 
      if row.tZTTGenMatching==5:
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
        myMETpx = myMET.Px() - tes[0] * myTau.Px()
        myMETpy = myMET.Py() - tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 + tes[0])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, tes[1][0])
        myMETpx = myMET.Px() + tes[0] * myTau.Px()
        myMETpy = myMET.Py() + tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 - tes[0])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, tes[1][1])
      else:
        self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.scaleSys)

      # DY pT reweighting
      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      # TTbar pT reweighting
      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')

      # Fake Rate
      self.tauFRSys(row, myMuon, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep0Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Up')
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep1Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Up')
        else:
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep0Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Down')
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep1Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Down')

      # Jet and Unclustered Energy Scale
      if not (self.is_recoilC and MetCorrection):
        for u in self.ues:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/'+u)
        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          njets = getattr(row, 'jetVeto30_'+j)
          mjj = getattr(row, 'vbfMass_'+j)
          self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      # Systematics for fakes from data
      self.tauFRSys(row, myMuon, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep0Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Up')
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep1Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Up')
        else:
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep0Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Down')
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep1Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Down')

      if self.is_embed:
        # Embed Tau
        tW = self.deepTauVSjet_Emb_tight(myTau.Pt())
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * tW[1]/tW[0], '/tidUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * tW[2]/tW[0], '/tidDown')

        # Embed Tau Energy Scale
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
        myMETpx = myMET.Px() - tes[0] * myTau.Px()
        myMETpy = myMET.Py() - tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 + tes[0])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, tes[1][0])
        myMETpx = myMET.Px() + tes[0] * myTau.Px()
        myMETpy = myMET.Py() + tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 - tes[0])
        self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, tes[1][1])

        # Embed Tracking
        if row.tDecayMode == 0:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.983/0.975, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.967/0.975, '/embtrkDown')
        elif row.tDecayMode == 1:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.983*1.065)/(0.975*1.051), '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.967*1.037)/(0.975*1.051), '/embtrkDown')
        elif row.tDecayMode == 10:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/pow(0.975, 3), '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.967, 3)/pow(0.975, 3), '/embtrkDown')
        elif row.tDecayMode == 11:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (pow(0.983, 3)*1.065)/(pow(0.975, 3)*1.051), '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (pow(0.967, 3)*1.037)/(pow(0.975, 3)*1.051), '/embtrkDown')


  def fill_scaleSys(self, row, myMuon, myMET, myTau, njets, mjj, weight, scaleSys):
    for s in scaleSys:
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, s)


  def fill_fakeSys(self, row, myMuon, myMET, myTau, njets, mjj, weight, fakeSys):
    for f in fakeSys:
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, f)


  def tauFRSys(self, row, myMuon, myMET, myTau, njets, mjj, weight):
    if not self.obj2_tight(row) and self.obj2_loose(row):
      if abs(myTau.Eta()) < 1.5:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM0Up', '/TauFakep1EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep1EBDM0Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM1Up', '/TauFakep1EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep1EBDM1Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM10Up', '/TauFakep1EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep1EBDM10Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 11:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM11')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM11Up', '/TauFakep1EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep1EBDM11Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
      else:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM0Up', '/TauFakep1EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep1EEDM0Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM1Up', '/TauFakep1EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep1EEDM1Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM10Up', '/TauFakep1EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EEDM10Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 11:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM11')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM11Up', '/TauFakep1EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EEDM11Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)


  def fill_taufr(self, row, myMuon, myMET, myTau, njets, mjj, weight, name):
    myrand = random.random()
    if myrand < 0.5:
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakep0'+name+'Down')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Up')
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakep1'+name+'Down')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Up')
    else:
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakep0'+name+'Up')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Down')
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakep1'+name+'Up')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Down')

  # Tau pT correction
  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      fes = self.FesTau(myTau.Eta(), row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes[0])
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26

      if self.filters(row):
        continue

      if not bool(trigger24):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      njets = row.jetVeto30
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if row.tDecayMode==5 or row.tDecayMode==6:
        continue

      if not self.vetos(row):
        continue

      if not self.dimuonveto(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        tEff = self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[0]
        mID = self.muonTightID(myMuon.Eta(), myMuon.Pt())
        if self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Eta(), myMuon.Pt())
        else:
          mIso = self.muonLooseIsoTightID(myMuon.Eta(), myMuon.Pt())
        mTrk = self.muTracking(myMuon.Eta())[0]
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*mcSF*row.prefiring_weight
        # Anti-Muon Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          weight = weight * self.deepTauVSmu(myTau.Eta())[0]
        # Anti-Electron Discriminator Scale Factors
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          weight = weight * self.deepTauVSe(myTau.Eta())[0]
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if self.obj2_tight(row):
            weight = weight * self.deepTauVSjet_tight(myTau.Pt())[0]
          elif self.obj2_loose(row):
            weight = weight * self.deepTauVSjet_vloose(myTau.Pt())[0]
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMass

      if self.is_embed:
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        elif row.tDecayMode == 11:
          dm = pow(0.975, 3)*1.051
        # Muon selection scale factor
        self.w1.var('gt_pt').setVal(myMuon.Pt())
        self.w1.var('gt_eta').setVal(myMuon.Eta())
        msel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Tau selection scale factor
        self.w1.var('gt_pt').setVal(myTau.Pt())
        self.w1.var('gt_eta').setVal(myTau.Eta())
        tsel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Trigger selection scale factor
        self.w1.var('gt1_pt').setVal(myMuon.Pt())
        self.w1.var('gt1_eta').setVal(myMuon.Eta())
        self.w1.var('gt2_pt').setVal(myTau.Pt())
        self.w1.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.w1.function('m_sel_trg_ic_ratio').getVal()
        # Muon Identification, Isolation, Tracking, and Trigger scale factors
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_idiso_sf = self.w1.function("m_idiso_ic_embed_ratio").getVal()
        m_trk_sf = self.w1.function("m_trk_ratio").getVal()
        m_trg_sf = self.w1.function("m_trg_ic_embed_ratio").getVal()
        weight = row.GenWeight*dm*msel*tsel*trgsel*m_idiso_sf*m_trk_sf*m_trg_sf
        # Tau Identification
        if self.obj2_tight(row):
          weight = weight * self.deepTauVSjet_Emb_tight(myTau.Pt())[0]
        elif self.obj2_loose(row):
          weight = weight * self.deepTauVSjet_Emb_vloose(myTau.Pt())[0]
        if row.GenWeight > 1:
          weight = 0

      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data or self.is_embed) and nbtag > 0):
        weight = 0

      self.fill_sys(row, myMuon, myMET, myTau, weight)

  def finish(self):
    self.write_histos()
