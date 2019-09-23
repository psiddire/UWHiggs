import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import os
import ROOT
import glob
import array

ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
jobid = os.environ['jobid']
files = []
lumifiles = []

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*',  'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*', 'embed*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuESys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuESys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesMuE.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DYJetsToLL_M-50') or x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WGToLNuG'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV'), mc_samples)])
]

b = ['Zothers', 'W', 'WG', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

for di in dirs:

    #binning = array.array('d', (range(0, 50, 25) + range(50, 100, 10) + range(100, 150, 5) + range(150, 200, 10) + range(200, 300, 25)))
    if di=='0Jet':
        dr = '0jet'
        binning = array.array('d', range(0, 300, 10))
    elif di=='1Jet':
        dr = '1jet'
        binning = array.array('d', range(0, 300, 10))
    elif di=='2Jet':
        dr = '2jet_gg'
        binning = array.array('d', range(0, 300, 10))
    else:
        dr = '2jet_vbf'
        binning = array.array('d', range(0, 300, 10))

    #Observed
    d = f.mkdir(dr)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    data = DataAll.Get("m_e_CollinearMass")
    data = positivize(data)
    data = data.Rebin(len(binning)-1, "data_obs", binning)

    #QCD
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = QCD.Get("m_e_CollinearMass")
    qcd = positivize(qcd)
    qcd = qcd.Rebin(len(binning)-1, "QCD", binning)

    #QCD Systematics
    qcdr0up = QCD.Get("Rate0JetUp/m_e_CollinearMass")
    qcdr0up = positivize(qcdr0up)
    qcdr0up = qcdr0up.Rebin(len(binning)-1, "QCD_CMS_0JetRate_13TeVUp", binning)
    qcdr0down = QCD.Get("Rate0JetDown/m_e_CollinearMass")
    qcdr0down = positivize(qcdr0down)
    qcdr0down = qcdr0down.Rebin(len(binning)-1, "QCD_CMS_0JetRate_13TeVDown", binning)

    qcdr1up = QCD.Get("Rate1JetUp/m_e_CollinearMass")
    qcdr1up = positivize(qcdr1up)
    qcdr1up = qcdr1up.Rebin(len(binning)-1, "QCD_CMS_1JetRate_13TeVUp", binning)
    qcdr1down = QCD.Get("Rate1JetDown/m_e_CollinearMass")
    qcdr1down = positivize(qcdr1down)
    qcdr1down = qcdr1down.Rebin(len(binning)-1, "QCD_CMS_1JetRate_13TeVDown", binning)

    qcds0up = QCD.Get("Shape0JetUp/m_e_CollinearMass")
    qcds0up = positivize(qcds0up)
    qcds0up = qcds0up.Rebin(len(binning)-1, "QCD_CMS_0JetShape_13TeVUp", binning)
    qcds0down = QCD.Get("Shape0JetDown/m_e_CollinearMass")
    qcds0down = positivize(qcds0down)
    qcds0down = qcds0down.Rebin(len(binning)-1, "QCD_CMS_0JetShape_13TeVDown", binning)

    qcds1up = QCD.Get("Shape1JetUp/m_e_CollinearMass")
    qcds1up = positivize(qcds1up)
    qcds1up = qcds1up.Rebin(len(binning)-1, "QCD_CMS_1JetShape_13TeVUp", binning)
    qcds1down = QCD.Get("Shape1JetDown/m_e_CollinearMass")
    qcds1down = positivize(qcds1down)
    qcds1down = qcds1down.Rebin(len(binning)-1, "QCD_CMS_1JetShape_13TeVDown", binning)

    qcdiup = QCD.Get("IsoUp/m_e_CollinearMass")
    qcdiup = positivize(qcdiup)
    qcdiup = qcdiup.Rebin(len(binning)-1, "QCD_CMS_Extrapolation_13TeVUp", binning)
    qcdidown = QCD.Get("IsoDown/m_e_CollinearMass")
    qcdidown = positivize(qcdidown)
    qcdidown = qcdidown.Rebin(len(binning)-1, "QCD_CMS_Extrapolation_13TeVDown", binning)

    #Embedded
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    emball = views.SubdirectoryView(embed, 'TightOS'+di)
    emb = emball.Get("m_e_CollinearMass")
    emb = positivize(emb)
    emb = emb.Rebin(len(binning)-1, "ZTauTau", binning)

    #Electron Energy Scale
    embeescup = emball.Get('eescUp/m_e_CollinearMass')
    embeescup = positivize(embeescup)
    embeescup = embeescup.Rebin(len(binning)-1, "ZTauTau_CMS_EES_13TeVUp", binning)
    embeescdown = emball.Get('eescDown/m_e_CollinearMass')
    embeescdown = positivize(embeescdown)
    embeescdown = embeescdown.Rebin(len(binning)-1, "ZTauTau_CMS_EES_13TeVDown", binning)

    #Electron Energy Sigma
    #embeesiup = emball.Get('eesiUp/m_e_CollinearMass')
    #embeesiup = positivize(embeesiup)
    #embeesiup = embeesiup.Rebin(len(binning)-1, "embed_CMS_EESigma_13TeVUp", binning)
    #embeesidown = emball.Get('eesiDown/m_e_CollinearMass')
    #embeesidown = positivize(embeesidown)
    #embeesidown = embeesidown.Rebin(len(binning)-1, "embed_CMS_EESigma_13TeVDown", binning)

    for i in range(14):
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = DY.Get("m_e_CollinearMass")
        dy = positivize(dy)
        dy = dy.Rebin(len(binning)-1, b[i], binning)

        #Pileup
        dypuup = DY.Get("puUp/m_e_CollinearMass")
        dypuup = positivize(dypuup)
        dypuup = dypuup.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVUp", binning)
        dypudown = DY.Get("puDown/m_e_CollinearMass")
        dypudown = positivize(dypudown)
        dypudown = dypudown.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVDown", binning)

        #Prefiring
        dypfup = DY.Get("pfUp/m_e_CollinearMass")
        dypfup = positivize(dypfup)
        dypfup = dypfup.Rebin(len(binning)-1, b[i]+"_CMS_Prefiring_13TeVUp", binning)
        dypfdown = DY.Get("pfDown/m_e_CollinearMass")
        dypfdown = positivize(dypfdown)
        dypfdown = dypfdown.Rebin(len(binning)-1, b[i]+"_CMS_Prefiring_13TeVDown", binning)

        #Trigger
        dytrup = DY.Get("trUp/m_e_CollinearMass")
        dytrup = positivize(dytrup)
        dytrup = dytrup.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVUp", binning)
        dytrdown = DY.Get("trDown/m_e_CollinearMass")
        dytrdown = positivize(dytrdown)
        dytrdown = dytrdown.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVDown", binning)

        #Recoil Response and Resolution
        if b[i]=='Zothers' or  b[i]=='W' or b[i]=='EWK' or b[i]=='ggH_htt' or b[i]=='qqH_htt' or b[i]=='ggH_hww' or b[i]=='qqH_hww' or b[i]=='LFVGG125' or b[i]=='LFVVBF125':
            dyrecrespup = DY.Get("recrespUp/m_e_CollinearMass")
            dyrecrespup = positivize(dyrecrespup)
            dyrecrespup = dyrecrespup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVUp", binning)
            dyrecrespdown = DY.Get("recrespDown/m_e_CollinearMass")
            dyrecrespdown = positivize(dyrecrespdown)
            dyrecrespdown = dyrecrespdown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVDown", binning)

            dyrecresoup = DY.Get("recresoUp/m_e_CollinearMass")
            dyrecresoup = positivize(dyrecresoup)
            dyrecresoup = dyrecresoup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVUp", binning)
            dyrecresodown = DY.Get("recresoDown/m_e_CollinearMass")
            dyrecresodown = positivize(dyrecresodown)
            dyrecresodown = dyrecresodown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVDown", binning)

        #DY Pt Reweighting
        if b[i]=='Zothers':
            dyptup = DY.Get("DYptreweightUp/m_e_CollinearMass")
            dyptup = positivize(dyptup)
            dyptup = dyptup.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVUp", binning)
            dyptdown = DY.Get("DYptreweightDown/m_e_CollinearMass")
            dyptdown = positivize(dyptdown)
            dyptdown = dyptdown.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVDown", binning)

        #Top Pt Reweighting
        if b[i]=='TT':
            dyttptup = DY.Get("TopptreweightUp/m_e_CollinearMass")
            dyttptup = positivize(dyttptup)
            dyttptup = dyttptup.Rebin(len(binning)-1, b[i]+"_CMS_TTpTreweight_13TeVUp", binning)
            dyttptdown = DY.Get("TopptreweightDown/m_e_CollinearMass")
            dyttptdown = positivize(dyttptdown)
            dyttptdown = dyttptdown.Rebin(len(binning)-1, b[i]+"_CMS_TTpTreweight_13TeVDown", binning)

        #B-Tag
        dybtagup = DY.Get("bTagUp/m_e_CollinearMass")
        dybtagup = positivize(dybtagup)
        dybtagup = dybtagup.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVUp", binning)
        dybtagdown = DY.Get("bTagDown/m_e_CollinearMass")
        dybtagdown = positivize(dybtagdown)
        dybtagdown = dybtagdown.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVDown", binning)

        #Electron Energy Scale
        dyeescup = DY.Get("eescUp/m_e_CollinearMass")
        dyeescup = positivize(dyeescup)
        dyeescup = dyeescup.Rebin(len(binning)-1, b[i]+"_CMS_EES_13TeVUp", binning)
        dyeescdown = DY.Get("eescDown/m_e_CollinearMass")
        dyeescdown = positivize(dyeescdown)
        dyeescdown = dyeescdown.Rebin(len(binning)-1, b[i]+"_CMS_EES_13TeVDown", binning)

        #Electron Energy Sigma
        #dyeesiup = DY.Get("eesiUp/m_e_CollinearMass")
        #dyeesiup = positivize(dyeesiup)
        #dyeesiup = dyeesiup.Rebin(len(binning)-1, b[i]+"_CMS_EESigma_13TeVUp", binning)
        #dyeesidown = DY.Get("eesiDown/m_e_CollinearMass")
        #dyeesidown = positivize(dyeesidown)
        #dyeesidown = dyeesidown.Rebin(len(binning)-1, b[i]+"_CMS_EESigma_13TeVDown", binning)

        #Muon Energy Scale
        dymesup = DY.Get("mesUp/m_e_CollinearMass")
        dymesup = positivize(dymesup)
        dymesup = dymesup.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVUp", binning)
        dymesdown = DY.Get("mesDown/m_e_CollinearMass")
        dymesdown = positivize(dymesdown)
        dymesdown = dymesdown.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVDown", binning)

        if b[i]=='WG' or b[i]=='vH_htt' or b[i]=='TT' or b[i]=='T' or b[i]=='Diboson':
            #Unclustered Energy Scale
            dyuesup = DY.Get("UnclusteredEnUp/m_e_CollinearMass")
            dyuesup = positivize(dyuesup)
            dyuesup = dyuesup.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVUp", binning)
            dyuesdown = DY.Get("UnclusteredEnDown/m_e_CollinearMass")
            dyuesdown = positivize(dyuesdown)
            dyuesdown = dyuesdown.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVDown", binning)

            #Jet Energy Scale
            dyjetAFMup = DY.Get("JetAbsoluteFlavMapUp/m_e_CollinearMass")
            dyjetAFMup = positivize(dyjetAFMup)
            dyjetAFMup = dyjetAFMup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp", binning)
            dyjetAFMdown = DY.Get("JetAbsoluteFlavMapDown/m_e_CollinearMass")
            dyjetAFMdown = positivize(dyjetAFMdown)
            dyjetAFMdown = dyjetAFMdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown", binning)

            dyjetAMPFBup = DY.Get("JetAbsoluteMPFBiasUp/m_e_CollinearMass")
            dyjetAMPFBup = positivize(dyjetAMPFBup)
            dyjetAMPFBup = dyjetAMPFBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp", binning)
            dyjetAMPFBdown = DY.Get("JetAbsoluteMPFBiasDown/m_e_CollinearMass")
            dyjetAMPFBdown = positivize(dyjetAMPFBdown)
            dyjetAMPFBdown = dyjetAMPFBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown", binning)

            dyjetASup = DY.Get("JetAbsoluteScaleUp/m_e_CollinearMass")
            dyjetASup = positivize(dyjetASup)
            dyjetASup = dyjetASup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp", binning)
            dyjetASdown = DY.Get("JetAbsoluteScaleDown/m_e_CollinearMass")
            dyjetASdown = positivize(dyjetASdown)
            dyjetASdown = dyjetASdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown", binning)

            dyjetAStup = DY.Get("JetAbsoluteStatUp/m_e_CollinearMass")
            dyjetAStup = positivize(dyjetAStup)
            dyjetAStup = dyjetAStup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp", binning)
            dyjetAStdown = DY.Get("JetAbsoluteStatDown/m_e_CollinearMass")
            dyjetAStdown = positivize(dyjetAStdown)
            dyjetAStdown = dyjetAStdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown", binning)

            dyjetFQCDup = DY.Get("JetFlavorQCDUp/m_e_CollinearMass")
            dyjetFQCDup = positivize(dyjetFQCDup)
            dyjetFQCDup = dyjetFQCDup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp", binning)
            dyjetFQCDdown = DY.Get("JetFlavorQCDDown/m_e_CollinearMass")
            dyjetFQCDdown = positivize(dyjetFQCDdown)
            dyjetFQCDdown = dyjetFQCDdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown", binning)

            dyjetFup = DY.Get("JetFragmentationUp/m_e_CollinearMass")
            dyjetFup = positivize(dyjetFup)
            dyjetFup = dyjetFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVUp", binning)
            dyjetFdown = DY.Get("JetFragmentationDown/m_e_CollinearMass")
            dyjetFdown = positivize(dyjetFdown)
            dyjetFdown = dyjetFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVDown", binning)

            dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/m_e_CollinearMass")
            dyjetPUDMCup = positivize(dyjetPUDMCup)
            dyjetPUDMCup = dyjetPUDMCup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp", binning)
            dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/m_e_CollinearMass")
            dyjetPUDMCdown = positivize(dyjetPUDMCdown)
            dyjetPUDMCdown = dyjetPUDMCdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown", binning)

            dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/m_e_CollinearMass")
            dyjetPUPBBup = positivize(dyjetPUPBBup)
            dyjetPUPBBup = dyjetPUPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp", binning)
            dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/m_e_CollinearMass")
            dyjetPUPBBdown = positivize(dyjetPUPBBdown)
            dyjetPUPBBdown = dyjetPUPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown", binning)

            dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/m_e_CollinearMass")
            dyjetPUPEC1up = positivize(dyjetPUPEC1up)
            dyjetPUPEC1up = dyjetPUPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp", binning)
            dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/m_e_CollinearMass")
            dyjetPUPEC1down = positivize(dyjetPUPEC1down)
            dyjetPUPEC1down = dyjetPUPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown", binning)

            dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/m_e_CollinearMass")
            dyjetPUPEC2up = positivize(dyjetPUPEC2up)
            dyjetPUPEC2up = dyjetPUPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp", binning)
            dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/m_e_CollinearMass")
            dyjetPUPEC2down = positivize(dyjetPUPEC2down)
            dyjetPUPEC2down = dyjetPUPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown", binning)

            dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/m_e_CollinearMass")
            dyjetPUPHFup = positivize(dyjetPUPHFup)
            dyjetPUPHFup = dyjetPUPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp", binning)
            dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/m_e_CollinearMass")
            dyjetPUPHFdown = positivize(dyjetPUPHFdown)
            dyjetPUPHFdown = dyjetPUPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown", binning)

            dyjetPUPRup = DY.Get("JetPileUpPtRefUp/m_e_CollinearMass")
            dyjetPUPRup = positivize(dyjetPUPRup)
            dyjetPUPRup = dyjetPUPRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp", binning)
            dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/m_e_CollinearMass")
            dyjetPUPRdown = positivize(dyjetPUPRdown)
            dyjetPUPRdown = dyjetPUPRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown", binning)

            dyjetRFSRup = DY.Get("JetRelativeFSRUp/m_e_CollinearMass")
            dyjetRFSRup = positivize(dyjetRFSRup)
            dyjetRFSRup = dyjetRFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp", binning)
            dyjetRFSRdown = DY.Get("JetRelativeFSRDown/m_e_CollinearMass")
            dyjetRFSRdown = positivize(dyjetRFSRdown)
            dyjetRFSRdown = dyjetRFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown", binning)

            dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/m_e_CollinearMass")
            dyjetRJEREC1up = positivize(dyjetRJEREC1up)
            dyjetRJEREC1up = dyjetRJEREC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp", binning)
            dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/m_e_CollinearMass")
            dyjetRJEREC1down = positivize(dyjetRJEREC1down)
            dyjetRJEREC1down = dyjetRJEREC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown", binning)

            dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/m_e_CollinearMass")
            dyjetRJEREC2up = positivize(dyjetRJEREC2up)
            dyjetRJEREC2up = dyjetRJEREC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp", binning)
            dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/m_e_CollinearMass")
            dyjetRJEREC2down = positivize(dyjetRJEREC2down)
            dyjetRJEREC2down = dyjetRJEREC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown", binning)

            dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/m_e_CollinearMass")
            dyjetRJERHFup = positivize(dyjetRJERHFup)
            dyjetRJERHFup = dyjetRJERHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp", binning)
            dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/m_e_CollinearMass")
            dyjetRJERHFdown = positivize(dyjetRJERHFdown)
            dyjetRJERHFdown = dyjetRJERHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown", binning)

            dyjetRPBBup = DY.Get("JetRelativePtBBUp/m_e_CollinearMass")
            dyjetRPBBup = positivize(dyjetRPBBup)
            dyjetRPBBup = dyjetRPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp", binning)
            dyjetRPBBdown = DY.Get("JetRelativePtBBDown/m_e_CollinearMass")
            dyjetRPBBdown = positivize(dyjetRPBBdown)
            dyjetRPBBdown = dyjetRPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown", binning)

            dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/m_e_CollinearMass")
            dyjetRPEC1up = positivize(dyjetRPEC1up)
            dyjetRPEC1up = dyjetRPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp", binning)
            dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/m_e_CollinearMass")
            dyjetRPEC1down = positivize(dyjetRPEC1down)
            dyjetRPEC1down = dyjetRPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown", binning)

            dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/m_e_CollinearMass")
            dyjetRPEC2up = positivize(dyjetRPEC2up)
            dyjetRPEC2up = dyjetRPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp", binning)
            dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/m_e_CollinearMass")
            dyjetRPEC2down = positivize(dyjetRPEC2down)
            dyjetRPEC2down = dyjetRPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown", binning)

            dyjetRPHFup = DY.Get("JetRelativePtHFUp/m_e_CollinearMass")
            dyjetRPHFup = positivize(dyjetRPHFup)
            dyjetRPHFup = dyjetRPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp", binning)
            dyjetRPHFdown = DY.Get("JetRelativePtHFDown/m_e_CollinearMass")
            dyjetRPHFdown = positivize(dyjetRPHFdown)
            dyjetRPHFdown = dyjetRPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown", binning)

            dyjetRSECup = DY.Get("JetRelativeStatECUp/m_e_CollinearMass")
            dyjetRSECup = positivize(dyjetRSECup)
            dyjetRSECup = dyjetRSECup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp", binning)
            dyjetRSECdown = DY.Get("JetRelativeStatECDown/m_e_CollinearMass")
            dyjetRSECdown = positivize(dyjetRSECdown)
            dyjetRSECdown = dyjetRSECdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown", binning)

            dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/m_e_CollinearMass")
            dyjetRSFSRup = positivize(dyjetRSFSRup)
            dyjetRSFSRup = dyjetRSFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp", binning)
            dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/m_e_CollinearMass")
            dyjetRSFSRdown = positivize(dyjetRSFSRdown)
            dyjetRSFSRdown = dyjetRSFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown", binning)

            dyjetRSHFup = DY.Get("JetRelativeStatHFUp/m_e_CollinearMass")
            dyjetRSHFup = positivize(dyjetRSHFup)
            dyjetRSHFup = dyjetRSHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp", binning)
            dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/m_e_CollinearMass")
            dyjetRSHFdown = positivize(dyjetRSHFdown)
            dyjetRSHFdown = dyjetRSHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown", binning)

            dyjetSPEup = DY.Get("JetSinglePionECALUp/m_e_CollinearMass")
            dyjetSPEup = positivize(dyjetSPEup)
            dyjetSPEup = dyjetSPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp", binning)
            dyjetSPEdown = DY.Get("JetSinglePionECALDown/m_e_CollinearMass")
            dyjetSPEdown = positivize(dyjetSPEdown)
            dyjetSPEdown = dyjetSPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown", binning)

            dyjetSPHup = DY.Get("JetSinglePionHCALUp/m_e_CollinearMass")
            dyjetSPHup = positivize(dyjetSPHup)
            dyjetSPHup = dyjetSPHup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp", binning)
            dyjetSPHdown = DY.Get("JetSinglePionHCALDown/m_e_CollinearMass")
            dyjetSPHdown = positivize(dyjetSPHdown)
            dyjetSPHdown = dyjetSPHdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown", binning)

            dyjetTPEup = DY.Get("JetTimePtEtaUp/m_e_CollinearMass")
            dyjetTPEup = positivize(dyjetTPEup)
            dyjetTPEup = dyjetTPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp", binning)
            dyjetTPEdown = DY.Get("JetTimePtEtaDown/m_e_CollinearMass")
            dyjetTPEdown = positivize(dyjetTPEdown)
            dyjetTPEdown = dyjetTPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown", binning)

            dyjetRBup = DY.Get("JetRelativeBalUp/m_e_CollinearMass")
            dyjetRBup = positivize(dyjetRBup)
            dyjetRBup = dyjetRBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp", binning)
            dyjetRBdown = DY.Get("JetRelativeBalDown/m_e_CollinearMass")
            dyjetRBdown = positivize(dyjetRBdown)
            dyjetRBdown = dyjetRBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown", binning)

            dyjetRSup = DY.Get("JetRelativeSampleUp/m_e_CollinearMass")
            dyjetRSup = positivize(dyjetRSup)
            dyjetRSup = dyjetRSup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp", binning)
            dyjetRSdown = DY.Get("JetRelativeSampleDown/m_e_CollinearMass")
            dyjetRSdown = positivize(dyjetRSdown)
            dyjetRSdown = dyjetRSdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown", binning)

        if i==1:
            data.Delete()
            qcd.Delete()
            qcdr0up.Delete()
            qcdr0down.Delete()
            qcdr1up.Delete()
            qcdr1down.Delete()
            qcds0up.Delete()
            qcds0down.Delete()
            qcds1up.Delete()
            qcds1down.Delete()
            qcdiup.Delete()
            qcdidown.Delete()
            emb.Delete()
            embeescup.Delete()
            embeescdown.Delete()
            #embeesiup.Delete()
            #embeesidown.Delete()
        f.Write()
        dy.Delete()
        dypuup.Delete()
        dypudown.Delete()
        dypfup.Delete()
        dypfdown.Delete()
        dytrup.Delete()
        dytrdown.Delete()
        if b[i]=='Zothers' or  b[i]=='W' or b[i]=='EWK' or b[i]=='ggH_htt' or b[i]=='qqH_htt' or b[i]=='ggH_hww' or b[i]=='qqH_hww' or b[i]=='LFVGG125' or b[i]=='LFVVBF125':
            dyrecrespup.Delete()
            dyrecrespdown.Delete()
            dyrecresoup.Delete()
            dyrecresodown.Delete()
        if b[i]=='Zothers':
            dyptup.Delete()
            dyptdown.Delete()
        if b[i]=='TT':
            dyttptup.Delete()
            dyttptdown.Delete()
        dybtagup.Delete()
        dybtagdown.Delete()
        dyeescup.Delete()
        dyeescdown.Delete()
        #dyeesiup.Delete()
        #dyeesidown.Delete()
        dymesup.Delete()
        dymesdown.Delete()
        if b[i]=='WG' or b[i]=='vH_htt' or b[i]=='TT' or b[i]=='T' or b[i]=='Diboson':
            dyuesup.Delete()
            dyuesdown.Delete()
            dyjetAFMup.Delete()
            dyjetAFMdown.Delete()
            dyjetAMPFBup.Delete()
            dyjetAMPFBdown.Delete()
            dyjetASup.Delete()
            dyjetASdown.Delete()
            dyjetAStup.Delete()
            dyjetAStdown.Delete()
            dyjetFQCDup.Delete()
            dyjetFQCDdown.Delete()
            dyjetFup.Delete()
            dyjetFdown.Delete()
            dyjetPUDMCup.Delete()
            dyjetPUDMCdown.Delete()
            dyjetPUPBBup.Delete()
            dyjetPUPBBdown.Delete()
            dyjetPUPEC1up.Delete()
            dyjetPUPEC1down.Delete()
            dyjetPUPEC2up.Delete()
            dyjetPUPEC2down.Delete()
            dyjetPUPHFup.Delete()
            dyjetPUPHFdown.Delete()
            dyjetPUPRup.Delete()
            dyjetPUPRdown.Delete()
            dyjetRFSRup.Delete()
            dyjetRFSRdown.Delete()
            dyjetRJEREC1up.Delete()
            dyjetRJEREC1down.Delete()
            dyjetRJEREC2up.Delete()
            dyjetRJEREC2down.Delete()
            dyjetRJERHFup.Delete()
            dyjetRJERHFdown.Delete()
            dyjetRPBBup.Delete()
            dyjetRPBBdown.Delete()
            dyjetRPEC1up.Delete()
            dyjetRPEC1down.Delete()
            dyjetRPEC2up.Delete()
            dyjetRPEC2down.Delete()
            dyjetRPHFup.Delete()
            dyjetRPHFdown.Delete()
            dyjetRSECup.Delete()
            dyjetRSECdown.Delete()
            dyjetRSFSRup.Delete()
            dyjetRSFSRdown.Delete()
            dyjetRSHFup.Delete()
            dyjetRSHFdown.Delete()
            dyjetSPEup.Delete()
            dyjetSPEdown.Delete()
            dyjetSPHup.Delete()
            dyjetSPHdown.Delete()
            dyjetTPEup.Delete()
            dyjetTPEdown.Delete()
            dyjetRBup.Delete()
            dyjetRBdown.Delete()
            dyjetRSup.Delete()
            dyjetRSdown.Delete()
