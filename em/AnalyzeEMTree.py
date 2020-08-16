'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT
import math
import array

class AnalyzeEMTree(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMTree, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


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


  def filltree(self, myEle, myMET, myMuon, itype, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = myMuon.Pt()
      elif varname=="ePt":
        holder[0] = myEle.Pt()
      elif varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="type1_pfMetEt":
        holder[0] = myMET.Et()
      elif varname=="itype":
        holder[0] = itype
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)

      if math.isnan(row.vbfMassWoNoisyJets):
        continue

      if self.oppositesign(row):
        if self.is_data:
          self.filltree(myEle, myMET, myMuon, 0, weight)
        else:
          self.filltree(myEle, myMET, myMuon, -1, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
