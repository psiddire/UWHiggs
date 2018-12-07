
/* AUTHOR: Stephane 
 Usage: kdplots(channel), where channel is the desired zh channel IN ALL CAPS. For example...
 kdplots("MMMT") will return normalized kinematic discriminator comparison plots for the MMMT channel.

 generates comparison plots (signal vs. WZ vs. Z+jets) for two kinematic discriminators, with each shape normalized. */

void kdplots(char* channel) {
  TFile *ofile = new TFile(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/root_files/output-%s.root",channel),"RECREATE");
  TFile *signal = TFile::Open(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/ZHAnalyze%s/VH_H2Tau_M-125.root",channel));
  TFile *wz = TFile::Open(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/ZHAnalyze%s/WZJetsTo3LNu_pythia.root",channel));
  TFile *zjets = TFile::Open(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/ZHAnalyze%s/Zjets_M50.root",channel));  

  TH1F *kd1_signal = signal->Get("os/All_Passed/kinematicDiscriminant1");
  kd1_signal->SetName("kd1_signal");
  TH1F *kd2_signal = signal->Get("os/All_Passed/kinematicDiscriminant2");
  kd2_signal->SetName("kd2_signal");
  //TH1F *kd1_zjets = zjets->Get("os/All_Passed/kinematicDiscriminant1");
  //TH1F *kd2_zjets = zjets->Get("os/All_Passed/kinematicDiscriminant2");
  TH1F *kd1_wz = wz->Get("os/All_Passed/kinematicDiscriminant1");
  kd1_wz->SetName("kd1_wz");
  TH1F *kd2_wz = wz->Get("os/All_Passed/kinematicDiscriminant2");
  kd2_wz->SetName("kd2_wz");
  
  // get Zjets statistics from the sideband region, weighted by fake rate
  TH1F *kd1_zjets_f3 = zjets->Get("os/Leg3Failed/leg3_weight/kinematicDiscriminant1");
  TH1F *kd1_zjets_f4 = zjets->Get("os/Leg4Failed/leg4_weight/kinematicDiscriminant1");
  TH1F *kd1_zjets_f3f4 = zjets->Get("os/Leg3Failed_Leg4Failed/all_weights_applied/kinematicDiscriminant1");

  TH1F *kd2_zjets_f3 = zjets->Get("os/Leg3Failed/leg3_weight/kinematicDiscriminant2");
  TH1F *kd2_zjets_f4 = zjets->Get("os/Leg4Failed/leg4_weight/kinematicDiscriminant2");
  TH1F *kd2_zjets_f3f4 = zjets->Get("os/Leg3Failed_Leg4Failed/all_weights_applied/kinematicDiscriminant2");

  TH1F *kd1_zjets = kd1_zjets_f3->Clone("kd1_zjets");
  kd1_zjets->Add(kd1_zjets_f4);
  kd1_zjets->Add(kd1_zjets_f3f4,-1);
  
  TH1F *kd2_zjets = kd2_zjets_f3->Clone("kd2_zjets");
  kd2_zjets->Add(kd2_zjets_f4);
  kd2_zjets->Add(kd2_zjets_f3f4,-1);

  // Normalize histograms
  kd1_signal = kd1_signal->Scale(1/kd1_signal->Integral());
  kd2_signal = kd2_signal->Scale(1/kd2_signal->Integral());
  kd1_zjets = kd1_zjets->Scale(1/kd1_zjets->Integral());
  kd2_zjets = kd2_zjets->Scale(1/kd2_zjets->Integral());
  kd1_wz = kd1_wz->Scale(1/kd1_wz->Integral());
  kd2_wz = kd2_wz->Scale(1/kd2_wz->Integral());
 
  // Plot normalized histograms
  
  gStyle->SetOptStat(0);
  TCanvas *c1 = new TCanvas("c1","kd1");
  kd1_zjets->SetMarkerColor(2);
  kd1_wz->SetMarkerColor(4);
  kd1_zjets->Draw("hist e");
  kd1_signal->Draw("hist same e");
  kd1_wz->Draw("hist same e");
  TLegend *l1 = new TLegend(0.5,0.95,0.65,0.8,"");
  l1->AddEntry(kd1_zjets,"zjets","p");
  l1->AddEntry(kd1_wz,"wz","p");
  l1->AddEntry(kd1_signal, "VH_H2Tau(MH=120)", "p");
  l1->SetBorderSize(0);
  l1->SetFillColor(0);
  l1->Draw();
  c1->SaveAs(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/kd1_%s.png",channel));

  TCanvas *c2 = new TCanvas("c2","kd2");
  kd2_zjets->SetMarkerColor(2);
  kd2_wz->SetMarkerColor(4);
  kd2_zjets->Draw("hist e");
  kd2_signal->Draw("hist same e");
  kd2_wz->Draw("hist same e");
  TLegend *l2 = new TLegend(0.5,0.95,0.65,0.8,"");
  l2->AddEntry(kd2_zjets,"zjets","p");
  l2->AddEntry(kd2_wz,"wz","p");
  l2->AddEntry(kd2_signal, "VH_H2Tau(MH=120)", "p");
  l2->SetBorderSize(0);
  l2->SetFillColor(0);
  l2->Draw();
  c2->SaveAs(TString::Format("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/kd2_%s.png",channel));

  ofile->cd();
  kd1_zjets->Write();
  kd2_zjets->Write();
  kd1_wz->Write();
  kd2_wz->Write();
  kd1_signal->Write();
  kd2_signal->Write();
  delete c1;
  delete c2;
  ofile->Write();
  ofile->Close();

}
