'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import math

class AnalyzeMuTauZMM(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauZMM, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myMuon, myTau) < 86.2 or self.visibleMass(myMuon, myTau) > 96.2:
        continue

      if self.transverseMass(myMuon, myMET) > 40:
        continue

      if myMET.Pt() > 25:
        continue

      weight = self.corrFact(row, myMuon, myTau)

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS')

  # Write the histograms to the output files
  def finish(self):
    self.write_histos()
