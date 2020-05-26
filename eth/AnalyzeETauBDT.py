'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import ROOT
import array

class AnalyzeETauBDT(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETauBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


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


  def filltree(self, row, myEle, myMET, myTau, weight):
    for varname, holder in self.holders:
      if varname=='ePt':
        holder[0] = myEle.Pt()
      elif varname=='tPt':
        holder[0] = myTau.Pt()
      elif varname=='dPhiETau':
        holder[0] = self.deltaPhi(myEle.Phi(), myTau.Phi())
      elif varname=='dEtaETau':
        holder[0] = self.deltaEta(myEle.Eta(), myTau.Eta())
      elif varname=='dPhiEMET':
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=='dPhiTauMET':
        holder[0] = self.deltaPhi(myTau.Phi(), myMET.Phi())
      elif varname=='e_t_collinearMass':
        holder[0] = self.collMass(myEle, myMET, myTau)
      elif varname=='e_t_visibleMass':
        holder[0] = self.visibleMass(myEle, myTau)
      elif varname=='e_t_PZeta':
        holder[0] = row.e_t_PZeta
      elif varname=='MTTauMET':
        holder[0] = self.transverseMass(myTau, myMET)
      elif varname=='MTEMET':
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=='type1_pfMetEt':
        holder[0] = myMET.Et()
      elif varname=='njets':
        holder[0] = int(row.jetVeto30WoNoisyJets)
      elif varname=='vbfMass':
        holder[0] = row.vbfMassWoNoisyJets
      elif varname=='weight':
        holder[0] = weight
    self.tree1.Fill()


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myTau, self.trigger(row)[0])

      if self.is_data:
        if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          frEle = self.fakeRateEle(myEle.Pt())
          weight = weight*frTau*frEle*-1
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, weight)

        if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          weight = weight*frTau
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, weight)

        if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
          frEle = self.fakeRateEle(myEle.Pt())
          weight = weight*frEle
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, weight)

      if self.is_mc:
        if self.obj2_tight(row) and self.obj1_tight(row):
          if self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
