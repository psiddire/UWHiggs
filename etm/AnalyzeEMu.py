'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''  

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree

class AnalyzeEMu(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMu, self).__init__(tree, outfile, **kwargs)
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

      njets = row.jetVeto30
      mjj = row.vbfMass

      dphimumet = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      mtemet = self.transverseMass(myEle, myMET)

      if self.oppositesign(row):
        self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS0Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS0JetCut')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS1Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS1JetCut')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetCut')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetVBF')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetVBFCut')
      else:
        self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS0Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS0JetCut')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS1Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS1JetCut')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2Jet')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2JetCut')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2JetVBF')
          if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
            self.fill_histos(row, myEle, myMET, myMuon, weight*osss, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
