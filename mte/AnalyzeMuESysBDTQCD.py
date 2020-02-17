'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEQCDBase import MuEQCDBase
import EMTree
import itertools
import os

class AnalyzeMuESysBDTQCD(MegaBase, MuEQCDBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuESysBDTQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEQCDBase.__init__(self)


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


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myEle))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def fill_sshistos(self, myMuon, myMET, myEle, njets, weight, name=''):
    self.w2.var("njets").setVal(njets)
    self.w2.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Phi(), myMuon.Eta()))
    self.w2.var("e_pt").setVal(myEle.Pt())
    self.w2.var("m_pt").setVal(myMuon.Pt())
    osss = self.w2.function("em_qcd_osss").getVal()
    osss0rup = self.w2.function("em_qcd_osss_stat_0jet_unc1_up").getVal()
    osss0rdown = self.w2.function("em_qcd_osss_stat_0jet_unc1_down").getVal()
    osss1rup = self.w2.function("em_qcd_osss_stat_1jet_unc1_up").getVal()
    osss1rdown = self.w2.function("em_qcd_osss_stat_1jet_unc1_down").getVal()
    osss2rup = self.w2.function("em_qcd_osss_stat_2jet_unc1_up").getVal()
    osss2rdown = self.w2.function("em_qcd_osss_stat_2jet_unc1_down").getVal()
    osss0sup = self.w2.function("em_qcd_osss_stat_0jet_unc2_up").getVal()
    osss0sdown = self.w2.function("em_qcd_osss_stat_0jet_unc2_down").getVal()
    osss1sup = self.w2.function("em_qcd_osss_stat_1jet_unc2_up").getVal()
    osss1sdown = self.w2.function("em_qcd_osss_stat_1jet_unc2_down").getVal()
    osss2sup = self.w2.function("em_qcd_osss_stat_2jet_unc2_up").getVal()
    osss2sdown = self.w2.function("em_qcd_osss_stat_2jet_unc2_down").getVal()
    osssisoup = self.w2.function("em_qcd_osss_extrap_up").getVal()
    osssisodown = self.w2.function("em_qcd_osss_extrap_down").getVal()
    if '0Jet' in name:
      oslist = [osss, osss0rup, osss0rdown, osss0sup, osss0sdown, osss, osss, osss, osss, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])
    elif '1Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss1rup, osss1rdown, osss1sup, osss1sdown, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])
    elif '2Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss2rup, osss2rdown, osss2sup, osss2sdown, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])
    else:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])


  def fill_sscategories(self, row, myMuon, myMET, myEle, weight, name=''):
    mjj = row.vbfMassWoNoisyJets
    njets = row.jetVeto30WoNoisyJets
    self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS')
    if njets==0:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS0Jet')
    elif njets==1:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 550:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 550:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2JetVBF')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      if self.oppositesign(row):
        continue
      else:
        self.fill_sscategories(row, myMuon, myMET, myEle, weight)


  def finish(self):
    self.write_histos()
