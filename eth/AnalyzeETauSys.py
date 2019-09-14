B'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''
import ETauTree
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
import mcWeights
import Kinematics
from MEtSys import MEtSys
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote, bTagEventWeight
import random

gRandom.SetSeed()
rnd = gRandom.Rndm
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
    self.tauSF = mcCorrections.tauSF

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.eReco = mcCorrections.eReco
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateEle = mcCorrections.fakerateElectron_weight
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.wp = mcCorrections.wp
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPt = mcCorrections.EmbedPt

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.jes = Kinematics.jes

    super(AnalyzeETauSys, self).__init__(tree, outfile, **kwargs)
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
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


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
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names = ['TightOS', 'TightOS0Jet', 'TightOS1Jet']
    loosenames = ['TauLooseOS', 'EleLooseOS', 'EleLooseTauLooseOS', 'TauLooseOS0Jet', 'EleLooseOS0Jet', 'EleLooseTauLooseOS0Jet', 'TauLooseOS1Jet', 'EleLooseOS1Jet', 'EleLooseTauLooseOS1Jet']
    vbfnames = ['TightOS2Jet', 'TightOS2JetVBF']
    loosevbfnames = ['TauLooseOS2Jet', 'EleLooseOS2Jet', 'EleLooseTauLooseOS2Jet', 'TauLooseOS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseTauLooseOS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'tidUp', 'tidDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'bTagUp', 'bTagDown', 'embtrUp', 'embtrDown', 'embtrkUp', 'embtrkDown', 'mtfakeUp', 'mtfakeDown', 'etfakeUp', 'etfakeDown', 'etefakeUp', 'etefakeDown', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'eescUp', 'eescDown', 'eesiUp', 'eesiDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'TopptreweightUp', 'TopptreweightDown']
    fakes = ['', 'EleFakeUp', 'EleFakeDown', 'TauFakeEBDM0Up', 'TauFakeEBDM0Down', 'TauFakeEBDM1Up', 'TauFakeEBDM1Down', 'TauFakeEBDM10Up', 'TauFakeEBDM10Down', 'TauFakeEEDM0Up', 'TauFakeEEDM0Down', 'TauFakeEEDM1Up', 'TauFakeEEDM1Down', 'TauFakeEEDM10Up', 'TauFakeEEDM10Down']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_fakes in itertools.product(loosenames, fakes):
      folder.append(os.path.join(*tuple_path_fakes))
    for f in folder:
      self.book(f, "e_t_CollinearMass", "Electron + Tau Collinear Mass", 30, 0, 300)  

    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))
    for tuple_path_vbf_jes in itertools.product(vbfnames, self.jes):
      vbffolder.append(os.path.join(*tuple_path_vbf_jes))
    for tuple_path_vbffakes in itertools.product(loosevbfnames, fakes):
      vbffolder.append(os.path.join(*tuple_path_vbffakes))
    for f in vbffolder:
      self.book(f, "e_t_CollinearMass", "Electron + Tau Collinear Mass", 12, 0, 300)


  def fill_histos(self, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/e_t_CollinearMass'].Fill(self.collMass(myEle, myMET, myTau), weight)


  def fill_categories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      if self.oppositesign(row):
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
      if self.oppositesign(row):
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
      if self.oppositesign(row):
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
      if self.oppositesign(row):
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
    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets

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

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      if nbtag==0:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/bTagUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, -1, 0)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      if puweight==0:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')

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
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.007)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/etefakeUp')
          myMETpx = myMET.Px() + 0.007 * myTau.Px()
          myMETpy = myMET.Py() + 0.007 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
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
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eescUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eescDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesiUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesiDown')

      if not self.is_DY:
        if row.tZTTGenMatching==5:
          if row.tDecayMode==0:
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992) 
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
          elif row.tDecayMode==1:
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
          elif row.tDecayMode==10:
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            myMETpx = myMET.Px() - 0.009 * myTau.Px()
            myMETpy = myMET.Py() - 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.009)
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
            myMETpx = myMET.Px() + 0.009 * myTau.Px()
            myMETpy = myMET.Py() + 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.991) 
            self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
          else:
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')

      if self.is_DY:
        self.w2.var("z_gen_mass").setVal(row.genMass)
        self.w2.var("z_gen_pt").setVal(row.genpT)
        dyweight = self.w2.function("zptmass_weight_nom").getVal()
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*1.1, '/DYptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*0.9, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')

      self.tauFRSys(row, myEle, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frDown') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakeDown')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakeUp')
        else:
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frUp') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakeUp')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakeDown')

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
          njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/'+j)
      
    else:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.tauFRSys(row, myEle, myMET, myTau, njets, mjj, weight)

      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frDown') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, '/EleFakeDown')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakeUp')
        else:
          weightUp = 0 if self.fakeRateEle(myEle.Pt())==0 else self.fakeRateEle(myEle.Pt(), 'frUp') * weight/self.fakeRateEle(myEle.Pt())
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, '/EleFakeUp')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/EleFakeDown')

      if self.is_embed:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.96, '/embtrDown')

        if row.tDecayMode==0:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
        elif row.tDecayMode==1:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
        elif row.tDecayMode==10:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          myMETpx = myMET.Px() - 0.009 * myTau.Px()
          myMETpy = myMET.Py() - 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.009)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
          myMETpx = myMET.Px() + 0.009 * myTau.Px()
          myMETpy = myMET.Py() + 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.991)
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')

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


  def tauFRSys(self, row, myEle, myMET, myTau, njets, mjj, weight):
    if not self.obj2_tight(row) and self.obj2_loose(row):
      if abs(myTau.Eta()) < 1.5:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
        else:
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
      else:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')
        else:
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEEDM10Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM0Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM1Down')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Up')
          self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '/TauFakeEBDM10Down')


  def fill_taufr(self, row, myEle, myMET, myTau, njets, mjj, weight, name):
    myrand = random.random()
    if myrand < 0.5:
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frDown') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightDown, name+'Down')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, name+'Up')
    else:
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frUp') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weightUp, name+'Up')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, name+'Down')


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
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
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.003 * myTau.Px()
        myMETpy = myMET.Py() - 0.003 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() - 0.036 * myTau.Px()
        myMETpy = myMET.Py() - 0.036 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
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

      if self.deltaR(row.tPhi, row.ePhi, row.tEta, row.eEta) < 0.5:
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

      if not self.dieleveto(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

      if self.is_data or self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      singleSF = 0
      eltauSF = 0
      if self.is_mc:
        self.w2.var("e_pt").setVal(myEle.Pt())
        self.w2.var("e_iso").setVal(row.eRelPFIsoRho)
        self.w2.var("e_eta").setVal(myEle.Eta())
        eID = self.w2.function("e_id80_kit_ratio").getVal()
        eIso = self.w2.function("e_iso_kit_ratio").getVal()
        eReco = self.w2.function("e_trk_ratio").getVal()
        zvtx = 0.991
        if trigger27 or trigger32 or trigger35:
          singleSF = 0 if self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()==0 else self.w2.function("e_trg27_trg32_trg35_kit_data").getVal()/self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()
        else:
          eltauSF = 0 if self.w2.function("e_trg_EleTau_Ele24Leg_desy_mc").getVal()==0 else self.w2.function("e_trg_EleTau_Ele24Leg_desy_data").getVal()/self.w2.function("e_trg_EleTau_Ele24Leg_desy_mc").getVal()
          eltauSF = eltauSF * self.tauSF.getETauScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi())
        tEff = singleSF + eltauSF
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*zvtx
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
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
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
      mjj = row.vbfMassWoNoisyJets

      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        self.we.var("gt_pt").setVal(myEle.Pt())
        self.we.var("gt_eta").setVal(myEle.Eta())
        esel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt_pt").setVal(myTau.Pt())
        self.we.var("gt_eta").setVal(myTau.Eta())
        tsel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt1_pt").setVal(myEle.Pt())
        self.we.var("gt1_eta").setVal(myEle.Eta())
        self.we.var("gt2_pt").setVal(myTau.Pt())
        self.we.var("gt2_eta").setVal(myTau.Eta())
        trgsel = self.we.function("m_sel_trg_ratio").getVal()
        self.wp.var("e_pt").setVal(myEle.Pt())
        self.wp.var("e_eta").setVal(myEle.Eta())
        self.wp.var("e_phi").setVal(myEle.Phi())
        self.wp.var("e_iso").setVal(row.eRelPFIsoRho)
        e_id_sf = self.wp.function("e_id80_embed_kit_ratio").getVal()
        e_iso_sf = self.wp.function("e_iso_binned_embed_kit_ratio").getVal()
        e_trk_sf = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        self.we.var("e_pt").setVal(myEle.Pt())
        self.we.var("e_iso").setVal(row.eRelPFIsoRho)
        self.we.var("e_eta").setVal(myEle.Eta())
        self.we.var("t_pt").setVal(myTau.Pt())
        if myEle.Eta() < 1.479:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function("e_trg27_trg32_trg35_embed_kit_ratio").getVal()
          if trigger2430:
            trsel = trsel + self.we.function("e_trg_EleTau_Ele24Leg_kit_ratio_embed").getVal()*self.we.function("et_emb_LooseChargedIsoPFTau30_kit_ratio").getVal()
        else:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function("e_trg27_trg32_trg35_kit_data").getVal()
          if trigger2430:
            trsel = trsel + self.we.function("e_trg_EleTau_Ele24Leg_desy_data").getVal()*self.tauSF.getETauEfficiencyData(myTau.Pt(), myTau.Eta(), myTau.Phi())
        weight = weight*row.GenWeight*e_id_sf*e_iso_sf*e_trk_sf*dm*esel*tsel*trgsel*trsel*self.EmbedEta(myEle.Eta())*self.EmbedPt(myEle.Pt(), njets, mjj)
        if weight > 10:
          continue

      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data or self.is_embed) and nbtag > 0):
        weight = 0

      self.fill_sys(row, myEle, myMET, myTau, weight)

  def finish(self):
    self.write_histos()
