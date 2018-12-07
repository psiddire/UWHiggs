#!/usr/bin/python
import ROOT
import math 

 
def print_table(channel, weighted=True):
# print a tex table for a given channel
    data = ROOT.TFile("results/2013-07-17-8TeV-v1-ZH_light/ZHAnalyze%s/data.root" % channel, "READ")
    zz = ROOT.TFile("results/2013-07-17-8TeV-v1-ZH_light/ZHAnalyze%s/ZZJetsTo4L_pythia.root" % channel, "READ")
    zjets = ROOT.TFile("results/2013-07-17-8TeV-v1-ZH_light/ZHAnalyze%s/Zjets_M50.root" % channel, "READ")
    wz = ROOT.TFile("results/2013-07-17-8TeV-v1-ZH_light/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % channel, "READ")
    #data_lumi = 19.2
    data_lumi = 33.6/2
    zz_lumi = 64.332
    #zjets_lumi = 25866.364
    zjets_lumi = 6.5 
    #wz_lumi = 1690.320
    wz_lumi = 760.148
    column_values = []
    background_estimates = [] 
    errors = []

    for my_file, folder, weight_folder, lumi_weight in [(data, 'ss/All_Passed', '', 1.0), (data,'ss/Leg3Failed_Leg4Failed', 'all_weights_applied', 1.0), (data,'ss/Leg3Failed','leg3_weight', 1.0), (data, 'ss/Leg4Failed', 'leg4_weight', 1.0), (wz,'ss/All_Passed_Leg4Real','', data_lumi/wz_lumi), (wz,'ss/All_Passed_Leg3Real','',data_lumi/wz_lumi)]:

        path_to_histo =  folder
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
            errors.append(1/math.sqrt(histo_unweighted.Integral()))
            s = str(round(histo.Integral(),2))# + ' $\\pm$ ' + str(round(1/math.sqrt(histo_unweighted.Integral()),3))
            background_estimates.append(str(round(histo.Integral(),2)))
            column_values.append(s)
        else: column_values.append(str(round(histo.Integral(),2)))
        #print str(histo.Integral())
        # now print them out, TeX style
        #line = " & ".join(str(column_values)) + "\\\\"
    #return line;
    line = channel 
    
    # passed same-sign data
    #line += ' & ' + column_values[0]    
    # estimate background contribution
    line += ' & ' + background_estimates[1] + '$\\pm$ ' + str(round(errors[1]*float(background_estimates[1]),2)) # PPFP
    line += ' & ' + background_estimates[2] + '$\\pm$ ' + str(round(errors[2]*float(background_estimates[2]),2)) # PPPF
    line += ' & ' + background_estimates[0] + '$\\pm$ ' + str(round(errors[0]*float(background_estimates[0]),2)) # PPFF

    fr_contribution = float(background_estimates[1]) + float(background_estimates[2]) - float(background_estimates[0])
    fr_contribution_error = round(fr_contribution * math.sqrt(errors[0]**2 + errors[1]**2 + errors[2]**2 ),2)
    line += ' & ' + str(fr_contribution) + ' $\\pm$ ' + str(fr_contribution_error) # '2+1-0' w/ error

    line += ' & ' + column_values[4] + ' $\\pm$ ' + str(float(column_values[4])*0.2) # WZ-4R
    #if (channel == "MMEM" or channel == "EEEM"):
    alt_yield = float(background_estimates[2]) + float(column_values[4])
    line += ' & ' + str(alt_yield) + ' $\\pm$ ' + str(round(alt_yield*errors[2],2)) #alt method

    #most_wz = str(float(column_values[5]) - float(column_values[4]))
    most_wz = column_values[5]  # WZ where fourth leg is not real
    line += ' & ' + most_wz + ' $\\pm$ ' + str(float(column_values[5])*0.2) 
    alt_alt_yield = float(most_wz) + float(background_estimates[1])
    line += ' & ' + str(alt_alt_yield) + '$\\pm$ ' + str(round(math.sqrt(errors[1]**2 + 0.2**2)*alt_alt_yield,2)) # alt alt method

    #line += ' & ' + column_values[6]
    #line += ' & ' + column_values[5] # WZ

    #line += ' & ' + str(float(column_values[0]) + fr_contribution) # ZZ + fakerate
    line += ' & ' + column_values[0] # observed data

    return line
print '''
%\documentclass[final,letterpaper,twoside,12pt]{article}
\documentclass[8pt]{extarticle}
\usepackage{chngpage}
\usepackage{tabularx}
\\begin{document}
\\begin{table}[htbp]
\\begin{adjustwidth}{-4cm}{}
\centering
\\begin{tabular}{|c|c|c|c|c|c|c|c|c|c|} \\hline
channel & PPFP & PPPF & PPFF & 1+2-0 & WZ-4Real & PPPF+WZ-4Real & WZ-3Real & PPFP+WZ-3Real & data ss\\\\ 
\\hline \\hline '''

print print_table('MMTT') + '  \\\\ \\hline'
print print_table('EETT') + '  \\\\ \\hline'
print print_table('EEET') + '  \\\\ \\hline'
print print_table('MMET') + '  \\\\ \\hline'
print print_table('MMMT') + '  \\\\ \\hline'
print print_table('EEMT') + '  \\\\ \\hline'
print print_table('EEEM') + '  \\\\ \\hline'
print print_table('MMEM') + '  \\\\ \\hline'
#print print_table('COMB') + '  \\\\ \\hline'

print '''
\end{tabular}
\caption {Channel by channel comparison of the '2+1-0' and 2+WZ-4R reducible background estimation methods}
\label{tab:cqdata0}
\end{adjustwidth}\end{table}

\end{document}
'''
