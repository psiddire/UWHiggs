'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import array

class AnalyzeMuTauBDT(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit('_', 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)


  def filltree(self, row, myMuon, myMET, myTau, weight):
    for varname, holder in self.holders:
      if varname=='mPt':
        holder[0] = myMuon.Pt()
      elif varname=='tPt':
        holder[0] = myTau.Pt()
      elif varname=='dPhiMuTau':
        holder[0] = self.deltaPhi(myMuon.Phi(), myTau.Phi())
      elif varname=='dEtaMuTau':
        holder[0] = self.deltaEta(myMuon.Eta(), myTau.Eta())
      elif varname=='type1_pfMetEt':
        holder[0] = myMET.Et()
      elif varname=='m_t_collinearMass':
        holder[0] = self.collMass(myMuon, myMET, myTau)
      elif varname=='MTTauMET':
        holder[0] = self.transverseMass(myTau, myMET)
      elif varname=='dPhiTauMET':
        holder[0] = self.deltaPhi(myTau.Phi(), myMET.Phi())
      elif varname=='dPhiMuMET':
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=='m_t_visibleMass':
        holder[0] = self.visibleMass(myMuon, myTau)
      elif varname=='m_t_PZeta':
        holder[0] = row.m_t_PZeta
      elif varname=='MTMuMET':
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=='njets':
        holder[0] = int(row.jetVeto30)
      elif varname=='vbfMass':
        holder[0] = row.vbfMass
      elif varname=='weight':
        holder[0] = weight
    self.tree1.Fill()


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myTau)

      if self.is_data:
        if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          frMuon = self.fakeRateMuon(myMuon.Pt())
          weight = weight*frTau*frMuon*-1
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

        if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          weight = weight*frTau
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

        if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
          frMuon = self.fakeRateMuon(myMuon.Pt())
          weight = weight*frMuon
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

      if self.is_mc:
        if self.obj2_tight(row) and self.obj1_tight(row):
          if self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

  # Write the histograms to the output files
  def finish(self):
    self.tree1.Write()
    self.write_histos()
