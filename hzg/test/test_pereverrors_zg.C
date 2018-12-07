void test_pereverrors_zg() {

  gSystem->Load("libRooFitCore.so");

  RooWorkspace test("test");

  test.factory("Mzg[90,150]");
  test.factory("Mz[60,120]");
  test.factory("dMzg[0,25]");
  test.factory("dMz[0,25]");
  test.factory("r94cat[cat1=1,cat2=2,cat3=3,cat4=4]");
  test.defineSet("observables","Mzg,Mz,dMzg,dMz,r94cat");

  char channel[] = "muon_cat4";
  char subscriptzg[] = "#mu#mu#gamma";
  char subscriptz[] = "#mu#mu";
  char fName[] = "make_ntuples_cfg-patTuple_cfg-12C90682-72FA-E111-8A74-00266CFF0AF4_ABCD_muon_processed.root";

  TFile* f = TFile::Open(fName,"READ");
  TTree* tree = (TTree*)f->Get("selected_zg");
  RooArgSet* obs = test.set("observables");

  std::cout << f << ' ' << tree << std::endl;

  RooDataSet d( "zgdata","M_{Z#gamma} with Errors",
		tree, *obs, "dMz/Mz < 1.0 && r94cat == 4" );

  test.import(d);
  
  test.factory("prod::SigmaZG(scal_zg[1,0.1,5],dMzg)");
  test.factory("RooCBShape::MzgShape(Mzg,m0zg[125,90,140],SigmaZG,alphazg[2,0.5,8],nzg[1,0.1,10])");
  //test.factory("RooBreitWigner::MzgTruthShape(Mzg,m0h[125.0],hwidth[0.1,3])");
  //test.factory("FCONV::MzgShape(Mzg,MzgTruthShape,MzgResoShape)");
  

  test.factory("prod::SigmaZ(scal_z[1,0.1,5],dMz)");
  test.factory("RooCBShape::MzResoShape(Mz,0,scal_z,alphaz[2,0.5,8],nz[1,0.1,10])");

  test.factory("expr::ZMassWithShift('m0z+mZshift',m0z[91.1876],mZshift[0,-5,5])");
  test.factory("RooBreitWigner::MzTruthShape(Mz,ZMassWithShift,zwidth[2.4952])");
  test.factory("FCONV::MzShape(Mz,MzTruthShape,MzResoShape)");

  test.pdf("MzgShape")->fitTo(*(test.data("zgdata")),
			      RooFit::ConditionalObservables(*(test.var("dMzg"))));

  test.pdf("MzShape")->fitTo(*(test.data("zgdata")),
			      RooFit::ConditionalObservables(*(test.var("dMz"))));

  TCanvas canv("test","test",600,600);

  RooPlot* frame = test.var("Mzg")->frame(90,150,300);
  frame->SetTitle("");
  frame->GetXaxis()->SetTitle(Form("M_{%s} (GeV)",subscriptzg));
  frame->GetYaxis()->SetTitle("Entries");
  test.data("zgdata")->plotOn(frame);
  test.pdf("MzgShape")->plotOn(frame,
			       RooFit::ProjWData(*(test.var("dMzg")),
						 *(test.data("zgdata"))));

  frame->Draw();
  canv.Print(Form("pereverr_test_zg_%s.pdf",channel));
  canv.SetLogy();
  canv.Print(Form("pereverr_test_zg_log_%s.pdf",channel));
  canv.Clear();

  delete frame;

  RooPlot* frame = test.var("Mz")->frame(60,120,300);
  frame->SetTitle("");
  frame->GetXaxis()->SetTitle(Form("M_{%s} (GeV)",subscriptz));
  frame->GetYaxis()->SetTitle("Entries");
  test.data("zgdata")->plotOn(frame);
  test.pdf("MzShape")->plotOn(frame,
			      RooFit::ProjWData(*(test.var("dMz")),
						*(test.data("zgdata"))));
  
  frame->Draw();
  canv.SetLogy(false);
  canv.Print(Form("pereverr_test_z_%s.pdf",channel));

  canv.SetLogy(true);
  canv.Print(Form("pereverr_test_z_log_%s.pdf",channel));
  canv.Clear();

  delete frame;

  frame = test.var("dMz")->frame(0,8,300);
  frame->SetTitle("");
  frame->GetXaxis()->SetTitle(Form("#sigma(M_{%s}) (GeV)",subscriptz));
  frame->GetYaxis()->SetTitle("Entries");
  test.data("zgdata")->plotOn(frame);
  
  frame->Draw();
  canv.SetLogy(true);
  canv.Print(Form("dMz_%s.pdf",channel));
  canv.Clear();

  delete frame;

  // try fitting the per-event error distributions

  
  test.factory("RooGaussModel::dMzgReso1(dMzg,dMzgMean1[1,0,5],dMzgSigma1[1,0.01,10])");
  test.factory("RooGaussModel::dMzgReso2(dMzg,dMzgMean2[2,0,5],dMzgSigma2[1,0.01,10])");
  test.factory("RooDecay::dMzgModel1(dMzg,dMzgTau1[1,0,10],dMzgReso1,RooDecay::SingleSided)");   
  test.factory("RooDecay::dMzgModel2(dMzg,dMzgTau2[1,0,10],dMzgReso2,RooDecay::SingleSided)");   
  test.factory("SUM::dMzgModel(fReso1[0.5,0,1]*dMzgModel1,dMzgModel2)");
   
  test.pdf("dMzgModel")->fitTo(*(test.data("zgdata")));

  frame = test.var("dMzg")->frame(0,8,300);
  frame->SetTitle("");
  frame->GetXaxis()->SetTitle(Form("#sigma(M_{%s}) (GeV)",subscriptzg));
  frame->GetYaxis()->SetTitle("Entries");
  test.data("zgdata")->plotOn(frame);
  test.pdf("dMzgModel")->plotOn(frame);
  
  frame->Draw();
  canv.SetLogy(false);
  canv.Print(Form("dMzg_%s.pdf",channel));
  canv.SetLogy(true);
  canv.Print(Form("dMzg_log_%s.pdf",channel));
  canv.Clear();

  delete frame;

  

}

