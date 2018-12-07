import ROOT
import os
ROOT.gROOT.SetBatch(True)
ROOT.gROOT.SetStyle("Plain")
ROOT.gStyle.SetOptTitle(0)

def make_dataset(tfile, x, y, dataset_name):
    pass_histo = tfile.Get('numerator')
    all_histo = tfile.Get('denominator')
    # Fill the data.
    graph = ROOT.TGraphAsymmErrors(pass_histo, all_histo)
    xy_data = ROOT.RooDataSet(
        dataset_name, dataset_name,
        ROOT.RooArgSet(x, y),
        ROOT.RooFit.StoreAsymError(ROOT.RooArgSet(y)),
        ROOT.RooFit.StoreError(ROOT.RooArgSet(x))
    )
    # Convert TGraph into x-y datasets
    for bin in range(graph.GetN()):
        xval = graph.GetX()[bin]
        yval = graph.GetY()[bin]
        xdown = graph.GetEXlow()[bin]
        xup = graph.GetEXhigh()[bin]
        ydown = graph.GetEYlow()[bin]
        yup = graph.GetEYhigh()[bin]
        x.setVal(xval)
        y.setVal(yval)
        x.setError(xup)
        #x.setError(1)
        y.setAsymError(-ydown, yup)
        xy_data.add(ROOT.RooArgSet(x, y))
    return xy_data

jobid = os.environ['jobid']

sources = {
    'm_pt10_h2taucuts_muonJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/m_wjets_pt10_h2taucuts_muonJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/m_qcd_pt10_h2taucuts_muonJetPt.root'   % jobid,
        },
    'm_pt20_h2taucuts_muonJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/m_wjets_pt20_h2taucuts_muonJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/m_qcd_pt20_h2taucuts_muonJetPt.root'   % jobid,
        },
    'e_pt10_h2taucuts_eJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/e_wjets_pt10_h2taucuts_eJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/e_qcd_pt10_h2taucuts_eJetPt.root'   % jobid,
        },
    'e_pt20_h2taucuts_eJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/e_wjets_pt20_h2taucuts_eJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/e_qcd_pt20_h2taucuts_eJetPt.root'   % jobid,
        },
    'ee_pt10_h2taucuts_eJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/ee_wjetsNoZmass_pt10_h2taucuts_electronJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/ee_qcd_pt10_h2taucuts_electronJetPt.root'          % jobid,
    },
    'ee_pt20_h2taucuts_eJetPt' : {
        'wjets' : 'results/%s/fakerate_fits/ee_wjetsNoZmass_pt20_h2taucuts_electronJetPt.root' % jobid,
        'qcd'   : 'results/%s/fakerate_fits/ee_qcd_pt20_h2taucuts_electronJetPt.root'          % jobid,
    },
}

for output, info in sources.iteritems():
    wjets_name = info['wjets']
    qcd_name   = info['qcd']
    wjets_file = ROOT.TFile.Open(wjets_name)
    wjets_src  = ROOT.TFile.Open(wjets_name.replace('.root','.corrected_inputs.root'))
    qcd_file   = ROOT.TFile.Open(qcd_name)
    qcd_src    = ROOT.TFile.Open(qcd_name.replace('.root','.corrected_inputs.root'))

    wjets_ws   = wjets_file.Get('fit_efficiency')
    qcd_ws     = qcd_file.Get('fit_efficiency')

    x          = wjets_ws.var('x')
    y          = wjets_ws.var('y')

    wjets_data = make_dataset(wjets_src, x, y, 'wjets_data')
    qcd_data   = make_dataset(qcd_src,   x, y, 'qcd_data')

    wjets_fcn  = wjets_ws.function('efficiency')
    qcd_fcn    = qcd_ws.function('efficiency')

    canvas     = ROOT.TCanvas("asdf", "asdf", 800, 600)
    xframe     = x.frame(ROOT.RooFit.Title("Efficiency"))

    canvas.SetGrid()

    wjets_fcn.plotOn(
        xframe,
        ROOT.RooFit.LineColor(ROOT.EColor.kBlue),
        )
    
    wjets_data.plotOnXY(
        xframe,
        ROOT.RooFit.YVar(y),
        ROOT.RooFit.MarkerColor(ROOT.EColor.kBlue),
        )

    qcd_fcn.plotOn(
        xframe,
        ROOT.RooFit.LineColor(ROOT.EColor.kRed),
        )

    qcd_data.plotOnXY(
        xframe,
        ROOT.RooFit.YVar(y),
        ROOT.RooFit.MarkerColor(ROOT.EColor.kRed),
        )

    xframe.SetMinimum(0.01)
    xframe.SetMaximum(0.7)
    xframe.GetYaxis().SetTitle("Fake Rate")
    xframe.GetXaxis().SetTitle("%s Jet p_{T} (GeV)" % ('Electron' if output[0] == 'e' else 'Muon'))

    xframe.Draw()
    canvas.SetLogy(True)
    canvas.Draw()
    canvas.SaveAs('results/%s/fakerate_fits/%s.pdf' % (jobid, output))
    canvas.SaveAs('results/%s/fakerate_fits/%s.png' % (jobid, output))


    wjets_file.Close()
    wjets_src.Close() 
    qcd_file.Close()  
    qcd_src.Close()   
