import ROOT
import Kinematics
import numpy as np

#name = "GluGluHToTauTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_new_pmx_94X_mc2017_realistic_v14-v2.root"
#name = "GluGluHToWWTo2L2Nu_M125_13TeV_powheg2_JHUGenV714_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
name = "GluGlu_LFV_HToETau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
#name = "VBFHToTauTau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_new_pmx_94X_mc2017_realistic_v14-v1.root"
#name = "VBFHToWWTo2L2Nu_M125_13TeV_powheg2_JHUGenV714_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"
#name = "VBF_LFV_HToETau_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root"

f = ROOT.TFile("results/MCLHE/AnalyzeETau/"+name)
Interval = False

for di in Kinematics.names:

    FlagMin = False
    FlagMax = False

    scale_unc = []
    acc_unc = []
    nom_histo = f.Get(di+'/lhe0/e_t_VisibleMass')
    nom_int = nom_histo.Integral()
    nom_gen_histo = f.Get(di+'/lhe0/e_t_GenVisibleMass')
    nom_gen_int = nom_gen_histo.Integral()
    acc = nom_int/nom_gen_int
    for i in range(1, 9):
        var_histo = f.Get(di+'/lhe'+str(i)+'/e_t_VisibleMass')
        var_int = var_histo.Integral()
        var_gen_histo = f.Get(di+'/lhe'+str(i)+'/e_t_GenVisibleMass')
        var_gen_int = var_gen_histo.Integral()
        acc_scale = var_int/var_gen_int
        scale_unc.append((var_int - nom_int)/nom_int)
        acc_unc.append((acc_scale - acc)/acc)

    print "Scale Uncertainty: ", di, min(scale_unc), max(scale_unc), (max(scale_unc)-min(scale_unc))/2
    print "Acceptance Uncertainty: ", di, min(acc_unc), max(acc_unc), (max(acc_unc)-min(acc_unc))/2

    pdf_unc = []
    pdf_int = []
    acc_unc = []
    nom_histo = f.Get(di+'/lhe9/e_t_VisibleMass')
    nom_int = nom_histo.Integral()
    nom_gen_histo = f.Get(di+'/lhe9/e_t_GenVisibleMass')
    nom_gen_int = nom_gen_histo.Integral()
    acc = nom_int/nom_gen_int
    for i in range(10, 120):
        var_histo = f.Get(di+'/lhe'+str(i)+'/e_t_VisibleMass')
        var_int = var_histo.Integral()
        var_gen_histo = f.Get(di+'/lhe'+str(i)+'/e_t_GenVisibleMass')
        var_gen_int = var_gen_histo.Integral()
        acc_pdf = var_int/var_gen_int
        pdf_int.append(var_int)
        pdf_unc.append((var_int - nom_int)/nom_int)
        acc_unc.append((acc_pdf - acc)/acc)

    print "PDF Uncertainty: ", di, min(pdf_unc), max(pdf_unc)
    print "Acceptance Uncertainty: ", di, min(acc_unc), max(acc_unc)

    lower = []
    higher = []

    average = np.mean(pdf_int)

    for pi in pdf_int:
        if (pi - average) > 0:
            higher.append(pi)
        else:
            lower.append(pi)

    if len(higher)!=0: maxhigh = max(higher)
    if len(lower)!=0: minlow = min(lower)

    if Interval==True:

        for n in range (1, 20):
            if not FlagMin:
                diff = abs(minlow - average)
                thr = minlow + n * diff / 10.
                if len(lower)==0: break
                count = len([x for x in lower if x > thr])
                if count < 0.68 * (len(lower) + 1):
                    print 'min unc : %.3f' %(100 * 0.5 * (minlow + ((n-1) * diff / 10. - n * diff / 10.) - average) / average)
                    FlagMin = True

        for n in range (1, 20):
            if not FlagMax:
                diff = abs(maxhigh - average)
                thr = maxhigh - n * diff / 10.
                if len(higher)==0: break
                count = len([x for x in higher if x < thr])
                if count < 0.68 * (len(higher) + 1):
                    print 'max unc : %.3f' %(100 * 0.5 * (maxhigh - (n * diff / 10. - (n - 1) * diff / 10.) - average) / average)
                    FlagMax = True
