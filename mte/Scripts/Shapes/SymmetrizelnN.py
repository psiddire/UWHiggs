## Example code for this can be from the shapes plotting tool
import ROOT
import math
ROOT.gROOT.SetBatch(1)

# Get the list of samples and directories
samples = ['QCD', 'ZTauTau', 'Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

dirs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

# File
f = ROOT.TFile.Open('shapesMuEBDT.root', 'READ')
#f = ROOT.TFile.Open('shapesMuEBDTQCD.root', 'READ')
#f = ROOT.TFile.Open('shapesMuE.root', 'READ')
#f = ROOT.TFile.Open('shapesMuEQCD.root', 'READ')

fNew = ROOT.TFile.Open('NewShapes/shapesMuEBDT.root', 'RECREATE')
#fNew = ROOT.TFile.Open('NewShapes/shapesMuEBDTQCD.root', 'RECREATE')
#fNew = ROOT.TFile.Open('NewShapes/shapesMuE.root', 'RECREATE')
#fNew = ROOT.TFile.Open('NewShapes/shapesMuEQCD.root', 'RECREATE')

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
            if '_eFR_' in histo or '_muFR_' in histo or '_tauFR_' in histo or '_res_met_' in histo or '_scale_e' in histo or '_scale_m' in histo or '_scale_t_' in histo or '_tau_' in histo:
                for i in range(1, hUp.GetNbinsX()+1):
                    hDown.SetBinContent(i, max(0.0, 2*hNom.GetBinContent(i)-hUp.GetBinContent(i)))
                if (hUpInt < hNomInt and hDownInt < hNomInt) or (hUpInt > hNomInt and hDownInt > hNomInt):
                    pass
                else:
                    hDown.Scale(hDownInt/hDown.Integral()) if hDown.Integral()!=0 else hDown.Scale(1.0)
            hNom.Write()
            hUp.Write()
            hDown.Write()
