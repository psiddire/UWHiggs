'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''  

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree

class AnalyzeMuE(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuE, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def process(self):

    for row in self.tree:

      if row.evt==8255647:
        print "Pass 1: ", row.evt, round(myMuon.Pt(), 3), round(myMuon.Eta(), 3), round(myMuon.Phi(), 3), round(row.mRelPFIsoDBDefaultR04, 3), round(myEle.Pt(), 3), round(myEle.Eta(), 3), round(myEle.Phi(), 3), round(row.eRelPFIsoRho, 3), round(myMET.Pt(), 3), round(myMET.Phi(), 3), round(row.j1pt, 3), round(row.j1eta, 3), round(row.j1phi, 3), round(row.j2pt, 3), round(row.j2eta, 3), round(row.j2phi, 3), round(row.vbfMass, 3), row.jetVeto30, row.bjetDeepCSVVeto20Medium_2018_DR0p5
        print row.muGlbIsoVetoPt10, row.muVetoZTTp001dxyz

      if not self.eventSel(row):
        continue

      myMuon, myMET, myEle = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon, myEle)[0]
      osss = self.corrFact(row, myMuon, myEle)[1]

      njets = row.jetVeto30
      mjj = row.vbfMass

      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
      mtmumet = self.transverseMass(myMuon, myMET)

      if self.oppositesign(row):
        self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS0Jet')
          if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS0JetCut')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS1Jet')
          if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS1JetCut')
        elif njets==2 and mjj < 550:
          if row.evt==8255647:
            print "Pass 2 ", row.evt, round(myMuon.Pt(), 3), round(myMuon.Eta(), 3), round(myMuon.Phi(), 3), round(row.mRelPFIsoDBDefaultR04, 3), round(myEle.Pt(), 3), round(myEle.Eta(), 3), round(myEle.Phi(), 3), round(row.eRelPFIsoRho, 3), round(myMET.Pt(), 3), round(myMET.Phi(), 3), round(row.j1pt, 3), round(row.j1eta, 3), round(row.j1phi, 3), round(row.j2pt, 3), round(row.j2eta, 3), round(row.j2phi, 3), round(row.vbfMass, 3), row.jetVeto30, row.bjetDeepCSVVeto20Medium_2018_DR0p5
            print mtmumet, dphiemet
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2Jet')
          if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
            if row.evt==8255647:
              print "Pass 3"
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetCut')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetVBF')
          if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight, 'TightOS2JetVBFCut')
      else:
        self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS')
        if njets==0:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS0Jet')
          if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS0JetCut')
        elif njets==1:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS1Jet')
          if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS1JetCut')
        elif njets==2 and mjj < 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2Jet')
          if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetCut')
        elif njets==2 and mjj > 550:
          self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBF')
          if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
            self.fill_histos(row, myMuon, myMET, myEle, weight*osss, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
