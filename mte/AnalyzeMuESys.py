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
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMuESys(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuESys, self).__init__(tree, outfile, **kwargs)
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
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 60, 0, 300)


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/m_e_CollinearMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)


  def fill_categories(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
    mtmumet = self.transverseMass(myMuon, myMET)
    self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS'+name)
    if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet'+name)
    elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet'+name)
    elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet'+name)
    elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
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


  def fill_sscategories(self, row, myMuon, myMET, myEle, weight):
    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
    mtmumet = self.transverseMass(myMuon, myMET)
    mjj = row.vbfMassWoNoisyJets
    njets = row.jetVeto30WoNoisyJets
    self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS')
    if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS0Jet')
    elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2JetVBF')


  def fill_sys(self, row, myMuon, myMET, myEle, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpEle = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()
    mjj = row.vbfMassWoNoisyJets
    njets = row.jetVeto30WoNoisyJets

    if self.is_mc:

      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')

      # Recoil Response and Resolution
      if self.is_recoilC and self.MetCorrection:
        if self.is_W:
          nj = njets + 1
        else:
          nj = njets
        rSys = self.RecSys(int(round(nj)))
        reSys = [x for x in self.recSys if x not in rSys]
        self.fill_SysNames(myMuon, myMET, myEle, njets, mjj, weight, reSys)
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(nj)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, rSys[0])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(nj)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, rSys[1])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(nj)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, rSys[2])
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(nj)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, rSys[3])

      # Pileup
      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      if puweight==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightDown/puweight, '/puDown')

      # b-tag
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, -1, 0)
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      # Pre-firing
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      # Electron Energy Scale
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesDown')

      # Muon Energy Scale
      me = self.MESSys(myMuon.Eta())[0]
      mes = self.MESSys(myMuon.Eta())[1]
      myMETpx = myMET.Px() - me * myMuon.Px()
      myMETpy = myMET.Py() - me * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.000 + me)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, mes[0])
      myMETpx = myMET.Px() + me * myMuon.Px()
      myMETpy = myMET.Py() + me * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.000 - me)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, mes[1])
      mSys = [x for x in self.mesSys if x not in mes]
      self.fill_SysNames(myMuon, myMET, myEle, njets, mjj, weight, mSys)

      # DY pT reweighting
      if self.is_DY:
        dyweight = self.DYreweight(row.genMass, row.genpT)
        if dyweight==0:
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/DYptreweightUp')
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/DYptreweightDown')
        else:
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*(1.1*dyweight-0.1)/dyweight, '/DYptreweightUp')
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*(0.9*dyweight+0.1)/dyweight, '/DYptreweightDown')

      # UES/JES
      if not (self.is_recoilC and self.MetCorrection):
        for u in self.ues:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/'+u)
        for j in self.jes:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          if 'JetRelativeBal' in j:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j+'WoNoisyJets')
          else:
            njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')
      if self.is_embed:
        # Embed Electron Energy Scale
        if abs(myEle.Eta()) < 1.479:
          eCorr = 0.005
        else:
          eCorr = 0.0125
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(1.00 + eCorr)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(1.00 - eCorr)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesDown')


  def fill_SysNames(self, myMuon, myMET, myEle, njets, mjj, weight, sysNames):
    for s in sysNames:
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, s)


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
