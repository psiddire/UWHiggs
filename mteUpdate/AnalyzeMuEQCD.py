'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''  

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree

class AnalyzeMuEQCD(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuEQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      if self.obj1_loose(row) and not self.obj1_tight(row) and self.obj2_iso(row):
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS')
        else:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS')


  def finish(self):
    self.write_histos()
