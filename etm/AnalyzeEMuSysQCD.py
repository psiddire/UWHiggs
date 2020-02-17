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

class AnalyzeEMuSysQCD(MegaBase, EMuQCDBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuSysQCD, self).__init__(tree, outfile, **kwargs)
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
      self.book(f, "e_m_CollinearMass", "Electron + Muon Collinear Mass", 60, 0, 300)


  def fill_histos(self, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/e_m_CollinearMass'].Fill(self.collMass(myEle, myMET, myMuon), weight)


  def fill_sshistos(self, myEle, myMET, myMuon, njets, weight, name=''):
    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Phi(), myMuon.Eta()))
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("m_pt").setVal(myMuon.Pt())
    osss = self.w1.function("em_qcd_osss").getVal()
    osss0rup = self.w1.function("em_qcd_osss_stat_0jet_unc1_up").getVal()
    osss0rdown = self.w1.function("em_qcd_osss_stat_0jet_unc1_down").getVal()
    osss1rup = self.w1.function("em_qcd_osss_stat_1jet_unc1_up").getVal()
    osss1rdown = self.w1.function("em_qcd_osss_stat_1jet_unc1_down").getVal()
    osss2rup = self.w1.function("em_qcd_osss_stat_2jet_unc1_up").getVal()
    osss2rdown = self.w1.function("em_qcd_osss_stat_2jet_unc1_down").getVal()
    osss0sup = self.w1.function("em_qcd_osss_stat_0jet_unc2_up").getVal()
    osss0sdown = self.w1.function("em_qcd_osss_stat_0jet_unc2_down").getVal()
    osss1sup = self.w1.function("em_qcd_osss_stat_1jet_unc2_up").getVal()
    osss1sdown = self.w1.function("em_qcd_osss_stat_1jet_unc2_down").getVal()
    osss2sup = self.w1.function("em_qcd_osss_stat_2jet_unc2_up").getVal()
    osss2sdown = self.w1.function("em_qcd_osss_stat_2jet_unc2_down").getVal()
    osssisoup = self.w1.function("em_qcd_osss_extrap_up").getVal()
    osssisodown = self.w1.function("em_qcd_osss_extrap_down").getVal()
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
    dphimumet = self.deltaPhi(myMuon.Phi(), myMET.Phi())
    mtemet = self.transverseMass(myEle, myMET)
    mjj = row.vbfMass
    njets = row.jetVeto30
    self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightOS')
    if njets==0 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightOS0Jet')
    elif njets==1 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightOS1Jet')
    elif njets==2 and mjj < 500 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightOS2Jet')
    elif njets==2 and mjj > 500 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
      self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightOS2JetVBF')


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
