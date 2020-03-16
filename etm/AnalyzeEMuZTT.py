'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree

class AnalyzeEMuZTT(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuZTT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myEle, myMuon) < 30 or self.visibleMass(myEle, myMuon) > 70:
        continue

      if myEle.Pt() > 40:
        continue

      if self.transverseMass(myEle, myMET) > 60:
        continue

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      if self.oppositesign(row):
        self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetVBF')
      else:
        self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS0Jet')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
