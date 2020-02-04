'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import ETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import itertools
import mcCorrections
import mcWeights
import FakeRate
import Kinematics
import random

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeETauSys(MegaBase):
  tree = 'et/final/Ntuple'

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

    self.Ele25 = mcCorrections.Ele25
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.w1 = mcCorrections.w1
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPhi = mcCorrections.EmbedPhi
    self.againstEle = mcCorrections.againstEle
    self.againstMu = mcCorrections.againstMu
    self.mvaTau_tight = mcCorrections.mvaTau_tight
    self.mvaTau_vloose = mcCorrections.mvaTau_vloose
    self.esTau = mcCorrections.esTau
    self.ScaleTau = mcCorrections.ScaleTau
    self.DYreweight = mcCorrections.DYreweight

    self.fakeRate = FakeRate.fakerate_weight
    self.fakeRateEle = FakeRate.fakerateEle_weight

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
    self.fakes = Kinematics.fakes
    self.sys = Kinematics.sys
    self.fakeSys = Kinematics.fakeSys
    self.scaleSys = Kinematics.scaleSys

    super(AnalyzeETauSys, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.ePt < 27 or abs(row.eEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)


  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronTightMVA6 > 0.5) and bool(row.tAgainstMuonLoose3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVLoose > 0.5)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)


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
      self.book(f, 'e_t_CollinearMass', 'Electron + Tau Collinear Mass', 60, 0, 300)


  def fill_histos(self, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/e_t_CollinearMass'].Fill(self.collMass(myEle, myMET, myTau), weight)


  def fill_categories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myEle, myMET, myTau, weight, 'TightOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frEle = self.fakeRateEle(myEle.Pt())
      weight = weight*frEle
      self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS1Jet'+name)
      elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS2Jet'+name)
      elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frEle = self.fakeRateEle(myEle.Pt())
      weight = weight*frEle*frTau
      self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS'+name)
      if njets==0 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS0Jet'+name)
      elif njets==1 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS2JetVBF'+name)


  def fill_sys(self, row, myEle, myMET, myTau, weight):

    tmpEle = ROOT.TLorentzVector()
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
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/recresoDown')

      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')

      # Pileup
      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      if puweight==0:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      # Prefiring
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      # Tau ID
      if row.tZTTGenMatching==5:
        tW = self.mvaTau_tight(myTau.Pt())
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[1]/tW[0], '/tidUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[2]/tW[0], '/tidDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/tidUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/tidDown')

      # Against Muon Discriminator
      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        mW = self.againstMu(myTau.Eta())
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * mW[1]/mW[0], '/mtfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * mW[2]/mW[0], '/mtfakeDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/mtfakeDown')

      # Against Electron Discriminator
      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        eW = self.againstEle(myTau.Eta())
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * eW[1]/eW[0], '/etfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * eW[2]/eW[0], '/etfakeDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etfakeDown')

      # Electron Energy Scale
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

      # Tau Energy Scale
      if row.tZTTGenMatching==5:
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
        myMETpx = myMET.Px() - tes[0] * myTau.Px()
        myMETpy = myMET.Py() - tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 + tes[0])
        self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, tes[1][0])
        myMETpx = myMET.Px() + tes[0] * myTau.Px()
        myMETpy = myMET.Py() + tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 - tes[0])
        self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, tes[1][1])
      else:
        self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, self.scaleSys)

      # DY pT reweighting
      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      # TTbar pT reweighting
      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')

      self.tauFRSys(row, myEle, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Down') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep0Up')
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Down') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep1Up')
        else:
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Up') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep0Down')
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Up') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep1Down')

      if not (self.is_recoilC and MetCorrection):
        for u in self.ues:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/'+u)
        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          njets = getattr(row, 'jetVeto30_'+j)
          mjj = getattr(row, 'vbfMass_'+j)
          self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')

      self.tauFRSys(row, myEle, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Down') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep0Up')
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Down') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep1Up')
        else:
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Up') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep0Down')
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Up') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakep1Down')
      if self.is_embed:
        # Embed Electron Energy Scale
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

        # Embed Tau Energy Scale
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
        myMETpx = myMET.Px() - tes[0] * myTau.Px()
        myMETpy = myMET.Py() - tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 + tes[0])
        self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, tes[1][0])
        myMETpx = myMET.Px() + tes[0] * myTau.Px()
        myMETpy = myMET.Py() + tes[0] * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.000 - tes[0])
        self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, tes[1][1])

        # Embed Tracking
        if row.tDecayMode == 0:
          dm = 0.975
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.983/dm, '/embtrkUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.967/dm, '/embtrkDown')
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * (0.983*1.065)/dm, '/embtrkUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * (0.967*1.037)/dm, '/embtrkDown')
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/dm, '/embtrkUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * pow(0.967, 3)/dm, '/embtrkDown')


  def fill_scaleSys(self, row, myEle, myMET, myTau, njets, mjj, weight, scaleSys):
    for s in scaleSys:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, s)


  def tauFRSys(self, row, myEle, myMET, myTau, njets, mjj, weight):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_loose(row):
      if abs(myTau.Eta()) < 1.5:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EBDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM0Up', '/TauFakep1EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep1EBDM0Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EBDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM1Up', '/TauFakep1EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep1EBDM1Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EBDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM10Up', '/TauFakep1EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep1EBDM10Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
      else:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EEDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM0Up', '/TauFakep1EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep1EEDM0Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EEDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM1Up', '/TauFakep1EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep1EEDM1Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EEDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM10Up', '/TauFakep1EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EEDM10Down']]
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)


  def fill_taufr(self, row, myEle, myMET, myTau, njets, mjj, weight, name):
    myrand = random.random()
    if myrand < 0.5:
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/TauFakep0'+name+'Down')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Up')
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/TauFakep1'+name+'Down')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Up')
    else:
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/TauFakep0'+name+'Up')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Down')
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/TauFakep1'+name+'Up')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Down')


  def fill_fakeSys(self, row, myEle, myMET, myTau, njets, mjj, weight, fakeSys):
      for f in fakeSys:
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, f)


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    # if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
    #   fes = self.FesTau(myTau.Eta(), row.tDecayMode)
    #   myMETpx = myMET.Px() + (1 - fes[0]) * myTau.Px()
    #   myMETpy = myMET.Py() + (1 - fes[0]) * myTau.Py()
    #   tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    #   tmpTau = myTau * ROOT.Double(fes[0])
    return [tmpMET, tmpTau]

  def process(self):

    for row in self.tree:

      trigger25 = row.singleE25eta2p1TightPass and row.eMatchesEle25Filter and row.eMatchesEle25Path and row.ePt > 27

      if self.filters(row):
        continue

      if not bool(trigger25):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if self.deltaR(row.tPhi, row.ePhi, row.tEta, row.eEta) < 0.5:
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

      if not self.vetos(row):
        continue

      if not self.dieleveto(row):
        continue

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

      #if self.is_data or self.is_mc:
      #  myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        tEff = self.Ele25(row.ePt, abs(row.eEta))[0]
        zvtx = 0.991
        eID = self.eIDnoiso80(row.eEta, row.ePt)
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*zvtx*row.prefiring_weight
        # Anti-Muon Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          weight = weight * self.againstMu(myTau.Eta())[0]
        # Anti-Electron Discriminator Scale Factors
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          weight = weight * self.againstEle(myTau.Eta())[0]
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if self.obj2_tight(row):
            weight = weight * self.mvaTau_tight(myTau.Pt())[0]
          elif self.obj2_loose(row):
            weight = weight * self.mvaTau_vloose(myTau.Pt())[0]
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
          if row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMass

      if self.is_embed:
        tID = 0.9
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        # Muon selection scale factor
        self.w1.var('gt_pt').setVal(myEle.Pt())
        self.w1.var('gt_eta').setVal(myEle.Eta())
        esel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Tau selection scale factor
        self.w1.var('gt_pt').setVal(myTau.Pt())
        self.w1.var('gt_eta').setVal(myTau.Eta())
        tsel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Trigger selection scale factor
        self.w1.var('gt1_pt').setVal(myEle.Pt())
        self.w1.var('gt1_eta').setVal(myEle.Eta())
        self.w1.var('gt2_pt').setVal(myTau.Pt())
        self.w1.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.w1.function('m_sel_trg_ic_ratio').getVal()
        # Electron Identification, Isolation, tracking, and trigger scale factors
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        e_trg_sf = self.w1.function('e_trg_ic_embed_ratio').getVal()
        e_idiso_sf = self.w1.function('e_idiso_ic_embed_ratio').getVal()
        e_trk_sf = self.w1.function('e_trk_embed_ratio').getVal()
        weight = row.GenWeight*tID*dm*esel*tsel*trgsel*e_trg_sf*e_idiso_sf*e_trk_sf*self.EmbedEta(myEle.Eta(), njets, mjj)*self.EmbedPhi(myEle.Phi(), njets, mjj)
        if row.GenWeight > 1:
          continue

      self.fill_sys(row, myEle, myMET, myTau, weight)

  def finish(self):
    self.write_histos()
