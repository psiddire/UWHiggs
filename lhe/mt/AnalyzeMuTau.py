'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import itertools

class AnalyzeMuTau(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.lhe):
      folder.append(os.path.join(*tuple_path))
    for f in folder:
      self.book(f, "m_t_VisibleMass", "Muon + Tau Visible Mass", 60, 0, 300)
      self.book(f, "m_t_GenVisibleMass", "Muon + Tau Gen Visible Mass", 60, 0, 300)


  def fill_histos(self, row, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      histos[name+'/lhe'+str(i)+'/m_t_VisibleMass'].Fill((myMuon+myTau).M(), weight*lheweight)
      genMuon = ROOT.TLorentzVector()
      genMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)
      genTau = ROOT.TLorentzVector()
      genTau.SetPtEtaPhiM(row.tGenPt, row.tGenEta, row.tGenPhi, row.tMass)
      histos[name+'/lhe'+str(i)+'/m_t_GenVisibleMass'].Fill((genMuon+genTau).M(), weight*lheweight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myTau)

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2JetVBF')



  def finish(self):
    self.write_histos()
