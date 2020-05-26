'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import itertools
import os
import ROOT
import mcCorrections
import mcWeights
from cutflowtracker import cut_flow_tracker
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso']
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMuReco(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuReco, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


  def begin(self):
    self.book('', 'CUT_FLOW', 'Cut Flow', len(cut_flow_step), 0, len(cut_flow_step))
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def process(self):

    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)

    for row in self.tree:

      weight = row.GenWeight*pucorrector[''](row.nTruePU)
      weight = self.mcWeight.lumiWeight(weight)

      cut_flow_trk.new_row(row.run, row.lumi, row.evt)
      #cut_flow_trk.Fill('allEvents', weight)
      cut_flow_trk.Fill('allEvents')

      # MET Filters
      if self.filters(row):
        continue
      #cut_flow_trk.Fill('passFilters', weight)
      cut_flow_trk.Fill('passFilters')

      # Lepton Opposite Sign
      if not self.oppositesign(row):
        continue
      #cut_flow_trk.Fill('passOppSign', weight)
      cut_flow_trk.Fill('passOppSign')

      # Trigger
      self.w1.var('e_pt').setVal(row.ePt)
      self.w1.var('e_eta').setVal(row.eEta)
      self.w1.var('e_iso').setVal(row.eRelPFIsoRho)
      self.w1.var('m_pt').setVal(row.mPt)
      self.w1.var('m_eta').setVal(row.mEta)
      if not self.trigger(row):
        continue
      eff_trg_data = self.w1.function('e_trg_23_data').getVal()*self.w1.function('m_trg_8_data').getVal()
      eff_trg_mc = self.w1.function('e_trg_23_mc').getVal()*self.w1.function('m_trg_8_mc').getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      weight = weight*tEff
      #cut_flow_trk.Fill('passTrigger', weight)
      cut_flow_trk.Fill('passTrigger')

      # Kinematics
      if not self.kinematics(row):
        continue
      #cut_flow_trk.Fill('passKinematics', weight)
      cut_flow_trk.Fill('passKinematics')

      # DeltaR
      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.4:
        continue
      #cut_flow_trk.Fill('passDeltaR', weight)
      cut_flow_trk.Fill('passDeltaR')

      # NJets
      if row.jetVeto30 > 2:
        continue
      #cut_flow_trk.Fill('passNjets', weight)
      cut_flow_trk.Fill('passNjets')

      # Vetoes
      if not self.vetos(row):
        continue
      #cut_flow_trk.Fill('passVetoes', weight)
      cut_flow_trk.Fill('passVetoes')

      # b-tag Veto
      nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
        weight = weight * btagweight
      #cut_flow_trk.Fill('passbjetVeto', weight)
      cut_flow_trk.Fill('passbjetVeto')

      # Electron ID
      eID = self.w1.function('e_id80_kit_ratio').getVal()
      weight = weight*eID
      if not self.obj1_id(row):
        continue
      #cut_flow_trk.Fill('passObj1id', weight)
      cut_flow_trk.Fill('passObj1id')

      # Electron Iso
      eIso = self.w1.function('e_iso_kit_ratio').getVal()
      weight = weight*eIso
      if not self.obj1_iso(row):
        continue
      #cut_flow_trk.Fill('passObj1iso', weight)
      cut_flow_trk.Fill('passObj1iso')

      # Muon ID
      mID = self.muonTightID(row.mPt, abs(row.mEta))
      weight = weight*mID
      if not self.obj2_id(row):
        continue
      #cut_flow_trk.Fill('passObj2id', weight)
      cut_flow_trk.Fill('passObj2id')

      # Muon Iso
      mIso = self.muonTightIsoTightID(row.mPt, abs(row.mEta))
      weight = weight*mIso
      if not self.obj2_iso(row):
        continue
      #cut_flow_trk.Fill('passObj2iso', weight)
      cut_flow_trk.Fill('passObj2iso')


  def finish(self):
    self.write_histos()
