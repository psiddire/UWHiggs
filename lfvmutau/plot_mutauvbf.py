
from sys import argv, stdout, stderr
import ROOT
import sys

##get qcd (choose selections for qcd)

def make_qcd_norm(presel, var, predir, savedir, channel ,wjets_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file,data_ntuple_file):

        qcd_norm_histo = get_ss_inc_qcd(var,channel, wjets_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file)  ##gets same sign inclusive qcd
        qcd_norm_histo.Scale(1.06) ##os inclusive qcd 
	if not presel: #get efficiency of vbf cuts
     		ssanti_iso_ntuple_spot = "ssantiisomuon"+channel
        	data_ntuple_file.cd(ssanti_iso_ntuple_spot)
        	qcd_antiiso_ss = ROOT.gDirectory.Get(var).Clone()
        	data_pre_ntuple_file.cd(ssanti_iso_ntuple_spot)
        	qcd_antiiso_ss_inc = ROOT.gDirectory.Get(var).Clone()
        	qcd_norm_histo.Multiply(qcd_antiiso_ss)
        	qcd_norm_histo.Divide(qcd_antiiso_ss_inc)

        return qcd_norm_histo



def get_ss_inc_qcd(var,channel, wjets_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file):

	ss_ntuple_spot = "ss"+channel
	zjets_pre_ntuple_file.cd(ss_ntuple_spot)
	zjets_pre = ROOT.gDirectory.Get(var).Clone()
	ttbar_pre_ntuple_file.cd(ss_ntuple_spot)
	ttbar_pre = ROOT.gDirectory.Get(var).Clone()
	ww_pre_ntuple_file.cd(ss_ntuple_spot)
	ww_pre = ROOT.gDirectory.Get(var).Clone()
	data_pre_ntuple_file.cd(ss_ntuple_spot)
	qcd_ss_inc = ROOT.gDirectory.Get(var).Clone()
	qcd_ss_inc.Add(zjets_pre,-1)
	qcd_ss_inc.Add(ttbar_pre,-1)
	qcd_ss_inc.Add(ww_pre,-1)
	wjets_pre = get_w(var,ss_ntuple_spot,wjets_pre_ntuple_file,zjets_pre_ntuple_file,ttbar_pre_ntuple_file,ww_pre_ntuple_file,data_pre_ntuple_file) #returns w+jets estimation
	qcd_ss_inc.Add(wjets_pre,-1)
	return qcd_ss_inc

	

def get_w(var,ss_ntuple_spot, wjets_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file):

	ss_highmt_ntuple_spot = "highMt"+ss_ntuple_spot
	data_pre_ntuple_file.cd(ss_highmt_ntuple_spot)
	wjets_ss_inc = ROOT.gDirectory.Get(var).Clone() #data_ss_highmt
	zjets_pre_ntuple_file.cd(ss_highmt_ntuple_spot)
        zjets_ss_highmt = ROOT.gDirectory.Get(var).Clone()
        ttbar_pre_ntuple_file.cd(ss_highmt_ntuple_spot)
        ttbar_ss_highmt = ROOT.gDirectory.Get(var).Clone()
        ww_pre_ntuple_file.cd(ss_highmt_ntuple_spot)
        ww_ss_highmt = ROOT.gDirectory.Get(var).Clone()
	wjets_pre_ntuple_file.cd(ss_highmt_ntuple_spot)
	wjets_mc_ss_highmt = ROOT.gDirectory.Get(var).Clone()
	wjets_pre_ntuple_file.cd(ss_ntuple_spot)
	wjets_mc_ss = ROOT.gDirectory.Get(var).Clone()
	wjets_ss_inc.Add(zjets_ss_highmt,-1)
	wjets_ss_inc.Add(ttbar_ss_highmt,-1)
	wjets_ss_inc.Add(ww_ss_highmt,-1) ##w_data_ss_highmt_
	wjets_ss_inc.Multiply(wjets_mc_ss)
	wjets_ss_inc.Divide(wjets_mc_ss_highmt)
	return wjets_ss_inc 

##Style##
ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
if len(argv) < 2:
	print "usage: python plot_mutau variable"
	sys.exit()
var = argv[1]
shape_norm = False
if shape_norm == False:
	ynormlabel = "Normalized to Data "
else:
	ynormlabel = "Normalized to 1 "
binwidth = 5  #define rebinning

#specify plotting schemes for individual variables
if var == "mPt":
	xlabel = "#mu P_{T} (GeV)"
	binwidth = 10
	legend =ROOT.TLegend(0.55,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel +" 10 GeV binning"
elif var == "tPt":
	xlabel = "#tau P_{T} (GeV)"
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel + " 5 GeV binning"
elif var == "mEta":
	xlabel = "#mu #eta"
	legend =ROOT.TLegend(0.2,0.6,0.4,0.8,'','brNDC')
	binwidth = 10
	ylabel = ynormlabel
elif var == "tEta":
	xlabel = "#tau #eta"
	legend =ROOT.TLegend(0.7,0.65,0.9,0.88,'','brNDC')
	binwidth = 10
	ylabel = ynormlabel
elif var == "mMtToPfMet_Ty1":
	xlabel = "#mu M_{T} Ty1 (GeV)"
	binwidth = 10
	ylabel = ynormlabel + " 10 GeV binning"
	legend =ROOT.TLegend(0.55,0.6,0.8,0.8,'','brNDC')
elif var == "tMtToPfMet_Ty1":
	xlabel = "#tau M_{T} Ty1 (GeV)"
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel + " 5 GeV binning"
elif var == "vbfDeta":
	xlabel = "#Delta#eta_{jj}"
	legend =ROOT.TLegend(0.6,0.6,0.9,0.8,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
elif var == "vbfDijetrap":
	xlabel ="Rapidity_{jj}"
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
elif var == "vbfDphihjnomet":
	xlabel = "#Delta#phi_{Hj} (no MET)"
	legend =ROOT.TLegend(0.2,0.6,0.5,0.8,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
elif var == "vbfDphihj":
	xlabel = "#Delta#phi_{Hj}"
	legend =ROOT.TLegend(0.2,0.6,0.5,0.8,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
elif var == "vbfHrap":
	xlabel = "Rapidity_{H}"
	legend =ROOT.TLegend(0.4,0.6,0.89,0.8,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
elif var == "vbfj1eta":
	xlabel = "#eta_{j1}"
	binwidth = 10
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel
elif var == "vbfj2eta":
	xlabel = "#eta_{j2}"
	binwidth = 10
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel
elif var == "vbfMass":
	xlabel = "M_{jj} (GeV)"
	binwidth = 10
	legend =ROOT.TLegend(0.15,0.6,0.45,0.8,'','brNDC')
	ylabel = ynormlabel + " 50 GeV binning"
elif var == "vbfMVA":
	xlabel = "MVAMET (GeV)"
	ylabel = ynormlabel
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
elif var == "vbfVispt":
	xlabel = "Visible P_{T} (GeV)"
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel + " 10 GeV binning"
elif var == "m_t_Mass":
	xlabel = "Visible Mass (GeV)"
	legend =ROOT.TLegend(0.48,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel + "10 GeV binning"
	binwidth = 10
elif var == "m_t_DPhi":
	xlabel = "#mu #tau #Delta#phi"
	legend = ROOT.TLegend(0.25,0.6,0.6,0.8,'','brNDC')
	ylabel = ynormlabel
elif var == "m_t_Pt":
	xlabel = "Visible P_{T} (GeV)"
	legend = ROOT.TLegend(0.45,0.5,0.85,0.8,'','brNDC')
	ylabel = ynormlabel + "10 GeV binning"
	binwidth = 10
elif var == "m_t_DR":
	xlabel = "#mu #tau #DeltaR"
	legend = ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel
elif var == "m_t_ToMETDPhi_Ty1":
	xlabel = "#Delta#phi (MET , #mu#tau)"
	legend = ROOT.TLegend(0.15,0.7,0.4,0.87,'','brNDC')
	ylabel = ynormlabel
	binwidth = 10
else:
	xlabel = var
	binwidth = 5
	legend =ROOT.TLegend(0.45,0.6,0.8,0.8,'','brNDC')
	ylabel = ynormlabel

predir = "presel_highmt/" #directory with preselection files
channel = "vbf" #channel (vbf or gg)
presel = False #use preselection cuts or not

##savedir contains the root files for plotting
if presel:
	savedir = predir 
else:
	savedir = "vbf_nomjj/"

canvas = ROOT.TCanvas("canvas","canvas",800,800)
LFVStack = ROOT.THStack("stack","")
hgglfv_ntuple_file_str = 'LFV_GluGlu_H2Tau_M-126.root'
hggsm_ntuple_file = ''
hvbflfv_ntuple_file_str = 'LFV_VBF_H2Tau_M-126.root'
zjets_ntuple_file_str = 'Zjets_M50.root'
wjets_ntuple_file_str = 'WplusJets_madgraph_Extension.root'
ttbar_ntuple_file_str = 'TTplusJets_madgraph.root'
ww_ntuple_file_str = 'WWJetsTo2L2Nu_TuneZ2_8TeV.root'
data_ntuple_file_str = 'data_2012.root'
hvbfsm_ntuple_file_str = 'VBF_H2Tau_M-125.root'

hgglfv_ntuple_file = ROOT.TFile(savedir+hgglfv_ntuple_file_str)
hvbflfv_ntuple_file = ROOT.TFile(savedir+hvbflfv_ntuple_file_str)
zjets_ntuple_file = ROOT.TFile(savedir+zjets_ntuple_file_str)
wjets_ntuple_file = ROOT.TFile(savedir+wjets_ntuple_file_str)
ttbar_ntuple_file = ROOT.TFile(savedir+ttbar_ntuple_file_str)
ww_ntuple_file = ROOT.TFile(savedir+ww_ntuple_file_str)
data_ntuple_file = ROOT.TFile(savedir+data_ntuple_file_str)
hvbfsm_ntuple_file = ROOT.TFile(savedir+hvbfsm_ntuple_file_str)

hgglfv_pre_ntuple_file = ROOT.TFile(predir+hgglfv_ntuple_file_str)
hvbflfv_pre_ntuple_file = ROOT.TFile(predir+hvbflfv_ntuple_file_str)
zjets_pre_ntuple_file = ROOT.TFile(predir+zjets_ntuple_file_str)
wjets_pre_ntuple_file = ROOT.TFile(predir+wjets_ntuple_file_str)
ttbar_pre_ntuple_file = ROOT.TFile(predir+ttbar_ntuple_file_str)
ww_pre_ntuple_file = ROOT.TFile(predir+ww_ntuple_file_str)
data_pre_ntuple_file = ROOT.TFile(predir+data_ntuple_file_str)



qcd_norm_histo = make_qcd_norm(presel, var, predir, savedir, channel ,wjets_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file,data_ntuple_file)
antiiso_ntuple_spot = "antiisomuon"+channel
data_ntuple_file.cd(antiiso_ntuple_spot)
qcd = ROOT.gDirectory.Get(var).Clone() #get antiisolated qcd shape

qcd.Scale(qcd_norm_histo.Integral()/qcd.Integral()) #normalized qcd shape

#get histograms
ntuple_spot = channel
hgglfv_ntuple_file.cd(ntuple_spot)
hgglfv = ROOT.gDirectory.Get(var).Clone()
hvbflfv_ntuple_file.cd(ntuple_spot)
hvbflfv = ROOT.gDirectory.Get(var).Clone()
#hggsm_ntuple_file.cd(hggsm_ntuple_spot)
hvbfsm_ntuple_file.cd(ntuple_spot)
hvbfsm = ROOT.gDirectory.Get(var).Clone()
zjets_ntuple_file.cd(ntuple_spot)
zjets = ROOT.gDirectory.Get(var).Clone()
wjets_ntuple_file.cd(ntuple_spot)
wjets = ROOT.gDirectory.Get(var).Clone()
ttbar_ntuple_file.cd(ntuple_spot)
ttbar = ROOT.gDirectory.Get(var).Clone()
ww_ntuple_file.cd(ntuple_spot)
ww = ROOT.gDirectory.Get(var).Clone()
data_ntuple_file.cd(ntuple_spot)
data = ROOT.gDirectory.Get(var).Clone()


#define lumicalc files
data1_lumifile = 'lumicalc/data_SingleMu_Run2012A_13Jul2012_v1.lumicalc.sum'
data2_lumifile = 'lumicalc/data_SingleMu_Run2012A_recover_06Aug2012_v1.lumicalc.sum'
data3_lumifile = 'lumicalc/data_SingleMu_Run2012B_22Jan2013_v1.lumicalc.sum'
data4_lumifile = 'lumicalc/data_SingleMu_Run2012C_24Aug2012_v1.lumicalc.sum'
data5_lumifile = 'lumicalc/data_SingleMu_Run2012C_PromptReco_v2.lumicalc.sum'
data6_lumifile = 'lumicalc/data_SingleMu_Run2012D_PromptReco_v1.lumicalc.sum'
wjets_lumifile = 'lumicalc/WplusJets_madgraph_Extension.lumicalc.sum'
zjets_lumifile = 'lumicalc/Zjets_M50.lumicalc.sum'
tt_lumifile = 'lumicalc/TTplusJets_madgraph.lumicalc.sum'
ww_lumifile = 'lumicalc/WWJetsTo2L2Nu_TuneZ2_8TeV.lumicalc.sum'
hvbflfv_lumifile = 'lumicalc/LFV_VBF_H2Tau_M-126.lumicalc.sum'
hgglfv_lumifile = 'lumicalc/LFV_GluGlu_H2Tau_M-126.lumicalc.sum'
hvbfsm_lumifile = 'lumicalc/VBF_H2Tau_M-125.lumicalc.sum'


#read lumicalc files
f = open(wjets_lumifile).read().splitlines()
wjets_efflumi = float(f[0])

f = open(zjets_lumifile).read().splitlines()
zjets_efflumi = float(f[0])

f = open(tt_lumifile).read().splitlines()
tt_efflumi = float(f[0])

f = open(ww_lumifile).read().splitlines()
ww_efflumi = float(f[0])

f = open(hvbflfv_lumifile).read().splitlines()
hvbflfv_efflumi = float(f[0])

f = open(hgglfv_lumifile).read().splitlines()
hgglfv_efflumi = float(f[0])

f = open(hvbfsm_lumifile).read().splitlines()
hvbfsm_efflumi = float(f[0])

f = open(data1_lumifile).read().splitlines()
data1_lumi = float(f[0])

f = open(data2_lumifile).read().splitlines()
data2_lumi = float(f[0])

f = open(data3_lumifile).read().splitlines()
data3_lumi = float(f[0])

f = open(data4_lumifile).read().splitlines()
data4_lumi = float(f[0])

f = open(data5_lumifile).read().splitlines()
data5_lumi = float(f[0])

f = open(data6_lumifile).read().splitlines()
data6_lumi = float(f[0])

lumi = data1_lumi+data2_lumi+data3_lumi+data4_lumi+data5_lumi+data6_lumi
#wjets_efflumi= 1580.01
#zjets_efflumi = 8505.626
#tt_efflumi = 30529.576
#ww_efflumi = 332328.452161#xsection = 5.82 pb
#smgg_higgs_efflumi = 784763.11 #xsection = 1.23 pb
#hgglfv_efflumi= 509885.536
#hvbflvf_efflumi = 6369426.75159
#lumi = 18025.9 #inverse picobarns


if shape_norm == False: #normalize histos to data
	wjets_norm = lumi/wjets_efflumi
	zjets_norm = lumi/zjets_efflumi
	tt_norm = lumi/tt_efflumi
	ww_norm = lumi/ww_efflumi
	#smgg_higgs_norm = lumi/smgg_higgs_efflumi
	hgglfv_norm = lumi/hgglfv_efflumi
	hvbflfv_norm = lumi/hvbflfv_efflumi
	hvbfsm_norm = lumi/hvbfsm_efflumi
	hgglfv.Scale(5*hgglfv_norm)
	hvbflfv.Scale(5*hvbflfv_norm)
	hvbfsm.Scale(5*hvbfsm_norm)
else:   	#normailze histos to 1
	wjets_norm = 1/wjets.Integral()
	zjets_norm = 1/zjets.Integral()
	tt_norm = 1/ttbar.Integral()
	ww_norm = 1/ww.Integral()
	hgglfv_norm = 1/(hgglfv.Integral())
	hvbflfv_norm = 1/(hvbflfv.Integral())
	hvbfsm_norm = 1/(hvbfsm.Integral())
	hvbfsm.Scale(hvbfsm_norm)
	hgglfv.Scale(hgglfv_norm)
	hvbflfv.Scale(hvbflfv_norm)
	qcd_norm = 1/(qcd.Integral())
	qcd.Scale(qcd_norm)

zjets.Scale(zjets_norm)
wjets.Scale(wjets_norm)
ttbar.Scale(tt_norm)
ww.Scale(ww_norm)

#wjets cross section (cmssw) = 37509.0 pb
#zjets cross section (cmssw) = 3503 pb
#tt cross section (cmssw) = 225.197 pb
#data_vbf.Scale(1.0/data_vbf.Integral())
#data_vbf.SetLineColor(ROOT.EColor.kBlue)
#signal_mc_vbf.SetLineColor(ROOT.EColor.kRed)
hgglfv.SetLineColor(ROOT.EColor.kGreen+3)
hvbflfv.SetLineColor(ROOT.EColor.kRed)
hvbfsm.SetLineColor(ROOT.EColor.kBlue)
wjets.SetFillColor(ROOT.EColor.kRed-5)
zjets.SetFillColor(ROOT.EColor.kGreen+6)
ttbar.SetFillColor(ROOT.EColor.kOrange-3)
ww.SetFillColor(ROOT.EColor.kYellow-2)
qcd.SetFillColor(ROOT.EColor.kMagenta+3)
wjets.SetMarkerSize(0)
zjets.SetMarkerSize(0)
ttbar.SetMarkerSize(0)
ww.SetMarkerSize(0)
qcd.SetMarkerSize(0)
hgglfv.SetMarkerSize(0)
hvbflfv.SetMarkerSize(0)
hvbfsm.SetMarkerSize(0)
hgglfv.SetLineWidth(3)
hvbflfv.SetLineWidth(3)
hvbfsm.SetLineWidth(3)
wjets.Rebin(binwidth)
zjets.Rebin(binwidth)
ttbar.Rebin(binwidth)
ww.Rebin(binwidth)
qcd.Rebin(binwidth)
hgglfv.Rebin(binwidth)
hvbflfv.Rebin(binwidth)
hvbfsm.Rebin(binwidth)
data.Rebin(binwidth)
#legend.AddEntry(data_vbf,'Data')
#legend.AddEntry(signal_mc_vbf),'VBF LFV MC')
if shape_norm == False:
	if "gg" in channel:
		legend.AddEntry(hgglfv,'5 X GG LFV Higgs')
	if "vbf" in channel:
		legend.AddEntry(hvbflfv, '5 X VBF LFV Higgs')
		legend.AddEntry(hvbfsm, '5 X VBF SM Higgs')

else:
        if "gg" in channel:
                legend.AddEntry(hgglfv,'GG LFV Higgs')
        if "vbf" in channel:
                legend.AddEntry(hvbflfv, 'VBF LFV Higgs')
		legend.AddEntry(hvbfsm, 'VBF SM Higgs')	
legend.AddEntry(wjets,'W+Jets')
legend.AddEntry(zjets,'Z+Jets')
legend.AddEntry(ttbar,'TT+Jets')
legend.AddEntry(ww,'WW')
legend.AddEntry(qcd,'QCD')
if presel == True:
	legend.AddEntry(data,'Data')
legend.SetFillColor(0)
legend.SetBorderSize(0)
LFVStack.Add(zjets)
LFVStack.Add(ttbar)
#LFVStack.Add(hgglfv)
LFVStack.Add(wjets)
LFVStack.Add(ww)
LFVStack.Add(qcd)
LFVStack.Draw('hist')
if presel == True:
	data.Draw('sames')
if "gg" in channel:
	hgglfv.Draw('sameshist')
if "vbf" in channel:
	hvbflfv.Draw('sameshist')
	hvbfsm.Draw('sameshist')
legend.Draw('sames')
LFVStack.GetXaxis().SetTitle(xlabel)
LFVStack.GetYaxis().SetTitleOffset(1.2)
LFVStack.SetTitle("\sqrt{8} TeV Collisions  L = 18.03 fb^{-1}      "+ylabel)

#signal to background ratio
maxbin = hvbflfv.GetMaximumBin()
sbratio =hvbflfv.GetBinContent(maxbin)/(ww.GetBinContent(maxbin)+wjets.GetBinContent(maxbin)+zjets.GetBinContent(maxbin)+ttbar.GetBinContent(maxbin))
print "Signal to Background Ratio: " + str(sbratio)

if shape_norm == False:
	canvas.SaveAs(savedir+"LFV"+var+".png")
else:
	canvas.SaveAs(savedir+"LFV"+var+"_shape.png")

