import ROOT
import os

jobid = "2013-07-17-8TeV-v1-ZH_light"

data_lumi = 19500.0
#wz_lumi = 1690320.0
wz_lumi = 760148.520414


for channel, label in [("MMTT", "t1_t2_Mass"), ("EETT", "t1_t2_Mass"), ("MMMT", "m3_t_Mass"),
	("EEMT", "m_t_Mass"), ("MMET", "e_t_Mass"), ("EEET", "e3_t_Mass")]:


#for channel, label in [("MMEM", "e_m3_Mass"),("EEEM", "e3_m_Mass")]:

#for channel, label in [("MMTT", "t1_t2_Mass"), ("EETT", "t1_t2_Mass"), ("MMMT", "m3_t_Mass"),
#	("EEMT", "m_t_Mass"), ("EEET", "e3_t_Mass"), 
#	("EEEM", "e3_m_Mass")]:

#for channel, label in [("MMTT", "t1_t2_SVfitMass"), ("EETT", "t1_t2_SVfitMass"), ('EEET', 'e3_t_SVfitMass'), 
#        ('MMMT', 'm3_t_SVfitMass'), ('EEMT', 'm_t_SVfitMass')]:
    print "running on channel %s" % channel   
    data_file = ROOT.TFile("results/%s/ZHAnalyze%s/data.root" % (jobid, channel), "READ")
    wz_file = ROOT.TFile("results/%s/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % (jobid, channel), "READ")

    # data same sign, background categories 0,1,2 and WZ with 4th leg real
    data_ss = data_file.Get("ss/All_Passed/%s" % label)

    data_0 = data_file.Get("os/Leg3Failed_Leg4Failed/all_weights_applied/%s" % label)

    data_1 = data_file.Get("os/Leg3Failed/leg3_weight/%s" % label)

    data_2 = data_file.Get("os/Leg4Failed/leg4_weight/%s" % label)
  
    wz_4R = wz_file.Get("os/All_Passed_Leg4Real/%s" % label)
    print "os/All_Passed_Leg4Real/%s" % label
    #scale to 19.5 fb^-1
    wz_4R.Scale(data_lumi/wz_lumi)

    # plot dilepton visible mass
    canvas = ROOT.TCanvas("canvas", "canvas")
    pad = ROOT.gPad.func()

    # 1+2-0
    fr_m1 = ROOT.TH1F(data_1)
    fr_m1.Add(data_2)
    fr_m1.Add(data_0, -1)

    # 2 + WZ-4R
    fr_m2 = ROOT.TH1F(data_2) # should be data_2
    fr_m2.Add(wz_4R)

    # rebin histograms
    data_ss.Rebin(20)
    fr_m1.Rebin(20)
    fr_m2.Rebin(20)

    data_ss.SetMarkerColor(1)
    fr_m1.SetMarkerColor(2)
    fr_m1.SetLineColor(2)
    fr_m2.SetMarkerColor(38)
    fr_m2.SetLineColor(38)

    fr_m1.GetXaxis().SetTitle(" \\tau\\tau SVMass (GeV), %s" % channel)

    #fr_m2.Draw()
    #data_ss.Draw("same")
    #fr_m2.Draw("same")
    fr_m1.Draw()
    fr_m2.Draw("same")
    #data_ss.Draw("same")

    l5 = ROOT.TLegend(0.7,0.80,0.85,0.65,"")
    #l5.AddEntry(data_ss,"data_ss")
    l5.AddEntry(fr_m1, "2 + 1 - 0")
    l5.AddEntry(fr_m2, "2 + WZ-4R")
    l5.SetBorderSize(0);
    l5.SetFillColor(0);
    l5.Draw();

    l = ROOT.TLatex()
    l.SetTextAlign(12) # left-middle
    l.SetNDC()
    left_margin = pad.GetLeftMargin()
    top_margin = pad.GetTopMargin()
    ypos = 1 - top_margin / 2.
    # The text is 90% as tall as the margin it lives in.
    l.SetTextSize(0.90 * top_margin)
    text = "Preliminary 2012"
    l.DrawLatex(left_margin, ypos, "CMS " + text)

    sqrts = 8
    p = ROOT.TLatex()
    p.SetTextAlign(32) # right-middle
    p.SetNDC()
    p.SetTextSize(0.90 * top_margin)
    right_margin = pad.GetRightMargin()
    p.DrawLatex(1 - right_margin, ypos, "#sqrt{s}=%iTeV" % sqrts)
 
    canvas.SaveAs("frmass_plots/frmass_%s.png" % channel)
    pad.Close()

