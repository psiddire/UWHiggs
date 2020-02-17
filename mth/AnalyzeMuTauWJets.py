'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import math

class AnalyzeMuTauWJets(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauWJets, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def fill_histos_gen(self, row, myMuon, myMET, myTau, weight, name):
    njets = row.jetVeto30
    mjj = row.vbfMass
    if self.oppositesign(row) and self.transverseMass(myMuon, myMET) > 60 and self.transverseMass(myTau, myMET) > 80:
      self.fill_histos(row, myMuon, myMET, myTau, weight, name[0])
      if njets==0:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name[0]+'0Jet')
      elif njets==1:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name[0]+'1Jet')
      elif njets==2 and mjj < 550:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name[0]+'2Jet')
      elif njets==2 and mjj > 550:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name[0]+'2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myTau)

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'TauLooseWOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'TightWOS')

  # Write the histograms to the output files
  def finish(self):
    self.write_histos()
