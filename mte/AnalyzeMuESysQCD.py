'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEQCDBase import MuEQCDBase
import EMTree
import itertools
import os

class AnalyzeMuESysQCD(MegaBase, MuEQCDBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuESysQCD, self).__init__(tree, outfile, **kwargs)
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
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 60, 0, 300)


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/m_e_CollinearMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)


  def fill_sshistos(self, myMuon, myMET, myEle, njets, weight, name=''):
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


  def fill_sscategories(self, row, myMuon, myMET, myEle, weight):
    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
    mtmumet = self.transverseMass(myMuon, myMET)
    mjj = row.vbfMass
    njets = row.jetVeto30
    self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS')
    if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS0Jet')
    elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
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
