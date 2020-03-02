'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import math
import Kinematics

class AnalyzeMuTauFitBDT(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauFitBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myTau))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_histos_gen(self, row, myMuon, myMET, myTau, weight, name):
    njets = row.jetVeto30
    mjj = row.vbfMass
    if self.oppositesign(row):
      if self.transverseMass(myMuon, myMET) > 60 and self.transverseMass(myTau, myMET) > 80:
        self.fill_histos(myMuon, myMET, myTau, weight, name[0])
        if njets==0:
          self.fill_histos(myMuon, myMET, myTau, weight, name[0]+'0Jet')
        elif njets==1:
          self.fill_histos(myMuon, myMET, myTau, weight, name[0]+'1Jet')
        elif njets==2 and mjj < 550:
          self.fill_histos(myMuon, myMET, myTau, weight, name[0]+'2Jet')
        elif njets==2 and mjj > 550:
          self.fill_histos(myMuon, myMET, myTau, weight, name[0]+'2JetVBF')
      self.fill_histos(myMuon, myMET, myTau, weight, name[1])
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, name[1]+'0Jet')
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, name[1]+'1Jet')
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name[1]+'2Jet')
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name[1]+'2JetVBF')
    if not self.oppositesign(row):
      self.fill_histos(myMuon, myMET, myTau, weight, name[2])
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, weight, name[2]+'0Jet')
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, weight, name[2]+'1Jet')
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name[2]+'2Jet')
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, weight, name[2]+'2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myTau)

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        name = ['TauLooseWOS', 'TauLooseOS', 'TauLooseSS']
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, name)

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        name = ['MuonLooseWOS', 'MuonLooseOS', 'MuonLooseSS']
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, name)

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        name = ['MuonLooseTauLooseWOS', 'MuonLooseTauLooseOS', 'MuonLooseTauLooseSS']
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, name)

      if self.obj2_tight(row) and self.obj1_tight(row):
        name = ['TightWOS', 'TightOS', 'TightSS']
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, name)

  # Write the histograms to the output files
  def finish(self):
    self.write_histos()
