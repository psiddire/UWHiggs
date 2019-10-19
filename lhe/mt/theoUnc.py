import ROOT
import numpy as np
import math

#name = "GluGluHToTauTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_new_pmx_94X_mc2017_realistic_v14-v2.root"
#name = "GluGluHToWWTo2L2Nu_M125_13TeV_powheg2_JHUGenV714_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
#name = "GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
#name = "VBFHToTauTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_new_pmx_94X_mc2017_realistic_v14-v1.root"
#name = "VBFHToWWTo2L2Nu_M125_13TeV_powheg2_JHUGenV714_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
name = "VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"

f = ROOT.TFile("results/MCLHE/AnalyzeMuTau/"+name)
Interval = False

names = ['TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF']

inc_histo = f.Get('TightOS/lhe0/m_t_CollinearMass')
inc_int = inc_histo.Integral()

for di in names:

    FlagMin = False
    FlagMax = False

    acc_unc = []
    nom_histo = f.Get(di+'/lhe0/m_t_CollinearMass')
    nom_int = nom_histo.Integral()
    acc = nom_int/inc_int
    for i in range(1, 9):
        var_histo = f.Get(di+'/lhe'+str(i)+'/m_t_CollinearMass')
        var_int = var_histo.Integral()
        inc_var_histo = f.Get('TightOS/lhe'+str(i)+'/m_t_CollinearMass')
        inc_var_int = inc_var_histo.Integral()
        acc_scale = var_int/inc_var_int
        acc_unc.append(acc_scale)

    print "Acceptance Scale Uncertainty: ", di, min(acc_unc), max(acc_unc), (max(acc_unc)-min(acc_unc))/(2*acc) 

    acc_unc = []
    nom_histo = f.Get(di+'/lhe9/m_t_CollinearMass')
    nom_int = nom_histo.Integral()
    acc = nom_int/inc_int
    for i in range(10, 120):
        var_histo = f.Get(di+'/lhe'+str(i)+'/m_t_CollinearMass')
        var_int = var_histo.Integral()
        inc_var_histo = f.Get('TightOS/lhe'+str(i)+'/m_t_CollinearMass')
        inc_var_int = inc_var_histo.Integral()
        acc_pdf = var_int/inc_var_int
        acc_unc.append(acc_pdf)

    lower = []
    higher = []

    for au in acc_unc:
        if (au - acc) > 0:
            higher.append(au)
        else:
            lower.append(au)

    if len(higher)!=0: maxhigh = max(higher)
    if len(lower)!=0: minlow = min(lower)

    sum = 0
    for n in range(len(higher)):
        sum = sum + (higher[n]-acc)*(higher[n]-acc)
    acc_pdf_up = math.sqrt(sum/len(higher))

    sum = 0
    for n in range(len(lower)):
        sum = sum + (lower[n]-acc)*(lower[n]-acc)
    acc_pdf_down = math.sqrt(sum/len(lower))

    print "PDF Uncertainty: ", di, acc_pdf_up, acc_pdf_down, acc_pdf_up/1.645, acc_pdf_down/1.645
