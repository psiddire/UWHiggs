B'''

R1;95;0cun LFV H->ETau analysis in the e+tau_h channel.

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
import Kinematics
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVACat, FunctorFromMVA
import random

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeETauSysBDT(MegaBase):
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
    self.tauSF = mcCorrections.tauSF

    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateEle = mcCorrections.fakerateEle_weight
    self.Ele25 = mcCorrections.Ele25
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.DYreweight = mcCorrections.DYreweight

    self.w1 = mcCorrections.w1
    self.EmbedId = mcCorrections.EmbedId
    self.EmbedTrg = mcCorrections.EmbedTrg

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
    self.fakes = Kinematics.fakes
    self.sys = Kinematics.sys
    self.fakeSys = Kinematics.fakeSys
    self.fakeEleSys = Kinematics.fakeEleSys
    self.scaleSys = Kinematics.scaleSys

    self.var_d_star =['ePt', 'tPt', 'dPhiETau', 'dEtaETau', 'e_t_collinearMass', 'e_t_visibleMass', 'MTTauMET', 'dPhiTauMET', 'njets', 'vbfMass']
    self.xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml')
    self.functor = FunctorFromMVACat('BDT method', self.xml_name, *self.var_d_star)

    super(AnalyzeETauSysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.ePt < 25 or abs(row.eEta) >= 2.1:
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
    return bool(row.eRelPFIsoRho < 0.1)


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


  def var_d(self, myEle, myMET, myTau, njets, mjj):
    return {'ePt' : myEle.Pt(), 'tPt' : myTau.Pt(), 'dPhiETau' : self.deltaPhi(myEle.Phi(), myTau.Phi()), 'dEtaETau' : self.deltaEta(myEle.Eta(), myTau.Eta()), 'e_t_collinearMass' : self.collMass(myEle, myMET, myTau), 'e_t_visibleMass' : self.visibleMass(myEle, myTau), 'MTTauMET' : self.transverseMass(myTau, myMET), 'dPhiTauMET' : self.deltaPhi(myTau.Phi(), myMET.Phi()), 'njets' : int(njets), 'vbfMass' : mjj}


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_fakes in itertools.product(self.loosenames, self.fakes):
      folder.append(os.path.join(*tuple_path_fakes))
    for f in folder:
      self.book(f, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myEle, myMET, myTau,  njets, mjj, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myTau, njets, mjj))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_categories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TightOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TightOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TauLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frEle = self.fakeRateEle(myEle.Pt(), myEle.Eta())
      weight = weight*frEle
      self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frEle = self.fakeRateEle(myEle.Pt(), myEle.Eta())
      weight = weight*frEle*frTau
      self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseTauLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseTauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, njets, mjj, weight, 'EleLooseTauLooseOS2JetVBF'+name)


  def fill_sys(self, row, myEle, myMET, myTau, weight):

    tmpEle = ROOT.TLorentzVector()
    tmpTau = ROOT.TLorentzVector()
    uncorTau = ROOT.TLorentzVector()
    uncorTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    tmpMET = ROOT.TLorentzVector()
    njets = row.jetVeto30
    mjj = row.vbfMass

    if self.is_mc:

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

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')

      if puweight==0:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')

      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      if row.tZTTGenMatching==5:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.92/0.89, '/tidUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.86/0.89, '/tidDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/tidUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/tidDown')

      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        if abs(myTau.Eta()) < 0.4:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.11/1.06, '/mtfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.01/1.06, '/mtfakeDown')
        elif abs(myTau.Eta()) < 0.8:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.06/1.02, '/mtfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98/1.02, '/mtfakeDown')
        elif abs(myTau.Eta()) < 1.2:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.14/1.10, '/mtfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.06/1.10, '/mtfakeDown')
        elif abs(myTau.Eta()) < 1.7:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.21/1.03, '/mtfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.85/1.03, '/mtfakeDown')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 2.29/1.94, '/mtfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.59/1.94, '/mtfakeDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/mtfakeDown')

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if abs(myTau.Eta()) < 1.46:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 2.00/1.80, '/etfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.60/1.80, '/etfakeDown')
        elif abs(myTau.Eta()) > 1.558:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 2.13/1.53, '/etfakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.93/1.53, '/etfakeDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etfakeDown')

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if row.tDecayMode==0 or row.tDecayMode==1:
          myMETpx = myMET.Px() - 0.007 * myTau.Px()
          myMETpy = myMET.Py() - 0.007 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.007)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/etefakeUp')
          myMETpx = myMET.Px() + 0.007 * myTau.Px()
          myMETpy = myMET.Py() + 0.007 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.993)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/etefakeDown')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etefakeUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etefakeDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etefakeUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/etefakeDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

      if not self.is_DY:
        if row.tZTTGenMatching==5:
          if row.tDecayMode==0:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM0Up', '/scaletDM0Down']]
            self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
          elif row.tDecayMode==1:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM1Up', '/scaletDM1Down']]
            self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
          elif row.tDecayMode==10:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM10Up', '/scaletDM10Down']]
            self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.009 * myTau.Px()
            myMETpy = myMET.Py() - 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.009)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
            myMETpx = myMET.Px() + 0.009 * myTau.Px()
            myMETpy = myMET.Py() + 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.991)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
          else:
            self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, self.scaleSys)
        else:
          self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, self.scaleSys)

      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')

      self.tauFRSys(row, myEle, myMET, myTau, njets, mjj, weight)
      self.eleFRSys(row, myEle, myMET, myTau, njets, mjj, weight)

      if not (self.is_recoilC and MetCorrection):
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnUp')
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnDown')

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
      self.eleFRSys(row, myEle, myMET, myTau, njets, mjj, weight)

      if self.is_embed:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.96, '/embtrDown')

        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

        if row.tDecayMode==0:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM0Up', '/scaletDM0Down']]
          self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
        elif row.tDecayMode==1:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM1Up', '/scaletDM1Down']]
          self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
        elif row.tDecayMode==10:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM10Up', '/scaletDM10Down']]
          self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.009 * myTau.Px()
          myMETpy = myMET.Py() - 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.009)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
          myMETpx = myMET.Px() + 0.009 * myTau.Px()
          myMETpy = myMET.Py() + 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.991)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_scaleSys(row, myEle, myMET, myTau, njets, mjj, weight, self.scaleSys)

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
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/embtrkUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/embtrkDown')


  def fill_scaleSys(self, row, myEle, myMET, myTau, njets, mjj, weight, scaleSys):
    for s in scaleSys:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, s)


  def tauFRSys(self, row, myEle, myMET, myTau, njets, mjj, weight):
    if not self.obj2_tight(row) and self.obj2_loose(row):
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
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, self.fakeSys)
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
        else:
          self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, self.fakeSys)


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


  def eleFRSys(self, row, myEle, myMET, myTau, njets, mjj, weight):
    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_loose(row):
      self.fill_elefr(row, myEle, myMET, myTau, njets, mjj, weight)


  def fill_elefr(self, row, myEle, myMET, myTau, njets, mjj, weight):
    myrand = random.random()
    if myrand < 0.5:
      weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Down') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep0Down')
      weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Down') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep1Down')
      weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp2Down') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakep2Down')
      fSys = [x for x in self.fakeEleSys if x not in ['/EleFakep0Down', '/EleFakep1Down', '/EleFakep2Down']]
      self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)
    else:
      weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp0Up') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep0Up')
      weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp1Up') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep1Up')
      weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frp2Up') * weight/self.fakeRateEle(myEle.Pt())
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakep2Up')
      fSys = [x for x in self.fakeEleSys if x not in ['/EleFakep0Up', '/EleFakep1Up', '/EleFakep2Up']]
      self.fill_fakeSys(row, myEle, myMET, myTau, njets, mjj, weight, fSys)


  def fill_fakeSys(self, row, myEle, myMET, myTau, njets, mjj, weight, fakeSys):
    for f in fakeSys:
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, f)


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.003 * myTau.Px()
        myMETpy = myMET.Py() - 0.003 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() - 0.036 * myTau.Px()
        myMETpy = myMET.Py() - 0.036 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.036)
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger27 = row.Ele27WPTightPass and row.eMatchesEle27Filter and row.eMatchesEle27Path and row.ePt > 28
      trigger32 = row.Ele32WPTightPass and row.eMatchesEle32Filter and row.eMatchesEle32Path and row.ePt > 33
      trigger35 = row.Ele35WPTightPass and row.eMatchesEle35Filter and row.eMatchesEle35Path and row.ePt > 36
      if self.is_embed:
        trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1
      else:
        trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1

      if self.filters(row):
        continue

      if not bool(trigger27 or trigger32 or trigger35 or trigger2430):
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
      singleSF = 0
      eltauSF = 0
      if self.is_mc:
        self.w2.var('e_pt').setVal(myEle.Pt())
        self.w2.var('e_iso').setVal(row.eRelPFIsoRho)
        self.w2.var('e_eta').setVal(myEle.Eta())
        eID = self.w2.function('e_id80_kit_ratio').getVal()
        eIso = self.w2.function('e_iso_kit_ratio').getVal()
        eReco = self.w2.function('e_trk_ratio').getVal()
        zvtx = 0.991
        if trigger27 or trigger32 or trigger35:
          singleSF = 0 if self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w2.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()
        else:
          eltauSF = 0 if self.w2.function('e_trg_EleTau_Ele24Leg_desy_mc').getVal()==0 else self.w2.function('e_trg_EleTau_Ele24Leg_desy_data').getVal()/self.w2.function('e_trg_EleTau_Ele24Leg_desy_mc').getVal()
          eltauSF = eltauSF * self.tauSF.getETauScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi())
        tEff = singleSF + eltauSF
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*zvtx*row.prefiring_weight
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.06
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.02
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.10
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*1.03
          else:
            weight = weight*1.94
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.80
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.53
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        if self.is_DY:
          self.w2.var('z_gen_mass').setVal(row.genMass)
          self.w2.var('z_gen_pt').setVal(row.genpT)
          dyweight = self.w2.function('zptmass_weight_nom').getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      trsel = 0
      mjj = row.vbfMass

      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        self.we.var('gt_pt').setVal(myEle.Pt())
        self.we.var('gt_eta').setVal(myEle.Eta())
        esel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt_pt').setVal(myTau.Pt())
        self.we.var('gt_eta').setVal(myTau.Eta())
        tsel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt1_pt').setVal(myEle.Pt())
        self.we.var('gt1_eta').setVal(myEle.Eta())
        self.we.var('gt2_pt').setVal(myTau.Pt())
        self.we.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.we.function('m_sel_trg_ratio').getVal()
        self.wp.var('e_pt').setVal(myEle.Pt())
        self.wp.var('e_eta').setVal(myEle.Eta())
        self.wp.var('e_phi').setVal(myEle.Phi())
        self.wp.var('e_iso').setVal(row.eRelPFIsoRho)
        e_id_sf = self.wp.function('e_id80_embed_kit_ratio').getVal()
        e_iso_sf = self.wp.function('e_iso_binned_embed_kit_ratio').getVal()
        e_trk_sf = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        self.we.var('e_pt').setVal(myEle.Pt())
        self.we.var('e_iso').setVal(row.eRelPFIsoRho)
        self.we.var('e_eta').setVal(myEle.Eta())
        self.we.var('t_pt').setVal(myTau.Pt())
        if myEle.Eta() < 1.479:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function('e_trg27_trg32_trg35_embed_kit_ratio').getVal()
          if trigger2430:
            trsel = trsel + self.we.function('e_trg_EleTau_Ele24Leg_kit_ratio_embed').getVal()*self.we.function('et_emb_LooseChargedIsoPFTau30_kit_ratio').getVal()
        else:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function('e_trg27_trg32_trg35_kit_data').getVal()
          if trigger2430:
            trsel = trsel + self.we.function('e_trg_EleTau_Ele24Leg_desy_data').getVal()*self.tauSF.getETauEfficiencyData(myTau.Pt(), myTau.Eta(), myTau.Phi())
        weight = weight*row.GenWeight*e_id_sf*e_iso_sf*e_trk_sf*dm*esel*tsel*trgsel*trsel*self.EmbedEta(myEle.Eta(), njets, mjj)*self.EmbedPt(myEle.Pt(), njets, mjj)
        if weight > 10:
          continue

      self.fill_sys(row, myEle, myMET, myTau, weight)

  def finish(self):
    self.write_histos()
