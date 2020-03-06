'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuQCDBase import EMuQCDBase
import EMTree
import ROOT
import math
import itertools
import os
import mcCorrections
from bTagSF import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMuSysBDTQCD(MegaBase, EMuQCDBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuSysBDTQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuQCDBase.__init__(self)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ues in itertools.product(self.names, self.ues):
      folder.append(os.path.join(*tuple_path_ues))
    for tuple_path_ss in itertools.product(self.ssnames, self.sssys):
      folder.append(os.path.join(*tuple_path_ss))
    for f in folder:
      self.book(f, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myMuon))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_sshistos(self, myEle, myMET, myMuon, njets, weight, name=''):
    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("m_pt").setVal(myMuon.Pt())
    osss = self.w1.function("em_qcd_osss_binned").getVal()
    osss0rup = self.w1.function("em_qcd_osss_0jet_rateup").getVal()
    osss0rdown = self.w1.function("em_qcd_osss_0jet_ratedown").getVal()
    osss1rup = self.w1.function("em_qcd_osss_1jet_rateup").getVal()
    osss1rdown = self.w1.function("em_qcd_osss_1jet_ratedown").getVal()
    osss2rup = self.w1.function("em_qcd_osss_2jet_rateup").getVal()
    osss2rdown = self.w1.function("em_qcd_osss_2jet_ratedown").getVal()
    osss0sup = self.w1.function("em_qcd_osss_0jet_shapeup").getVal()
    osss0sdown = self.w1.function("em_qcd_osss_0jet_shapedown").getVal()
    osss1sup = self.w1.function("em_qcd_osss_1jet_shapeup").getVal()
    osss1sdown = self.w1.function("em_qcd_osss_1jet_shapedown").getVal()
    osss2sup = self.w1.function("em_qcd_osss_2jet_shapeup").getVal()
    osss2sdown = self.w1.function("em_qcd_osss_2jet_shapedown").getVal()
    osssisoup = self.w1.function("em_qcd_extrap_up").getVal()
    osssisodown = self.w1.function("em_qcd_extrap_down").getVal()
    if '0Jet' in name:
      oslist = [osss, osss0rup, osss0rdown, osss0sup, osss0sdown, osss, osss, osss, osss, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    elif '1Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss1rup, osss1rdown, osss1sup, osss1sdown, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    elif '2Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss2rup, osss2rdown, osss2sup, osss2sdown, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    else:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])


  def fill_sscategories(self, row, myEle, myMET, myMuon, weight):
    mjj = row.vbfMass
    njets = row.jetVeto30
    self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS')
    if njets==0:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS0Jet')
    elif njets==1:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 500:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 500:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if self.oppositesign(row):
        continue
      else:
        self.fill_sscategories(row, myEle, myMET, myMuon, weight)


  def finish(self):
    self.write_histos()
