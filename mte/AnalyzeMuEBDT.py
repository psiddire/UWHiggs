'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree
import ROOT
import math
import array

class AnalyzeMuEBDT(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuEBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def begin(self):
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)


  def filltree(self, row, myMuon, myMET, myEle, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = myMuon.Pt()
      elif varname=="ePt":
        holder[0] = myEle.Pt()
      elif varname=="m_e_collinearMass":
        holder[0] = self.collMass(myMuon, myMET, myEle)
      elif varname=="m_e_visibleMass":
        holder[0] = self.visibleMass(myMuon, myEle)
      elif varname=="dPhiMuMET":
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=="dPhiEMET":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="dPhiMuE":
        holder[0] = self.deltaPhi(myMuon.Phi(), myEle.Phi())
      elif varname=="MTMuMET":
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=="m_e_PZeta":
        holder[0] = row.e_m_PZeta
      elif varname=="MTEMET":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="dEtaMuE":
        holder[0] = self.deltaEta(myMuon.Eta(), myEle.Eta())
      elif varname=="type1_pfMetEt":
        holder[0] = myMET.Et()
      elif varname=="njets":
        holder[0] = int(row.jetVeto30)
      elif varname=="vbfMass":
        holder[0] = row.vbfMass
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      if math.isnan(row.vbfMass):
        continue

      if not self.oppositesign(row) and self.is_data:
        self.filltree(row, myMuon, myMET, myEle, weight)

      if self.oppositesign(row) and not self.is_data:
        self.filltree(row, myMuon, myMET, myEle, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
