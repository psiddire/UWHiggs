'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import ROOT
import math

class AnalyzeETauZEE(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    super(AnalyzeETauZEE, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myEle, myTau) < 86.2 or self.visibleMass(myEle, myTau) > 96.2:
        continue

      if self.transverseMass(myEle, myMET) > 40:
        continue

      if myMET.Pt() > 25:
        continue

      weight = self.corrFact(row, myEle, myTau, singEle)

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS')


  def finish(self):
    self.write_histos()
