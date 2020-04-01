'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import itertools

class AnalyzeETau(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETau, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.lhe):
      folder.append(os.path.join(*tuple_path))
    for f in folder:
      self.book(f, "e_t_VisibleMass", "Electron + Tau Visible Mass", 60, 0, 300)
      self.book(f, "e_t_GenVisibleMass", "Electron + Tau Gen Visible Mass", 60, 0, 300)


  def fill_histos(self, row, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      histos[name+'/lhe'+str(i)+'/e_t_VisibleMass'].Fill((myEle+myTau).M(), weight*lheweight)
      genEle = ROOT.TLorentzVector()
      genEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)
      genTau = ROOT.TLorentzVector()
      genTau.SetPtEtaPhiM(row.tGenPt, row.tGenEta, row.tGenPhi, row.tMass)
      histos[name+'/lhe'+str(i)+'/e_t_GenVisibleMass'].Fill((genEle+genTau).M(), weight*lheweight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myTau)

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
