'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree

class AnalyzeMuEZTT(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuEZTT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myMuon, myEle) < 30 or self.visibleMass(myMuon, myEle) > 70:
        continue

      if myMuon.Pt() > 40:
        continue

      if self.transverseMass(myMuon, myMET) > 60:
        continue

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      if self.oppositesign(row):
        self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetVBF')
      else:
        self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS0Jet')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
