import ROOT
import os

jobid = "2013-07-17-8TeV-v1-ZH_light"

data_lumi = 19500.0
#data_lumi = 27
#wz_lumi = 1690320.0
wz_lumi = 760148.520414

data_file = ROOT.TFile("results/%s/ZHAnalyzeCOMB/data.root" % jobid, "READ")
wz_file = ROOT.TFile("results/%s/ZHAnalyzeCOMB/WZJetsTo3LNu_pythia.root" % jobid, "READ")

# data same sign, background categories 0,1,2 and WZ with 4th leg real
data_ss = ROOT.TH1F("data", "data", 200, 0, 200)
data_0 = ROOT.TH1F("data_0", "data_0", 200, 0, 200)
data_1 = ROOT.TH1F("data_1", "data_1", 200, 0, 200)
data_2 = ROOT.TH1F("data_2", "data_2", 200, 0, 200)
wz_4R = ROOT.TH1F("wz", "wz", 200, 0, 200)
data_2s = ROOT.TH1F("wz", "wz", 200, 0, 200) # just because in xxEM channels we want e to fail, which is technically the third leg

for channel, label, realLeg in [("MMTT", "t1_t2_SVfitMass",4), ("MMMT", "m3_t_SVfitMass",4),
	("EEMT", "m_t_SVfitMass",4), ("MMET", "e_t_SVfitMass",4), ("EEET", "e3_t_SVfitMass",4),
        ("EEEM", "e3_m_SVfitMass",3), ("MMEM", "e_m3_SVfitMass",3)]:
#for channel, label in [("MMTT", "t1_t2_SVfitMass"), ("MMMT", "m3_t_SVfitMass"),
#       ("EEMT", "m_t_SVfitMass"), ("EEET", "e3_t_SVfitMass")]:


    print "ss/All_Passed/%s" % label
    data_ss_m = data_file.Get("ss/All_Passed/%s" % label)
    data_ss.Add(data_ss_m)

    data_0_m = data_file.Get("os/Leg3Failed_Leg4Failed/all_weights_applied/%s" % label)
    data_0.Add(data_0_m)

    data_1_m = data_file.Get("os/Leg3Failed/leg3_weight/%s" % label)
    data_1.Add(data_1_m)

    data_2s_m = data_file.Get("os/Leg%dFailed/leg%d_weight/%s" % (realLeg, realLeg, label))
    data_2s.Add(data_2s_m)

    data_2_m = data_file.Get("os/Leg4Failed/leg4_weight/%s" % label)
    data_2.Add(data_2_m)
  
    wz_m = wz_file.Get("os/All_Passed_Leg%dReal/%s" % (realLeg, label))
    wz_4R.Add(wz_m)

# scale to 19.5 fb^-1


wz_4R.Scale(data_lumi/wz_lumi)

canvas = ROOT.TCanvas("canvas", "canvas")
pad = ROOT.gPad.func()

#reducible_background = ROOT.TH1F(wz)
#reducible_background.Add(zjets)

#reducible_background.SetLineColor(ROOT.kBlue)


# 1+2-0
fr_m1 = ROOT.TH1F(data_1)
fr_m1.Add(data_2)
fr_m1.Add(data_0, -1)

# 2 + WZ-4R
fr_m2 = ROOT.TH1F(data_2s) # used to be just data_2
fr_m2.Add(wz_4R)

data_ss.Rebin(20)
fr_m1.Rebin(20)
fr_m2.Rebin(20)

data_ss.SetMarkerColor(1)
fr_m1.SetMarkerColor(2)
fr_m1.SetLineColor(2)
fr_m2.SetMarkerColor(38)
fr_m2.SetLineColor(38)

fr_m1.GetXaxis().SetTitle(" \\tau\\tau SVMass (GeV)")

fr_m1.Draw()
fr_m2.Draw("same")
#data_ss.Draw("same")
#fr_m2.Draw("same")
#fr_m1.Draw("same")

l5 = ROOT.TLegend(0.65,0.95,0.90,0.70,"")
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
 
canvas.SaveAs("frmass_plots/Validation_AltMethod.png")

os.system("sleep 10")
pad.Close()
