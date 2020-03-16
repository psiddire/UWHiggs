'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree

class AnalyzeMuTauZTTBDT(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauZTTBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    for n in Kinematics.zttnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myTau))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_histos_gen(self, row, myMuon, myMET, myTau, weight, name=''):
    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets
    if self.oppositesign(row):
      self.fill_histos(myMuon, myMET, myTau, weight, name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, name+'0Jet')
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, name+'1Jet')
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name+'2Jet')
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name+'2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myMuon, myTau) < 40 or self.visibleMass(myMuon, myTau) > 80:
        continue

      if self.transverseMass(myMuon, myMET) > 40:
        continue

      if row.m_t_PZeta < -25:
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
