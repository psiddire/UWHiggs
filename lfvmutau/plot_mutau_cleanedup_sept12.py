
from sys import argv, stdout, stderr
import ROOT
import sys

##get qcd normalization (choose selections for qcd)

def make_qcd_norm(presel, var, predir, savedir, channel ,wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file,data_ntuple_file,wjets1_norm, wjets2_norm, wjets3_norm, wjets4_norm, wjetsFiltered_norm, zjets_norm, ttbar_semi_norm, ttbar_full_norm, ww_norm):

        qcd_os_inc = 1.06* get_ss_inc_qcd(var,channel, wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file, wjets1_norm, wjets2_norm, wjets3_norm, wjets4_norm, wjetsFiltered_norm, zjets_norm, ttbar_semi_norm, ttbar_full_norm, ww_norm)  ##gets same sign inclusive qcd
        #factor of 1.06 for os inclusive qcd 
	
	if not presel: #get efficiency of vbf cuts
     		ssanti_iso_ntuple_spot = "ssantiisomuon" + channel ##channel = gg or vbf
        	qcd_antiiso_ss = data_ntuple_file.Get(ssanti_iso_ntuple_spot+"/"+var).Clone()
        	qcd_antiiso_ss_inc = data_pre_ntuple_file.Get(ssanti_iso_ntuple_spot+"/"+var).Clone()
		qcd_norm = qcd_os_inc*qcd_antiiso_ss.Integral()/qcd_antiiso_ss_inc.Integral()
	else:
		qcd_norm = qcd_os_inc
        return qcd_norm


#return same sign inclusive qcd normalization
def get_ss_inc_qcd(var,channel, wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file, wjets1_norm, wjets2_norm, wjets3_norm, wjets4_norm, wjetsFiltered_norm, zjets_norm, ttbar_semi_norm, ttbar_full_norm, ww_norm):

	if channel == "highMtssvbf":
		ss_ntuple_spot = "highMtssvbf"
	else:
		ss_ntuple_spot = "highMtss"+channel #channel = vbf or gg
	
	zjets_pre = zjets_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
	zjets_pre.Scale(zjets_norm)
	ttbar_semi_pre = ttbar_semi_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
        ttbar_full_pre = ttbar_full_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
        ttbar_semi_pre.Scale(ttbar_semi_norm)
        ttbar_full_pre.Scale(ttbar_full_norm)
	ttbar_pre = ttbar_full_pre.Clone()
        ttbar_pre.Add(ttbar_semi_pre)
	ww_pre = ww_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
	ww_pre.Scale(ww_norm)
	data_ss_inc = data_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
	wjets_pre = get_w(var,ss_ntuple_spot,wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file, wjets1_norm, wjets2_norm, wjets3_norm, wjets4_norm, wjetsFiltered_norm, zjets_norm, ttbar_semi_norm, ttbar_full_norm, ww_norm) #returns integral of w+jets estimation
	qcd_ss_inc = data_ss_inc.Integral() - zjets_pre.Integral()-ttbar_pre.Integral() - ww_pre.Integral()-wjets_pre #subtract MC from data to get QCD
	return qcd_ss_inc

	
## return w+jets MC estimation
def get_w(var,ss_ntuple_spot, wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file, wjets1_norm, wjets2_norm, wjets3_norm, wjets4_norm, wjetsFiltered_norm, zjets_norm, ttbar_semi_norm, ttbar_full_norm, ww_norm):

	if ss_ntuple_spot == "highMtssvbf":
		ss_highmt_ntuple_spot = "highMtssvbf"
	else:
		ss_highmt_ntuple_spot = "highMt"+ss_ntuple_spot 
	data_ss_highmt = data_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone() #data_ss_highmt
        zjets_ss_highmt = zjets_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
	zjets_ss_highmt.Scale(zjets_norm)
        ttbar_semi_ss_highmt = ttbar_semi_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
        ttbar_full_ss_highmt = ttbar_full_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
	ttbar_semi_ss_highmt.Scale(ttbar_semi_norm)
	ttbar_full_ss_highmt.Scale(ttbar_full_norm)
	ttbar_ss_highmt = ttbar_full_ss_highmt.Clone()
	ttbar_ss_highmt.Add(ttbar_semi_ss_highmt)
	
        ww_ss_highmt = ww_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
	ww_ss_highmt.Scale(ww_norm)
	
	wjets1_mc_ss_highmt = wjets1_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
	wjets1_mc_ss_highmt.Scale(wjets1_norm)
        wjets2_mc_ss_highmt = wjets2_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
        wjets2_mc_ss_highmt.Scale(wjets2_norm)
        wjets3_mc_ss_highmt = wjets3_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
        wjets3_mc_ss_highmt.Scale(wjets3_norm)
        wjets4_mc_ss_highmt = wjets4_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
        wjets4_mc_ss_highmt.Scale(wjets4_norm)
	wjetsFiltered_mc_ss_highmt = wjetsFiltered_pre_ntuple_file.Get(ss_highmt_ntuple_spot+"/"+var).Clone()
	wjetsFiltered_mc_ss_highmt.Scale(wjetsFiltered_norm)
	wjets_mc_ss_highmt = wjets1_mc_ss_highmt.Clone()
	wjets_mc_ss_highmt.Add(wjets2_mc_ss_highmt)
	wjets_mc_ss_highmt.Add(wjets3_mc_ss_highmt)
	wjets_mc_ss_highmt.Add(wjets4_mc_ss_highmt)
	wjets_mc_ss_highmt.Add(wjetsFiltered_mc_ss_highmt)

	wjets1_mc_ss = wjets1_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
	wjets1_mc_ss.Scale(wjets1_norm)
        wjets2_mc_ss = wjets2_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
        wjets2_mc_ss.Scale(wjets2_norm)
        wjets3_mc_ss = wjets3_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
        wjets3_mc_ss.Scale(wjets3_norm)
        wjets4_mc_ss = wjets4_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
        wjets4_mc_ss.Scale(wjets4_norm)
	wjetsFiltered_mc_ss = wjetsFiltered_pre_ntuple_file.Get(ss_ntuple_spot+"/"+var).Clone()
	wjetsFiltered_mc_ss.Scale(wjetsFiltered_norm)
	wjets_mc_ss = wjets1_mc_ss.Clone()
	wjets_mc_ss.Add(wjets2_mc_ss)
	wjets_mc_ss.Add(wjets3_mc_ss)
	wjets_mc_ss.Add(wjets4_mc_ss)
	wjets_mc_ss.Add(wjetsFiltered_mc_ss)

	wjets_ss_inc = (data_ss_highmt.Integral() - zjets_ss_highmt.Integral() - ttbar_ss_highmt.Integral()-ww_ss_highmt.Integral())*wjets_mc_ss.Integral()/wjets_mc_ss_highmt.Integral()  #compute wjets from data in highmt sideband wjets control region. Multiply by ss/highMtss yield from MC
	if ss_ntuple_spot == "highMtssvbf":
		return wjets_mc_ss_highmt.Integral()
	else:
		return wjets_ss_inc 



#########
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
#predir = "zjets_embedded_sept9/" #directory with preselection files
#predir = "gg_maria_cmp/"
#predir = "zjets_control_regions_sept6/"
#predir = "200GeVtPt_sept12/"
predir = "control_regions_fakerate_sept12/"
channel = "highMtssvbf" #channel (vbf or gg)
presel =  True#use preselection cuts or not
blind = True 
fakeRate = True #apply fake rate method
zjetsEmbed = False #use embedded data samples for zjets
seperateSemiFull = True #seperate semi and fully leptonic ttbar
##savedir contains the root files for plotting
if presel:
        savedir = predir

else:
        #savedir = "vbf_fakerate_centralveto_aug19/"
        #savedir = "vbf_embedded_fakerate_aug27/"
	savedir = "200GeVtPt_vbf_sept12/"
        #savedir = "control_regions_sept_2/"
##import parameters for input variable	
import mutau_vars
getVarParams = "mutau_vars."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
if presel:
	binwidth = 10
else:
	binwidth = varParams[1]
legend = eval(varParams[2])
blindlow = varParams[3]
blindhigh = varParams[4]
if blindlow==blindhigh:
        blind = False
isGeV = varParams[5]
if isGeV:
	ylabel = ynormlabel + " " + str(binwidth) + " GeV Binning"
else:
	ylabel = ynormlabel  

canvas = ROOT.TCanvas("canvas","canvas",800,800)
if blind == True or presel == True:
	p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0.3,1,1)
	p_lfv.SetBottomMargin(0.08)
	if var == "tPt":
		p_lfv.SetLogy()
	p_lfv.Draw()
	p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.3)
	p_ratio.SetTopMargin(0.1)
	p_ratio.Draw()
	p_lfv.cd()
LFVStack = ROOT.THStack("stack","")
hgglfv_ntuple_file_str = 'LFV_GluGlu_H2Tau_M-126.root'
hggsm_ntuple_file = ''
hvbflfv_ntuple_file_str = 'LFV_VBF_H2Tau_M-126.root'
zjets_ntuple_file_str = 'Zjets_M50.root'
dataEmb_ntuple_file_str = 'dataEmbedded_2012.root'
dy1jets_ntuple_file_str = 'DY1Jets_madgraph.root'
dy2jets_ntuple_file_str = 'DY2Jets_madgraph.root'
dy3jets_ntuple_file_str = 'DY3Jets_madgraph.root'
dy4jets_ntuple_file_str = 'DY4Jets_madgraph.root'
wjets1_ntuple_file_str = 'Wplus1Jets.root'
wjets2_ntuple_file_str = 'Wplus2Jets.root'
wjets3_ntuple_file_str = 'Wplus3Jets.root'
wjets4_ntuple_file_str = 'Wplus4Jets_madgraph.root'
wjetsFiltered_ntuple_file_str = 'WplusJets_madgraph_filtered.root'
ttbar_semi_ntuple_file_str = 'TTJets_SemiLeptMGDecays_8TeV-madgraph-tauola.root'
ttbar_full_ntuple_file_str = 'TTJets_FullLeptMGDecays_8TeV-madgraph-tauola.root'
ww_ntuple_file_str = 'WWJetsTo2L2Nu_TuneZ2_8TeV.root'
data_ntuple_file_str = 'data_2012.root'
hvbfsm_ntuple_file_str = 'VBF_H2Tau_M-125.root'

hgglfv_ntuple_file = ROOT.TFile(savedir+hgglfv_ntuple_file_str)
hvbflfv_ntuple_file = ROOT.TFile(savedir+hvbflfv_ntuple_file_str)
zjets_ntuple_file = ROOT.TFile(savedir+zjets_ntuple_file_str)
dy1jets_ntuple_file = ROOT.TFile(savedir+dy1jets_ntuple_file_str)
dy2jets_ntuple_file = ROOT.TFile(savedir+dy2jets_ntuple_file_str)
dy3jets_ntuple_file = ROOT.TFile(savedir+dy3jets_ntuple_file_str)
dy4jets_ntuple_file = ROOT.TFile(savedir+dy4jets_ntuple_file_str)
wjets1_ntuple_file = ROOT.TFile(savedir+wjets1_ntuple_file_str)
wjets2_ntuple_file = ROOT.TFile(savedir+wjets2_ntuple_file_str)
wjets3_ntuple_file = ROOT.TFile(savedir+wjets3_ntuple_file_str)
wjets4_ntuple_file = ROOT.TFile(savedir+wjets4_ntuple_file_str)
wjetsFiltered_ntuple_file = ROOT.TFile(savedir+wjetsFiltered_ntuple_file_str)
ttbar_semi_ntuple_file = ROOT.TFile(savedir+ttbar_semi_ntuple_file_str)
ttbar_full_ntuple_file = ROOT.TFile(savedir+ttbar_full_ntuple_file_str)
ww_ntuple_file = ROOT.TFile(savedir+ww_ntuple_file_str)
data_ntuple_file = ROOT.TFile(savedir+data_ntuple_file_str)
dataEmb_ntuple_file = ROOT.TFile(savedir+dataEmb_ntuple_file_str)
hvbfsm_ntuple_file = ROOT.TFile(savedir+hvbfsm_ntuple_file_str)

hgglfv_pre_ntuple_file = ROOT.TFile(predir+hgglfv_ntuple_file_str)
hvbflfv_pre_ntuple_file = ROOT.TFile(predir+hvbflfv_ntuple_file_str)
zjets_pre_ntuple_file = ROOT.TFile(predir+zjets_ntuple_file_str)
wjets1_pre_ntuple_file = ROOT.TFile(predir+wjets1_ntuple_file_str)
wjets2_pre_ntuple_file = ROOT.TFile(predir+wjets2_ntuple_file_str)
wjets3_pre_ntuple_file = ROOT.TFile(predir+wjets3_ntuple_file_str)
wjets4_pre_ntuple_file = ROOT.TFile(predir+wjets4_ntuple_file_str)
wjetsFiltered_pre_ntuple_file = ROOT.TFile(predir+wjetsFiltered_ntuple_file_str)
ttbar_semi_pre_ntuple_file = ROOT.TFile(predir+ttbar_semi_ntuple_file_str)
ttbar_full_pre_ntuple_file = ROOT.TFile(predir+ttbar_full_ntuple_file_str)
ww_pre_ntuple_file = ROOT.TFile(predir+ww_ntuple_file_str)
data_pre_ntuple_file = ROOT.TFile(predir+data_ntuple_file_str)

#get histograms
ntuple_spot = channel
hgglfv = hgglfv_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
hvbflfv = hvbflfv_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
hvbfsm = hvbfsm_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
zjetsMC = zjets_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
dy1jets = dy1jets_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
dy2jets = dy2jets_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
dy3jets = dy3jets_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
dy4jets = dy4jets_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
zjets = dataEmb_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
wjets1 = wjets1_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
wjets2 = wjets2_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
wjets3 = wjets3_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
wjets4 = wjets4_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
wjetsFiltered = wjetsFiltered_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
ttbar_semi = ttbar_semi_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
ttbar_full = ttbar_full_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
ww = ww_ntuple_file.Get(ntuple_spot+"/"+var).Clone()
data = data_ntuple_file.Get(ntuple_spot+"/"+var).Clone()


#define lumicalc files
data1_lumifile = 'lumicalc_new/data_SingleMu_Run2012A_22Jan2013_v1_2.lumicalc.sum'
data2_lumifile = 'lumicalc_new/data_SingleMu_Run2012B_22Jan2013_v1_2.lumicalc.sum'
data3_lumifile = 'lumicalc_new/data_SingleMu_Run2012C_22Jan2013_v1_2.lumicalc.sum'
data4_lumifile = 'lumicalc_new/data_SingleMu_Run2012D_22Jan2013_v1.lumicalc.sum'
dataEmb1_lumifile = 'lumicalc_new/data_EmbeddedDoubleMu_Run2012A_v1.lumicalc.sum'
dataEmb2_lumifile = 'lumicalc_new/data_EmbeddedDoubleMu_Run2012B_v1.lumicalc.sum'
dataEmb3_lumifile = 'lumicalc_new/data_EmbeddedDoubleMu_Run2012C_v1.lumicalc.sum'
dataEmb4_lumifile = 'lumicalc_new/data_EmbeddedDoubleMu_Run2012D_v1.lumicalc.sum'
wjets_extension_lumifile = 'lumicalc_new/WplusJets_madgraph_Extension.lumicalc.sum'
wjets1_lumifile = 'lumicalc_new/Wplus1Jets_madgraph.lumicalc.sum'
wjets1_ext_lumifile = 'lumicalc_new/Wplus1Jets_madgraph_extension.lumicalc.sum'
wjets2_lumifile = 'lumicalc_new/Wplus2Jets_madgraph.lumicalc.sum'
wjets2_ext_lumifile = 'lumicalc_new/Wplus2Jets_madgraph_extension.lumicalc.sum'
wjets3_lumifile = 'lumicalc_new/Wplus3Jets_madgraph.lumicalc.sum'
wjets3_ext_lumifile = 'lumicalc_new/Wplus3Jets_madgraph_extension.lumicalc.sum'
wjets4_lumifile = 'lumicalc_new/Wplus4Jets_madgraph.lumicalc.sum'
wjetsFiltered_lumifile = 'lumicalc_new/WplusJets_madgraph_filtered.lumicalc.sum'
dy1jets_lumifile = 'lumicalc_new/DY1Jets_madgraph.lumicalc.sum'
dy2jets_lumifile = 'lumicalc_new/DY2Jets_madgraph.lumicalc.sum'
dy3jets_lumifile = 'lumicalc_new/DY3Jets_madgraph.lumicalc.sum'
dy4jets_lumifile = 'lumicalc_new/DY4Jets_madgraph.lumicalc.sum'
zjets_lumifile = 'lumicalc_new/Zjets_M50.lumicalc.sum'
ttbar_full_lumifile = 'lumicalc_new/TTJets_FullLeptMGDecays_8TeV-madgraph-tauola.lumicalc.sum'
ttbar_semi_lumifile = 'lumicalc_new/TTJets_SemiLeptMGDecays_8TeV-madgraph-tauola.lumicalc.sum'
ww_lumifile = 'lumicalc_new/WWJetsTo2L2Nu_TuneZ2_8TeV.lumicalc.sum'
hvbflfv_lumifile = 'lumicalc_new/LFV_VBF_H2Tau_M-126.lumicalc.sum'
hgglfv_lumifile = 'lumicalc_new/LFV_GluGlu_H2Tau_M-126.lumicalc.sum'
hvbfsm_lumifile = 'lumicalc_new/VBF_H2Tau_M-125.lumicalc.sum'



#read lumicalc files

f = open(wjets_extension_lumifile).read().splitlines()
wjets_extension_efflumi = float(f[0])

f = open(wjets1_lumifile).read().splitlines()
wjets1_efflumi = float(f[0])

f = open(wjets1_ext_lumifile).read().splitlines()
wjets1_ext_efflumi = float(f[0])

f = open(wjets2_lumifile).read().splitlines()
wjets2_efflumi = float(f[0])

f = open(wjets2_ext_lumifile).read().splitlines()
wjets2_ext_efflumi = float(f[0])

f = open(wjets3_lumifile).read().splitlines()
wjets3_efflumi = float(f[0])

f = open(wjets3_ext_lumifile).read().splitlines()
wjets3_ext_efflumi = float(f[0])

f = open(wjets4_lumifile).read().splitlines()
wjets4_efflumi = float(f[0])

f = open(wjetsFiltered_lumifile).read().splitlines()
wjetsFiltered_efflumi = float(f[0])

f = open(zjets_lumifile).read().splitlines()
zjets_efflumi = float(f[0])

f = open(ttbar_semi_lumifile).read().splitlines()
ttbar_semi_efflumi = float(f[0])

f = open(ttbar_full_lumifile).read().splitlines()
ttbar_full_efflumi = float(f[0])

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

f = open(dataEmb1_lumifile).read().splitlines()
dataEmb1_lumi = float(f[0])

f = open(dataEmb2_lumifile).read().splitlines()
dataEmb2_lumi = float(f[0])

f = open(dataEmb3_lumifile).read().splitlines()
dataEmb3_lumi = float(f[0])

f = open(dataEmb4_lumifile).read().splitlines()
dataEmb4_lumi = float(f[0])

f = open(dy1jets_lumifile).read().splitlines()
dy1jets_efflumi = float(f[0])

f = open(dy2jets_lumifile).read().splitlines()
dy2jets_efflumi = float(f[0])

f = open(dy3jets_lumifile).read().splitlines()
dy3jets_efflumi = float(f[0])

f = open(dy3jets_lumifile).read().splitlines()
dy4jets_efflumi = float(f[0])

lumi = data1_lumi+data2_lumi+data3_lumi+data4_lumi
lumiEmb = dataEmb1_lumi+dataEmb2_lumi+dataEmb3_lumi+dataEmb4_lumi
wjets1_total_efflumi = wjets1_efflumi+wjets1_ext_efflumi
wjets2_total_efflumi = wjets2_efflumi+wjets2_ext_efflumi
wjets3_total_efflumi = wjets3_efflumi+wjets3_ext_efflumi

#define normalzing factors to normalize MC to data
wjets1_datanorm = lumi/wjets1_total_efflumi
wjets2_datanorm = lumi/wjets2_total_efflumi
wjets3_datanorm = lumi/wjets3_total_efflumi
wjets4_datanorm = lumi/wjets4_efflumi
wjetsFiltered_datanorm = lumi/wjetsFiltered_efflumi
dy1jets_datanorm = lumi/dy1jets_efflumi
dy2jets_datanorm = lumi/dy2jets_efflumi
dy3jets_datanorm = lumi/dy3jets_efflumi
dy4jets_datanorm = lumi/dy4jets_efflumi
zjets_datanorm = lumi/zjets_efflumi
ttbar_semi_datanorm = lumi/ttbar_semi_efflumi
ttbar_full_datanorm = lumi/ttbar_full_efflumi
ww_datanorm = lumi/ww_efflumi

#get qcd normalization
qcd_norm = make_qcd_norm(presel, var, predir, savedir, channel ,wjets1_pre_ntuple_file, wjets2_pre_ntuple_file, wjets3_pre_ntuple_file, wjets4_pre_ntuple_file, wjetsFiltered_pre_ntuple_file, zjets_pre_ntuple_file, ttbar_semi_pre_ntuple_file, ttbar_full_pre_ntuple_file, ww_pre_ntuple_file, data_pre_ntuple_file,data_ntuple_file, wjets1_datanorm, wjets2_datanorm, wjets3_datanorm, wjets4_datanorm, wjetsFiltered_datanorm, zjets_datanorm, ttbar_semi_datanorm, ttbar_full_datanorm, ww_datanorm)
#print zjets.Integral(ust )
if channel == "highMtssvbf":
	antiiso_ntuple_spot = "highMtssantiisomuonvbf"
else:
	antiiso_ntuple_spot = "antiisomuon"+channel #channel = vbf or gg
qcd = data_ntuple_file.Get(antiiso_ntuple_spot+"/"+var).Clone() #get antiisolated qcd shape
if qcd_norm < 0:  #if approximately no qcd
	qcd.Scale(0)
else:
	qcd.Scale(qcd_norm/qcd.Integral()) #normalized qcd shape
#correct for using looser vbf Cuts for qcd shape
if var == "vbfMass":
	for x in range(0,500):
		qcd.SetBinContent(x,0)
elif var == "vbfDeta":
	xbin = qcd.GetXaxis().FindBin(3.5)
	for x in range(0,xbin):
		qcd.SetBinContent(x,0)
	
if shape_norm == False: #normalize histos to data
	wjets1_norm = wjets1_datanorm
	wjets2_norm = wjets2_datanorm
	wjets3_norm = wjets3_datanorm
        wjets4_norm = wjets4_datanorm
	wjetsFiltered_norm = wjetsFiltered_datanorm
	zjets_norm = zjets_datanorm
	ztautau_norm = lumi/lumiEmb
	ttbar_semi_norm = ttbar_semi_datanorm
	ttbar_full_norm = ttbar_full_datanorm
	ww_norm = ww_datanorm
	hgglfv_norm = lumi/hgglfv_efflumi
	hvbflfv_norm = lumi/hvbflfv_efflumi
	hvbfsm_norm = lumi/hvbfsm_efflumi
	wjets1.Scale(wjets1_norm)
	wjets2.Scale(wjets2_norm)
        wjets3.Scale(wjets3_norm)
        wjets4.Scale(wjets4_norm)
	wjetsFiltered.Scale(wjetsFiltered_norm)
	wjets = wjets1.Clone()
	wjets.Add(wjets2)
	wjets.Add(wjets3)
	wjets.Add(wjets4)
	wjets.Add(wjetsFiltered)
	dy1jets.Scale(dy1jets_datanorm)
	dy2jets.Scale(dy2jets_datanorm)
        dy3jets.Scale(dy3jets_datanorm)
        dy4jets.Scale(dy4jets_datanorm)
	dyjets = dy1jets.Clone()
	dyjets.Add(dy2jets)
	dyjets.Add(dy3jets)
	dyjets.Add(dy4jets)
	ttbar_semi.Scale(ttbar_semi_norm)
	ttbar_full.Scale(ttbar_full_norm)
	ttbar = ttbar_full.Clone()
	ttbar.Add(ttbar_semi)
	zjetsMC.Scale(zjets_norm)
	if zjetsEmbed == False: #check whether or not to use embedded method
		zjets = zjetsMC.Clone()
	else:
		zjets.Scale(dyjets.Integral()/zjets.Integral())
	
else:   	#normailze histos to 1
	wjets = wjets1.Clone()
	wjets.Add(wjets2)
	wjets.Add(wjets3)
	wjets.Add(wjets4)
	wjets.Add(wjetsFiltered)
	ttbar = ttbar_full.Clone()
	ttbar.Add(ttbar_semi)
	wjets_norm = 1/wjets.Integral()
	zjets_norm = 1/zjets.Integral()
	ttbar_norm = 1/ttbar.Integral()
	ww_norm = 1/ww.Integral()
	hgglfv_norm = 1/(hgglfv.Integral())
	hvbflfv_norm = 1/(hvbflfv.Integral())
	hvbfsm_norm = 1/(hvbfsm.Integral())
	qcd_norm = 1/(qcd.Integral())
	qcd.Scale(qcd_norm)
	wjets.Scale(wjets_norm)
	ttbar.Scale(ttbar_norm)
	ttbar_full.Scale(1/ttbar_full.Integral())
	ttbar_semi.Scale(1/ttbar_semi.Integral())
	if zjetsEmbed == False:
		zjets = zjetsMC.Clone()
	zjets.Scale(1/zjets.Integral())
		

ww.Scale(ww_norm)
hgglfv.Scale(hgglfv_norm)
hvbflfv.Scale(hvbflfv_norm)
hvbfsm.Scale(hvbfsm_norm)
if channel == "highMtssvbf":
	fakechannel = "highMtssantiisotauvbf"
else:
	fakechannel = "antiisotau"+channel

if fakeRate == True:
	wjets = data_ntuple_file.Get(fakechannel+"/"+var).Clone()
	wjets.Scale(-1) ###made a mistake in analyzer, will fix

	if zjetsEmbed == False:
		zjetsFakes = zjets_ntuple_file.Get(fakechannel+"/"+var).Clone()
		zjetsFakes.Scale(zjets_norm)
	else:
		zjetsFakes = dataEmb_ntuple_file.Get(fakechannel+"/"+var).Clone()
		zjetsFakes.Scale(dyjets.Integral()/zjets.Integral())

	zjets.Add(zjetsFakes) #zjetsFakes = actual_zjetsFakes*-1, will fix
	ttbar_full_fakes = ttbar_full_ntuple_file.Get(fakechannel+"/"+var).Clone()
	ttbar_full_fakes.Scale(ttbar_full_norm)
	ttbar_semi_fakes = ttbar_semi_ntuple_file.Get(fakechannel+"/"+var).Clone()
	ttbar_semi_fakes.Scale(ttbar_semi_norm)
	ttbar.Add(ttbar_full_fakes) #ttbar_full_fakes = actual ttbar_full_fakes*-1)
	ttbar.Add(ttbar_semi_fakes) #ttbar_semi_fakes = actual ttbar_semi_fakes*-1)
	ttbar_semi.Add(ttbar_semi_fakes)
	ttbar_full.Add(ttbar_full_fakes)
	


outfile_name = savedir+"LFV"+"_"+channel+"_"+var
if fakeRate == True:
	outfile_name = outfile_name + "_fakeRate"
if zjetsEmbed == True:
	outfile_name = outfile_name +"_zjetsEmbed"

##create root file with yields for datacards
outfile = ROOT.TFile(outfile_name+".root","RECREATE")
outfile.cd()
if fakeRate == False:
	qcd.Write("qcd")
	wjets.Write("wjets")
else:
	wjets.Write("fakes")
if zjetsEmbed == False:
	zjets.Write("zjets")
else:
	zjets.Write("ztautau")
ttbar.Write("ttbar")
ttbar_semi.Write("ttbar semi")
ttbar_full.Write("ttbar full")
ww.Write("ww")
data.Write("data")
hvbflfv.Write("LFV VBF Higgs")
hgglfv.Write("LFV GG Higgs")
hvbfsm.Write("SM VBF Higgs")
outfile.Write()

hgglfv.SetLineColor(ROOT.EColor.kBlue+2)
hvbflfv.SetLineColor(ROOT.EColor.kRed+1)
hvbfsm.SetLineColor(ROOT.EColor.kGreen+8)
wjets.SetFillColor(ROOT.EColor.kPink-4)
zjets.SetFillColor(ROOT.EColor.kSpring+1)
ttbar.SetFillColor(ROOT.EColor.kCyan-2)
ttbar_full.SetFillColor(ROOT.EColor.kGreen+3)
ttbar_semi.SetFillColor(ROOT.EColor.kCyan-6)
ww.SetFillColor(ROOT.EColor.kCyan)
qcd.SetFillColor(ROOT.EColor.kYellow-9)
wjets.SetMarkerSize(0)
zjets.SetMarkerSize(0)
ttbar.SetMarkerSize(0)
ttbar_full.SetMarkerSize(0)
ttbar_semi.SetMarkerSize(0)
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
ttbar_full.Rebin(binwidth)
ttbar_semi.Rebin(binwidth)
ww.Rebin(binwidth)
qcd.Rebin(binwidth)
hgglfv.Rebin(binwidth)
hvbflfv.Rebin(binwidth)
hvbfsm.Rebin(binwidth)
data.Rebin(binwidth)
legend.AddEntry(hgglfv,'GG LFV Higgs')
legend.AddEntry(hvbflfv, 'VBF LFV Higgs')
legend.AddEntry(hvbfsm, 'VBF SM Higgs')
if fakeRate == False:
	legend.AddEntry(wjets,'W+Jets')
else:
	wjets.SetFillColor(ROOT.EColor.kBlue+1)
	legend.AddEntry(wjets, 'Fakes')
if zjetsEmbed == False: 
	legend.AddEntry(zjets,'Z+Jets')
else:
	legend.AddEntry(zjets, 'Z Tau Tau')
if seperateSemiFull == False:
	legend.AddEntry(ttbar,'TT+Jets')
else:
	legend.AddEntry(ttbar_full, 'TT Fully Leptonic')
	legend.AddEntry(ttbar_semi, 'TT Semi Leptonic')
legend.AddEntry(ww,'WW')
if fakeRate == False:
	legend.AddEntry(qcd,'QCD')
legend.SetFillColor(0)
legend.SetBorderSize(0)
if fakeRate == False:
	LFVStack.Add(qcd)
LFVStack.Add(ww)
if seperateSemiFull == False:
	LFVStack.Add(ttbar)
else:
	LFVStack.Add(ttbar_full)
	LFVStack.Add(ttbar_semi)
LFVStack.Add(zjets)
LFVStack.Add(wjets)
LFVStack.Draw('hist')
hgglfv.Draw('sameshist')
hvbflfv.Draw('sameshist')
hvbfsm.Draw('sameshist')

maxMC = LFVStack.GetMaximum()
maxData = data.GetMaximum()
if maxData>maxMC and shape_norm == False:
	maxHist = maxData
else:
	maxHist = maxMC
LFVStack.SetMaximum(maxHist*1.05)
print maxHist

if presel == True and shape_norm == False:
	data.Draw("sames")
        legend.AddEntry(data,'8 TeV Data')
elif blind == True and shape_norm == False:
	binblindlow = data.FindBin(blindlow)
	binblindhigh = data.FindBin(blindhigh)
	for x in range(binblindlow, binblindhigh):
		data.SetBinContent(x, -1000)
		
	data.Draw('sames')
	legend.AddEntry(data,'8 TeV Data')	
	pave = ROOT.TPave(blindlow,0,blindhigh,maxHist*1.1,4,"br")
	pave.SetFillColor(1)
	pave.SetFillStyle(3002)
	pave.SetBorderSize(0)
	pave.Draw()
	
legend.Draw('sames')
LFVStack.GetXaxis().SetTitle(xlabel)
LFVStack.GetYaxis().SetTitleOffset(1.2)
lumifb = '%.2f'%(lumi/1000)
title_str = "\sqrt{8} TeV Collisions  L = " + str(lumifb)+" fb^{-1}      "+ylabel
print title_str
LFVStack.SetTitle(title_str)

#signal to background ratio
maxbin = hvbflfv.GetMaximumBin()
sbratio =hvbflfv.GetBinContent(maxbin)/(ww.GetBinContent(maxbin)+wjets.GetBinContent(maxbin)+zjets.GetBinContent(maxbin)+ttbar.GetBinContent(maxbin))
print "Signal to Background Ratio: " + str(sbratio)
#p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.3)
#p_ratio.SetTopMargin(0.1)
#p_ratio.Draw()
if blind == True or presel == True:
	p_ratio.cd()
	ratio = data.Clone()
	mc = wjets.Clone()
	mc.Add(zjets)
	mc.Add(ttbar)
	if fakeRate == False:
		mc.Add(qcd)
	ratio.Divide(mc)
	ratio.Draw()
	ratio.SetTitle("Data:MC Ratio")
	ratio.GetYaxis().SetRangeUser(0,2)
if seperateSemiFull:
	outfile_name = outfile_name+"_semifull"
if shape_norm == False:
	canvas.SaveAs(outfile_name+".png")
else:
	canvas.SaveAs(outfile_name+"_shape.png")
print "QCD Integral: " + str(qcd.Integral())
print "Z+jets Integral: " + str(zjets.Integral())
print "W+jets Integral: " + str(wjets.Integral())
print "TTbar Integral: " + str(ttbar.Integral())
print "TTbar Full Integral: " + str(ttbar_full.Integral())
print "TTbar Semi Integral: " + str(ttbar_semi.Integral())
print "WW Integral: " + str(ww.Integral())
print "data Entries: " + str(data.GetEntries())
