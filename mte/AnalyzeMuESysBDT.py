'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree
import ROOT
import math
import itertools
import os
import mcCorrections
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMuESysBDT(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuESysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


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


  def fill_categories(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS'+name)
    if njets==0:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet'+name)
    elif njets==1:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet'+name)
    elif njets==2 and mjj < 550:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet'+name)
    elif njets==2 and mjj > 550:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2JetVBF'+name)


  def fill_sshistos(self, myMuon, myMET, myEle, njets, weight, name=''):
    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
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
    mjj = row.vbfMass
    njets = row.jetVeto30
    self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS')
    if njets==0:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS0Jet')
    elif njets==1:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 550:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 550:
      self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2JetVBF')


  def fill_sys(self, row, myMuon, myMET, myEle, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpEle = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()
    mjj = row.vbfMass
    njets = row.jetVeto30

    if self.is_mc:

      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      if puweight==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightDown/puweight, '/puDown')

      if self.is_recoilC and self.MetCorrection:
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoDown')

      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, -1, 0)
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescDown')

      myMETpx = myMET.Px() - 0.002 * myMuon.Px()
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesUp')
      myMETpx = myMET.Px() + 0.002 * myMuon.Px()
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesDown')

      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        if dyweight==0:
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/DYptreweightUp')
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/DYptreweightDown')
        else:
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight/topweight, '/TopptreweightDown')

      if not (self.is_recoilC and self.MetCorrection):
        for u in self.ues:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/'+u)
        for j in self.jes:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          njets = getattr(row, 'jetVeto30_'+j)
          mjj = getattr(row, 'vbfMass_'+j)
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')
      if self.is_embed:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescDown')


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      if self.oppositesign(row):
        self.fill_sys(row, myMuon, myMET, myEle, weight)
      else:
        self.fill_sscategories(row, myMuon, myMET, myEle, weight)


  def finish(self):
    self.write_histos()
