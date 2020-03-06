'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import ROOT
import math
from bTagSF import bTagEventWeight
import Kinematics

class AnalyzeEMuTTBDT(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuTTBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def begin(self):
    for n in Kinematics.fullnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myMuon))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      # b-tag
      nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
      if nbtag > 2:
        nbtag = 2
      if bool(self.is_mc):
        if nbtag==0:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
          weight = weight * btagweight
        elif nbtag==1:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 1)
          weight = weight * btagweight
        elif nbtag==2:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 2)
          weight = weight * btagweight
      if nbtag < 1:
        weight = 0

      njets = row.jetVeto30
      mjj = row.vbfMass

      if self.oppositesign(row):
        self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMET, myMuon, weight, 'TightOS2JetVBF')
      else:
        self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS0Jet')
        elif njets==1:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMET, myMuon, weight*osss, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
