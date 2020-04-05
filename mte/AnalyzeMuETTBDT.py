'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

class AnalyzeMuETTBDT(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuETTBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def begin(self):
    for n in Kinematics.zttnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myEle))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      # b-tag
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2
      if bool(self.is_mc):
        if nbtag==0:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
          weight = weight * btagweight
        elif nbtag==1:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 1)
          weight = weight * btagweight
        elif nbtag==2:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 2)
          weight = weight * btagweight
      if nbtag < 1:
        weight = 0

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      if self.oppositesign(row):
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS')
        if njets==0:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2JetVBF')
      else:
        self.fill_histos(myMuon, myMET, myEle, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(myMuon, myMET, myEle, weight*osss, 'TightSS0Jet')
        elif njets==1:
          self.fill_histos(myMuon, myMET, myEle, weight*osss, 'TightSS1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(myMuon, myMET, myEle, weight*osss, 'TightSS2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
