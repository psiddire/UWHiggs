'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree

class AnalyzeETauZTT(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETauZTT, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


  def fill_histos_gen(self, row, myEle, myMET, myTau, weight, name=''):
    njets = row.jetVeto30
    mjj = row.vbfMass
    if self.oppositesign(row):
      self.fill_histos(row, myEle, myMET, myTau, weight, name)
      if njets==0:
        self.fill_histos(row, myEle, myMET, myTau, weight, name+'0Jet')
      elif njets==1:
        self.fill_histos(row, myEle, myMET, myTau, weight, name+'1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(row, myEle, myMET, myTau, weight, name+'2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(row, myEle, myMET, myTau, weight, name+'2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myEle, myTau) < 40 or self.visibleMass(myEle, myTau) > 80:
        continue

      if self.transverseMass(myEle, myMET) > 40:
        continue

      if row.e_t_PZeta < -25:
        continue

      weight = self.corrFact(row, myEle, myTau, self.trigger(row)[0])

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, 'TauLooseOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, 'EleLooseOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle*frTau
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, 'TightOS')


  def finish(self):
    self.write_histos()
