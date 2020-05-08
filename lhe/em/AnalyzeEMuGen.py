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

class AnalyzeEMuGen(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuGen, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def begin(self):
    for n in Kinematics.gennames:
      self.book(f, "e_m_VisibleMass", "Ele + Muon Visible Mass", 60, 0, 300)


  def fill_histos(self, myEle, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/e_m_VisibleMass'].Fill(self.visibleMass(myEle, myMuon), weight)


  def process(self):

    for row in self.tree:

      weight = row.GenWeight*pucorrector[''](row.nTruePU)

      njets, mjj = row.jetVeto30, row.vbfMass

      self.fill_histos(myEle, myMuon, weight, 'TightOSAll')
      if njets==0:
        self.fill_histos(myEle, myMuon, weight, 'TightOS0JetAll')
      elif njets==1:
        self.fill_histos(myEle, myMuon, weight, 'TightOS1JetAll')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetAll')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetVBFAll')

      if row.eGenPt < 24 or abs(row.eGenEta) >= 2.5:
        continue

      if row.mGenPt < 10 or abs(row.mGenEta) >= 2.4:
        continue

      if self.deltaR(row.eGenPhi, row.mGenPhi, row.eGenEta, row.mGenEta) < 0.4:
        continue

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)

      self.fill_histos(myEle, myMuon, weight, 'TightOS')
      if njets==0:
        self.fill_histos(myEle, myMuon, weight, 'TightOS0Jet')
      elif njets==1:
        self.fill_histos(myEle, myMuon, weight, 'TightOS1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
