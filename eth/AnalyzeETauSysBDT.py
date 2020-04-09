'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import ROOT
import math
import itertools
import os
import random
import mcCorrections
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeETauSysBDT(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETauSysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


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


  def fill_histos(self, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myTau))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_categories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myEle, myMET, myTau, weight, 'TightOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myEle, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frEle = self.fakeRateEle(myEle.Pt())
      weight = weight*frEle
      self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frEle = self.fakeRateEle(myEle.Pt())
      weight = weight*frEle*frTau
      self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS'+name)
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, 'EleLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 500:
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

      # Nominal Histograms
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')

      # Recoil Response and Resolution
      if self.is_recoilC and self.MetCorrection:
        rSys = self.RecSys(int(round(njets)))
        reSys = [x for x in self.recSys if x not in rSys]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, reSys)
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, rSys[0])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, rSys[1])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, rSys[2])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, rSys[3])

      # B-Tagged Scale Factor
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/bTagUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, -1, 0)
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

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

      # Trigger
      if self.trigger(row)[0]:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')
      elif self.trigger(row)[1]:
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.054, '/trUp')
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.946, '/trDown')

      # Prefiring
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      # Tau ID
      if row.tZTTGenMatching==5:
        tW = self.deepTauVSjet_tight(myTau.Pt())
        tid = self.TauID(myTau.Pt())
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[1]/tW[0], tid[0])
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[2]/tW[0], tid[1])
        tSys = [x for x in self.tauidSys if x not in tid]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, tSys)
      else:
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.tauidSys)

      # Against Muon Discriminator
      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        mW = self.deepTauVSmu(myTau.Eta())
        mft = self.MuonFakeTau(abs(myTau.Eta()))
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * mW[1]/mW[0], mft[0])
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * mW[2]/mW[0], mft[1])
        mSys = [x for x in self.mtfakeSys if x not in mft]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, mSys)
      else:
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.mtfakeSys)

      # Muon Fake Tau Energy Scale
      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        mSys = [x for x in self.mtfakeesSys if 'Up' in x]
        myMETpx = myMET.Px() - 0.01 * myTau.Px()
        myMETpy = myMET.Py() - 0.01 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.01)
        self.fill_SysNames(row, myEle, tmpMET, tmpTau, njets, mjj, weight, mSys)
        mSys = [x for x in self.mtfakeesSys if 'Down' in x]
        myMETpx = myMET.Px() + 0.01 * myTau.Px()
        myMETpy = myMET.Py() + 0.01 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.99)
        self.fill_SysNames(row, myEle, tmpMET, tmpTau, njets, mjj, weight, mSys)
      else:
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.mtfakeesSys)

      # Against Electron Discriminator
      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        eW = self.deepTauVSe(myTau.Eta())
        eft = self.EleFakeTau(abs(myTau.Eta()))
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * eW[1]/eW[0], eft[0])
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * eW[2]/eW[0], eft[1])
        eSys = [x for x in self.etfakeSys if x not in eft]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, eSys)
      else:
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.etfakeSys)

      # Electron Fake Tau Energy Scale
      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        fes = self.FesTau(myTau.Eta(), row.tDecayMode)[0]
        efes = self.FesTau(myTau.Eta(), row.tDecayMode)[1]
        if efes!=[]:
          myMETpx = myMET.Px() - fes[1] * myTau.Px()
          myMETpy = myMET.Py() - fes[1] * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.000 + fes[1])
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, efes[0])
          myMETpx = myMET.Px() + fes[2] * myTau.Px()
          myMETpy = myMET.Py() + fes[2] * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.000 - fes[2])
          self.fill_categories(row, myEle, tmpMET, tmpTau, njets, mjj, weight, efes[1])
        eSys = [x for x in self.etfakeesSys if x not in efes]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, eSys)
      else:
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.etfakeesSys)

      # Electron Energy Scale
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

      # Tau Energy Scale
      if row.tZTTGenMatching==5:
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
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
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, self.scaleSys)

      # DY pT reweighting
      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        if dyweight==0:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/DYptreweightUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/DYptreweightDown')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      # Fake Rate
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

      # Jet and Unclustered Energy Scale
      if not (self.is_recoilC and self.MetCorrection):
        for u in self.ues:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/'+u)
        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          if 'JetRelativeBal' in j:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j+'WoNoisyJets')
          else:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          self.fill_categories(row, myEle, tmpMET, myTau, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, '')

      # Systematics for fakes from data
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
        # Embed Tau
        tW = self.deepTauVSjet_Emb_tight(myTau.Pt())
        tid = self.TauID(myTau.Pt())
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[1]/tW[0], tid[0])
        self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * tW[2]/tW[0], tid[1])
        tSys = [x for x in self.tauidSys if x not in tid]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, tSys)

        # Embed Electron Energy Scale
        if abs(myEle.Eta()) < 1.479:
          eCorr = 0.005
        else:
          eCorr = 0.0125
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(1.00 + eCorr)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(1.00 - eCorr)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, tmpMET, myTau, njets, mjj, weight, '/eesDown')

        # Embed Tau Energy Scale
        tes = self.ScaleTau(row.tDecayMode)
        sSys = [x for x in self.scaleSys if x not in tes[1]]
        self.fill_SysNames(row, myEle, myMET, myTau, njets, mjj, weight, sSys)
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
        if row.tDecayMode==0 or row.tDecayMode==1:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.983/0.975, '/embtrk0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 0.967/0.975, '/embtrk0Down')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/pow(0.975, 3), '/embtrk0Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/pow(0.975, 3), '/embtrk0Down')

        if row.tDecayMode==0 or row.tDecayMode==10:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/embtrk1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, '/embtrk1Down')
        else:
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.065/1.051, '/embtrk1Up')
          self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight * 1.037/1.051, '/embtrk1Down')


  def fill_SysNames(self, row, myEle, myMET, myTau, njets, mjj, weight, sysNames):
    for s in sysNames:
      self.fill_categories(row, myEle, myMET, myTau, njets, mjj, weight, s)


  def fill_fakeSys(self, row, myEle, myMET, myTau, njets, mjj, weight, fakeSys):
    for f in fakeSys:
      self.fill_loosecategories(row, myEle, myMET, myTau, njets, mjj, weight, f)


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
        elif row.tDecayMode == 11:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EBDM11')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM11Up', '/TauFakep1EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep1EBDM11Down']]
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
        elif row.tDecayMode == 11:
          self.fill_taufr(row, myEle, myMET, myTau, njets, mjj, weight, 'EEDM11')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM11Up', '/TauFakep1EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EEDM11Down']]
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


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      if not self.oppositesign(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myTau, self.trigger(row)[0])

      self.fill_sys(row, myEle, myMET, myTau, weight)


  def finish(self):
    self.write_histos()
