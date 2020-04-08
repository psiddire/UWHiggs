'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import itertools
import os
import ROOT

class AnalyzeEMu(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMu, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.lhe):
      folder.append(os.path.join(*tuple_path))
    for f in folder:
      self.book(f, "e_m_VisibleMass", "Ele + Muon Visible Mass", 60, 0, 300)
      self.book(f, "e_m_GenVisibleMass", "Ele + Muon Gen Visible Mass", 60, 0, 300)


  def fill_histos(self, row, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      histos[name+'/lhe'+str(i)+'/e_m_VisibleMass'].Fill((myEle+myMuon).M(), weight*lheweight)
      genMuon = ROOT.TLorentzVector()
      genMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)
      genEle = ROOT.TLorentzVector()
      genEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)
      histos[name+'/lhe'+str(i)+'/e_m_GenVisibleMass'].Fill((genEle+genMuon).M(), weight*lheweight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]

      njets, mjj = row.jetVeto30, row.vbfMass

      if self.obj2_iso(row) and self.obj1_iso(row):
        self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
