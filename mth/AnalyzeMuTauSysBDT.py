'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import math
import itertools
import os
import random
import mcCorrections
from bTagSF import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMuTauSysBDT(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauSysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


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
      self.book(f, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myTau))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_categories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon
      self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon*frTau
      self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF'+name)


  def fill_sys(self, row, myMuon, myMET, myTau, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpTau = ROOT.TLorentzVector()
    uncorTau = ROOT.TLorentzVector()
    uncorTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    tmpMET = ROOT.TLorentzVector()
    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets

    if self.is_mc:

      # Recoil Response and Resolution
      if self.is_recoilC and self.MetCorrection:
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
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, -1, 0)
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
        if dyweight==0:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/DYptreweightUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/DYptreweightDown')
        else:
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
      if not (self.is_recoilC and self.MetCorrection):
        for u in self.ues:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/'+u)
        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          if 'JetRelativeBal' in j:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j+'WoNoisyJets')
          else:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
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


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      if not self.oppositesign(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myTau)

      self.fill_sys(row, myMuon, myMET, myTau, weight)


  def finish(self):
    self.write_histos()
