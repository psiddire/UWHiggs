'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''  

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import ROOT
import math

class AnalyzeEMuQCD(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if self.obj1_loose(row) and not self.obj1_tight(row) and self.obj2_iso(row):
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS')
        else:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS')


  def finish(self):
    self.write_histos()
