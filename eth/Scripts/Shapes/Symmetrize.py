## Example code for this can be from the shapes plotting tool
import ROOT
import math
ROOT.gROOT.SetBatch(1)

# Get the list of samples and directories
samples = ['Fakes', 'ZTauTau', 'Zothers', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

dirs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

# File
f = ROOT.TFile.Open('shapesETBDT.root', 'READ')
#f = ROOT.TFile.Open('shapesET.root', 'READ')

fNew = ROOT.TFile.Open('NewShapes/shapesETBDT.root', 'RECREATE')
#fNew = ROOT.TFile.Open('NewShapes/shapesET.root', 'RECREATE')

# Go into the directory
for d in dirs:

    mydir = f.Get(d)

    di = fNew.mkdir(d)
    di.cd()

    hData = mydir.Get('data_obs')
    hData.Write()

    for sample in samples:
        hNom = mydir.Get(sample)
        hNomInt = hNom.Integral()
        sam = sample+'_'
        histolist = [x.GetName() for x in mydir.GetListOfKeys() if sample in x.GetName() and 'Up' in x.GetName() and x.GetName().startswith(sam)]
        for histo in histolist:
            hUp = mydir.Get(histo)
            hDown = mydir.Get(histo.replace('Up', 'Down'))
            hUpInt = hUp.Integral()
            hDownInt = hDown.Integral()
            for i in range(1, hUp.GetNbinsX()+1):
                hDown.SetBinContent(i, max(0.0, 2*hNom.GetBinContent(i)-hUp.GetBinContent(i)))
            if (hUpInt < hNomInt and hDownInt < hNomInt and abs(hUpInt - hNomInt)/hNomInt > 0.001 and abs(hDownInt - hNomInt)/hNomInt > 0.001) or (hUpInt > hNomInt and hDownInt > hNomInt and abs(hUpInt - hNomInt)/hNomInt > 0.001 and abs(hDownInt - hNomInt)/hNomInt > 0.001):
                pass
            else:
                hDown.Scale(hDownInt/hDown.Integral())
            hNom.Write()
            hUp.Write()
            hDown.Write()

