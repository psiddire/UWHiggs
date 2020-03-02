'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import ROOT
import math
import Kinematics

class AnalyzeETauFitBDT(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETauFitBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myTau))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_histos_gen(self, row, myEle, myMET, myTau, weight, name):
    njets = row.jetVeto30
    mjj = row.vbfMass
    if self.oppositesign(row):
      if self.transverseMass(myEle, myMET) > 60 and self.transverseMass(myTau, myMET) > 80:
        self.fill_histos(myEle, myMET, myTau, weight, name[0])
        if njets==0:
          self.fill_histos(myEle, myMET, myTau, weight, name[0]+'0Jet')
        elif njets==1:
          self.fill_histos(myEle, myMET, myTau, weight, name[0]+'1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMET, myTau, weight, name[0]+'2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMET, myTau, weight, name[0]+'2JetVBF')
      self.fill_histos(myEle, myMET, myTau, weight, name[1])
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, name[1]+'0Jet')
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, name[1]+'1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, name[1]+'2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, weight, name[1]+'2JetVBF')
    else:
      self.fill_histos(myEle, myMET, myTau, weight, name[2])
      if njets==0:
        self.fill_histos(myEle, myMET, myTau, weight, name[2]+'0Jet')
      elif njets==1:
        self.fill_histos(myEle, myMET, myTau, weight, name[2]+'1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMET, myTau, weight, name[2]+'2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMET, myTau, weight, name[2]+'2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myTau, self.trigger(row)[0])

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        name = ['TauLooseWOS', 'TauLooseOS', 'TauLooseSS']
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, name)

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle
        name = ['EleLooseWOS', 'EleLooseOS', 'EleLooseSS']
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, name)

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle*frTau
        name = ['EleLooseTauLooseWOS', 'EleLooseTauLooseOS', 'EleLooseTauLooseSS']
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, name)

      if self.obj2_tight(row) and self.obj1_tight(row):
        name = ['TightWOS', 'TightOS', 'TightSS']
        self.fill_histos_gen(row, myEle, myMET, myTau, weight, name)


  def finish(self):
    self.write_histos()
