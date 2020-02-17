'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''  

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree
import ROOT
import math

class AnalyzeMuE(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuE, self).__init__(tree, outfile, **kwargs)
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

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
      mtmumet = self.transverseMass(myMuon, myMET)

      if self.oppositesign(row):
        self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS0Jet')
          if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS0JetCut')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS1Jet')
          if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS1JetCut')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2Jet')
          if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetCut')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetVBF')
          if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetVBFCut')
      else:
        self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS0Jet')
          if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS0JetCut')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS1Jet')
          if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS1JetCut')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2Jet')
          if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetCut')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBF')
          if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
