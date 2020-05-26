'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMuBase import EMuBase
import EMTree
import ROOT
import array
import math

class AnalyzeEMuBDT(MegaBase, EMuBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMuBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMuBase.__init__(self)


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


  def filltree(self, row, myEle, myMET, myMuon, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = myMuon.Pt()
      elif varname=="ePt":
        holder[0] = myEle.Pt()
      elif varname=="e_m_collinearMass":
        holder[0] = self.collMass(myEle, myMET, myMuon)
      elif varname=="e_m_visibleMass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="dPhiMuMET":
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=="dPhiEMET":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="dPhiEMu":
        holder[0] = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      elif varname=="MTMuMET":
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=="e_m_PZeta":
        holder[0] = row.e_m_PZeta
      elif varname=="MTEMET":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="dEtaEMu":
        holder[0] = self.deltaEta(myEle.Eta(), myMuon.Eta())
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

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if math.isnan(row.vbfMass):
        continue

      if not self.oppositesign(row):
        self.filltree(row, myEle, myMET, myMuon, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
