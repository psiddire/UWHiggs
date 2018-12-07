void kd_plot_combined()  {
  TFile *comb = TFile::Open("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/root_files/output-COMB.root"); 
  TH1F *kd1_zjets = comb->Get("kd1_zjets");
  TH1F *kd2_zjets = comb->Get("kd2_zjets");
  TH1F *kd1_wz = comb->Get("kd1_wz");
  TH1F *kd2_wz = comb->Get("kd2_wz");
  TH1F *kd1_signal = comb->Get("kd1_signal");
  TH1F *kd2_signal = comb->Get("kd2_signal");

  gStyle->SetOptStat(0);
  TCanvas *c1 = new TCanvas("c1","kd1");
  kd1_zjets->SetMarkerColor(2);
  kd1_zjets->SetMinimum(0.0);
  kd1_zjets->SetMaximum(2.0);
  kd1_wz->SetMarkerColor(4);
  kd1_zjets->Draw("hist, e");
  kd1_signal->Draw("hist,e,same");
  kd1_wz->Draw("hist,e,same");	
  TLegend *l1 = new TLegend(0.5,0.95,0.65,0.8,"");
  l1->AddEntry(kd1_zjets,"zjets","p");
  l1->AddEntry(kd1_wz,"wz","p");
  l1->AddEntry(kd1_signal, "VH_H2Tau(MH=125)", "p");
  l1->SetBorderSize(0);
  l1->SetFillColor(0);
  l1->Draw();
  c1->SaveAs("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/kd1_COMB.png");  

  TCanvas *c2 = new TCanvas("c2","kd2");
  kd2_zjets->SetMarkerColor(2);
  kd2_wz->SetMarkerColor(4);
  kd2_zjets->SetMinimum(0.0);
  kd2_zjets->SetMaximum(2.0);
  kd2_zjets->Draw("hist e");
  kd2_signal->Draw("hist same e");
  kd2_wz->Draw("hist same e");
  TLegend *l2 = new TLegend(0.5,0.95,0.65,0.8,"");
  l2->AddEntry(kd2_zjets,"zjets","p");
  l2->AddEntry(kd2_wz,"wz","p");
  l2->AddEntry(kd2_signal, "VH_H2Tau(MH=125)", "p");
  l2->SetBorderSize(0);
  l2->SetFillColor(0);
  l2->Draw();
  c2->SaveAs("results/2013-04-30-8TeV-v1-ZH_light/kd_plots/kd2_COMB.png");

}
