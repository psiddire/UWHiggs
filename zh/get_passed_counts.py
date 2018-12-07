#!/usr/bin/python
import ROOT
import math 

 
def print_table(channel, weighted=True):
# print a tex table for a given channel
    data = ROOT.TFile("results/2013-06-29-8TeV-v1-ZH_light/ZHAnalyze%s/data.root" % channel, "READ")
    zz = ROOT.TFile("results/2013-06-29-8TeV-v1-ZH_light/ZHAnalyze%s/ZZJetsTo4L_pythia.root" % channel, "READ")
    zjets = ROOT.TFile("results/2013-06-29-8TeV-v1-ZH_light/ZHAnalyze%s/Zjets_M50.root" % channel, "READ")
    wz = ROOT.TFile("results/2013-06-29-8TeV-v1-ZH_light/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % channel, "READ")
    data_lumi = 19.2
    zz_lumi = 10524.856
    zjets_lumi = 7.955 
    wz_lumi = 1690.319
    column_values = []
    background_estimates = [] 
    errors = []
    for my_file, folder, weight_folder, lumi_weight in [(zz,'All_Passed','', data_lumi/zz_lumi), (data,'Leg3Failed_Leg4Failed', 'all_weights_applied', 1.0), (data,'Leg3Failed','leg3_weight', 1.0), (data, 'Leg4Failed', 'leg4_weight', 1.0), (zjets,'All_Passed','', data_lumi/zjets_lumi), (wz,'All_Passed','', data_lumi/wz_lumi), (data, 'All_Passed', '', 1.0)]:
        path_to_histo = 'os/' + folder
        histo_unweighted = my_file.Get(path_to_histo + '/kinematicDiscriminant1')
        if weighted:
            path_to_histo += '/' + weight_folder
        # we can get any existing histo here, we just need the integral
        #print "path to histo = " + path_to_histo 
        histo = my_file.Get(path_to_histo + '/kinematicDiscriminant1')
        #print path_to_histo
        histo.Scale(lumi_weight)
        if weight_folder:
            #s = str(round(histo.Integral(),3)) + ' (' + str(round(histo_unweighted.Integral(),3)) + ')'
            #errors.append(1/math.sqrt(histo_unweighted.Integral()))
            s = str(round(histo.Integral(),3))# + ' $\\pm$ ' + str(round(1/math.sqrt(histo_unweighted.Integral()),3))
            background_estimates.append(str(round(histo.Integral(),3)))
            column_values.append(s)
        else: column_values.append(str(round(histo.Integral(),3)))
        #print str(histo.Integral())
        # now print them out, TeX style
        #line = " & ".join(str(column_values)) + "\\\\"
    #return line;
    line = channel 
    line += ' & ' + column_values[0] # ZZ
        
    # estimate background contribution
    fr_contribution = float(background_estimates[1]) + float(background_estimates[2]) - float(background_estimates[0])
    #fr_contribution_error = round(math.sqrt(errors[0]**2 + errors[1]**2 + errors[2]**2 ),3)
    line += ' & ' + str(fr_contribution) #+ ' $\\pm$ ' + str(fr_contribution_error) # fakerate

    #line += ' & ' + str(float(background_estimates[2]) + float(column_values[4]))
    line += ' & ' + column_values[4] # Zjets
    line += ' & ' + column_values[5] # WZ

    line += ' & ' + str(float(column_values[0]) + fr_contribution) # ZZ + fakerate
    line += ' & ' + column_values[6] # observed data

    return line
print '''
\documentclass[final,letterpaper,twoside,12pt]{article}
\usepackage{chngpage}
\usepackage{tabularx}
\\begin{document}
\\begin{table}[htbp]
\\begin{adjustwidth}{-4em}{-4em}
\centering
\\begin{tabular}{|c|c|c|c|c|c|c|} \\hline
channel & ZZ & fakerate & Zjets & WZ & ZZ + fr & data \\\\ 
\\hline \\hline '''

print print_table('MMTT') + '  \\\\ \\hline'
print print_table('EETT') + '  \\\\ \\hline'
print print_table('EEET') + '  \\\\ \\hline'
print print_table('MMET') + '  \\\\ \\hline'
print print_table('MMMT') + '  \\\\ \\hline'
print print_table('EEMT') + '  \\\\ \\hline'
print print_table('EEEM') + '  \\\\ \\hline'
print print_table('MMEM') + '  \\\\ \\hline'
print print_table('COMB') + '  \\\\ \\hline'

print '''
\end{tabular}
\caption {Observed 2012 data vs. background estimations }
\label{tab:cqdata0}
\end{adjustwidth}\end{table}

\end{document}
'''
