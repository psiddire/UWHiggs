'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import Kinematics
import math
import os
import mcCorrections
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMuGen(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuGen, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, "e_m_CollinearMass", "Electron + Muon Collinear Mass", 60, 0, 300)


  def fill_histos(self, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/e_m_CollinearMass'].Fill(self.collMass(myEle, myMET, myMuon), weight)


  def process(self):

    for row in self.tree:

      # Selections
      if self.filters(row):
        continue

      if not bool(row.mu8e23DZPass and row.mGenPt > 10 and row.eGenPt > 24):
        continue

      if row.eGenPt < 24 or abs(row.eGenEta) >= 2.5:
        continue

      if row.mGenPt < 10 or abs(row.mGenEta) >= 2.4:
        continue

      if self.deltaR(row.eGenPhi, row.mGenPhi, row.eGenEta, row.mGenEta) < 0.4:
        continue

      if self.Emb and self.is_DY and not bool(row.isZmumu or row.isZee):
        continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue

      if not bool(self.vetos(row)):
        continue

      # Four Vectors
      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      myMETpx = myMET.Px() + myEle.Px() + myMuon.Px()
      myMETpy = myMET.Py() + myEle.Py() + myMuon.Py()

      myEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)
      myMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)

      myMETpx = myMETpx - myEle.Px() - myMuon.Px()
      myMETpy = myMETpy - myEle.Py() - myMuon.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      # Weight
      self.w1.var("e_pt").setVal(myEle.Pt())
      self.w1.var("e_eta").setVal(myEle.Eta())
      self.w1.var("m_pt").setVal(myMuon.Pt())
      self.w1.var("m_eta").setVal(myMuon.Eta())
      eff_trg_data = self.w1.function("e_trg_23_ic_data").getVal()*self.w1.function("m_trg_8_ic_data").getVal()
      eff_trg_mc = self.w1.function("e_trg_23_ic_mc").getVal()*self.w1.function("m_trg_8_ic_mc").getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff
      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        weight = weight * dyweight
        if row.numGenJets < 5:
          weight = weight*self.DYweight[row.numGenJets]
        else:
          weight = weight*self.DYweight[0]
      if self.is_W:
        if row.numGenJets < 5:
          weight = weight*self.Wweight[row.numGenJets]
        else:
          weight = weight*self.Wweight[0]
      if self.is_TT:
        if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and self.Emb:
          weight = 0.0
      weight = self.mcWeight.lumiWeight(weight)
      if weight > 10:
        weight = 0

      # OSSS
      self.w1.var("njets").setVal(njets)
      self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
      self.w1.var("e_pt").setVal(myEle.Pt())
      self.w1.var("m_pt").setVal(myMuon.Pt())
      osss = self.w1.function("em_qcd_osss").getVal()

      # b-tag
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data or self.is_embed) and nbtag > 0):
        weight = 0

      # Fill Histos
      mjj = row.vbfMassWoNoisyJets
      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphimumet = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      mtemet = self.transverseMass(myEle, myMET)

      if row.eGenCharge*row.mGenCharge==-1:
        self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS0Jet')
          if mtemet > 60 and dphimumet < 0.7 and dphiemu > 2.5 and myEle.Pt() > 30:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS0JetCut')
        elif njets==1:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS1Jet')
          if mtemet > 40 and dphimumet < 0.7 and dphiemu > 1.0 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS1JetCut')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2Jet')
          if mtemet > 15 and dphimumet < 0.5 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2JetCut')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2JetVBF')
          if mtemet > 15 and dphimumet < 0.3 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2JetVBFCut')
      else:
        self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS0Jet')
          if mtemet > 60 and dphimumet < 0.7 and dphiemu > 2.5 and myEle.Pt() > 30:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightSS0JetCut')
        elif njets==1:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS1Jet')
          if mtemet > 40 and dphimumet < 0.7 and dphiemu > 1.0 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightSS1JetCut')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS2Jet')
          if mtemet > 15 and dphimumet < 0.5 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightSS2JetCut')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS2JetVBF')
          if mtemet > 15 and dphimumet < 0.3 and myEle.Pt() > 26:
            self.fill_histos(myEle, myMET, myMuon, weight, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
