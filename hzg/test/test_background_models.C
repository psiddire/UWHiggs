void test_background_models() {

  gROOT->ProcessLine(".X CMSStyle.C");
  gSystem->Load("libRooFitCore.so");
  gSystem->Load("libUWHiggshzg.so");

  RooWorkspace test("test");
  
  test.addClassDeclImportDir("/home/lgray/CMSSW_5_3_3_patch3/src/UWHiggs/hzg/src");
  test.importClassCode(RooStepBernstein::Class(),true);

  char fName[] = "/home/lgray/HZG_analysis/10JAN2013_vanilla/electron/ZGToLLG-8TeV/ZGToLLG_8TeV-madgraph.Summer12_DR53X-PU_S10_START53_V7A-v1.AODSIM.root";
  char fName2[] = "/home/lgray/HZG_analysis/10JAN2013_vanilla/electron/DYJetsToLL_M-50_TuneZ2Star_8TeV-madgraph-tarball-8TeV/DYJetsToLL_M-50_TuneZ2Star_8TeV-madgraph-tarball.Summer12_DR53X-PU_S10_START53_V7A-v1.AODSIM.root";

  TFile* f = TFile::Open(fName,"READ");  
  TFile* f2 = TFile::Open(fName2,"READ");
  TFile* fout = TFile::Open("test_ws.root","recreate");
  TTree* tree = (TTree*)f->Get("selected_zg");
  TTree* tree2 = (TTree*)f2->Get("selected_zg");   

  test.factory("procWeight[0]");
  test.factory("puWeight[0]");
  test.factory("weight[0]");
  test.factory("Mzg[100,180]");
  test.factory("Mz[60,120]");
  test.factory("dMzg[0,25]");
  test.factory("dMz[0,25]");
  test.factory("r94cat[cat1=1,cat2=2,cat3=3,cat4=4]");
  test.defineSet("observables","Mzg,Mz,dMzg,dMz,r94cat,procWeight,puWeight");
  test.defineSet("observables_weight","Mzg,Mz,dMzg,dMz,r94cat,weight");

  RooArgSet* obs = test.set("observables");
  RooArgSet* wobs = test.set("observables_weight");

  int category = 3;

  char channel[] = Form("electron_cat%i",category);
  char subscriptzg[] = "ee#gamma";
  char subscriptz[] = "ee";
  

  RooDataSet dllg( "zgdata","M_{Z#gamma} with Errors",
		   tree, *obs);
  RooConstVar llgtot("llgtot","llgtot",6.58816100000000000e+06);
  RooFormulaVar weightllg("weight","weight","@0*@1/@2",RooArgList(*test.var("puWeight"),
								  *test.var("procWeight"),
								  llgtot));
  dllg.addColumn(weightllg);    
  
  RooDataSet dzjets( "zjdata","M_{Z Jets} with Errors",
		     tree2, *obs);
  RooConstVar zjetstot("zjetstot","zjetstot",3.04255770000000000e+07);
  RooFormulaVar weightzjets("weight","weight","@0*@1/@2",RooArgList(*test.var("puWeight"),
								    *test.var("procWeight"),
								    zjetstot));
  dzjets.addColumn(weightzjets);

  dllg.append(dzjets);

  RooDataSet d( "data","M_{Z Jets} with Errors", &dllg, *wobs,
		Form(" Mz + Mzg > 185 && r94cat == %i ",category) ,"weight" );

  RooDataSet dold( "data_old","M_{Z Jets} with Errors", &dllg, *wobs,
		Form(" r94cat == %i && Mzg > 115 && Mzg < 180",category) ,"weight" );

  test.import(d);
  test.import(dold,
	      RooFit::RenameVariable("Mzg","Mzg_old"));
  test.var("Mzg_old")->setMin(115);
  test.var("Mzg_old")->setMax(180);
  
  test.factory("RooGaussModel::MzgResoShape(Mzg,bias[120,90,150],sigma[1,0.01,10])");
  test.factory("RooDecay::MzgBkgShape(Mzg,tau[5,0,50],MzgResoShape,RooDecay::SingleSided)");

  /*
  test.factory("RooLandau::MzgTruthShape(Mzg,lanMPV[130,100,180],lanWidth[10,0.01,50])");
  test.factory("RooGaussian::MzgResoShape(Mzg,0,sigma[0.01,10])");
  test.factory("FCONV::MzgBkgShape(Mzg,MzgTruthShape,MzgResoShape)");
  */

  RooFitResult* expFitRes = test.pdf("MzgBkgShape")->fitTo(*(test.data("data")),
							   RooFit::Save(kTRUE),
							   RooFit::SumW2Error(kTRUE));

  
  if(category == 1) {
    test.factory("RooBernstein::MzgBkgShapeOldPolyBase(Mzg_old,{c0_old[-1e-6,1.01],c1_old[-1e-6,1.01],c2_old[-1e-6,1.01],c3_old[-1e-6,1.01],c4_old[-1e-6,1.01]})");
    test.factory("RooStepBernstein::MzgBkgShapePolyShape(Mzg,stepVal[0.1,0,1],{1.0,c1[0.5,-1e-6,1],c2[0.5,-1e-6,1],c3[0.5,-1e-6,1],c4[0.5,-1e-6,1]})");
  } else {
    test.factory("RooBernstein::MzgBkgShapeOldPolyBase(Mzg_old,{c0_old[-1e-6,1.01],c1_old[-1e-6,1.01],c2_old[-1e-6,1.01],c3_old[-1e-6,1.01],c4_old[-1e-6,1.01],c5_old[-1e-6,1.01]})");
    test.factory("RooStepBernstein::MzgBkgShapePolyShape(Mzg,stepVal[0.1,0,1],{15.0,c1[5,-1e-6,30],c2[5,-1e-6,30],c3[5,-1e-6,30],c4[5,-1e-6,30],c5[5,-1e-6,30]})");  

    
  }

  test.factory("RooGaussStepBernstein::MzgBkgShapePolyTest(Mzg,stepMean[105,80,150],stepSigma[4,0.01,100],{15.0,c1_test[5,-1e-6,30],c2_test[5,-1e-6,30],c3_test[5,-1e-6,30],c4_test[5,-1e-6,30],c5_test[5,-1e-6,30]})");  
  
  test.var("Mzg")->setBins(20000,"cache");
  test.var("Mzg")->setRange("ROI",115,180);

  test.factory("RooGaussian::MzgBkgShapePolyReso(Mzg,meanPoly[0],sigmaPoly[1,0.01,20])");
  
  test.factory("FCONV::MzgBkgShapePolyBase(Mzg,MzgBkgShapePolyShape,MzgBkgShapePolyReso)");
  
  Double_t sumEntries = test.data("data")->sumEntries("Mzg > 115 && Mzg < 180");
  test.factory(Form("nBkgShapePoly[%f,%f,%f]",sumEntries, sumEntries*0.75, sumEntries*1.25));
  
  test.factory("RooExtendPdf::MzgBkgShapePoly(MzgBkgShapePolyBase,nBkgShapePoly,\"ROI\")");

  //test.var("Mzg_old")->setRange("oldpolyfit",115,180);
  
  
  test.pdf("MzgBkgShapePoly")->fitTo(*(test.data("data")),
				     RooFit::Minimizer("Minuit","simplex"),
				     RooFit::SumW2Error(kTRUE),
				     RooFit::Save(kTRUE)); 
  RooFitResult* polyFitRes = test.pdf("MzgBkgShapePoly")->fitTo(*(test.data("data")),
								RooFit::SumW2Error(kTRUE),
								RooFit::Save(kTRUE));

  test.pdf("MzgBkgShapePolyTest")->fitTo(*(test.data("data")),
				     RooFit::Minimizer("Minuit","simplex"),
				     RooFit::SumW2Error(kTRUE),
				     RooFit::Save(kTRUE)); 
  RooFitResult* polyFitResTest = test.pdf("MzgBkgShapePolyTest")->fitTo(*(test.data("data")),
								       RooFit::SumW2Error(kTRUE),
								       RooFit::Save(kTRUE));
  
  
  /*
    test.pdf("MzgBkgShapeOldPoly")->fitTo(*(test.data("data_old")),
    RooFit::Minimizer("Minuit","simplex"),
    //RooFit::Range("oldpolyfit"),
    RooFit::SumW2Error(kTRUE));
  */
  
  sumEntries = test.data("data_old")->sumEntries("Mzg_old > 115 && Mzg_old < 180");
  test.factory(Form("nBkgShapeOldPoly[%f,%f,%f]",sumEntries, sumEntries*0.75, sumEntries*1.25));

  test.factory("RooExtendPdf::MzgBkgShapeOldPoly(MzgBkgShapeOldPolyBase,nBkgShapeOldPoly,\"\")");

  test.pdf("MzgBkgShapeOldPoly")->fitTo(*(test.data("data_old")),
					///RooFit::Range("oldpolyfit"),
					RooFit::SumW2Error(kTRUE));
  
  

  

  TCanvas canv("test","test",600,600);

  //setup caching for making the plot
  test.var("Mzg")->setBins(100000,"cache");

  tlx = TLatex();
  tlx.SetNDC();

  RooPlot* frame = test.var("Mzg")->frame(100,180,80);//115,180,87);
  frame->SetTitle("");
  frame->GetXaxis()->SetTitle(Form("M_{%s} (GeV)",subscriptzg));
  frame->GetYaxis()->SetTitle("Entries");
  test.data("data")->plotOn(frame);  
  test.pdf("MzgBkgShape")->plotOn(frame,
				  RooFit::ProjWData(*(test.var("dMzg")),
						    *(test.data("data"))));
  Double_t expchi2 = frame->chiSquare();
  
  RooPlot* oldpolyframe = test.var("Mzg_old")->frame(115,180,65);
  /*
  test.pdf("MzgBkgShapePolyTest")->plotOn(oldpolyframe,
				      RooFit::ProjWData(*(test.var("dMzg")),
							*(test.data("data"))),
				      RooFit::FillColor(kGreen),
				      RooFit::VisualizeError(*polyFitRes,2.0,kTRUE));
  test.pdf("MzgBkgShapePolyTest")->plotOn(oldpolyframe,
				      RooFit::ProjWData(*(test.var("dMzg")),
							*(test.data("data"))),
				      RooFit::FillColor(kYellow),
				      RooFit::VisualizeError(*polyFitRes,1.0,kTRUE));
  */
   
  test.pdf("MzgBkgShapePoly")->plotOn(frame,
				      RooFit::ProjWData(*(test.var("dMzg")),
							*(test.data("data"))),
				      RooFit::LineColor(kRed),
				      RooFit::LineStyle(2)
				      );

  test.pdf("MzgBkgShapePolyTest")->plotOn(frame,
				      RooFit::ProjWData(*(test.var("dMzg")),
							*(test.data("data"))),
				      RooFit::LineColor(kRed)
				      );
  Double_t gPolyChi2 = frame->chiSquare();
  
  
  test.data("data_old")->plotOn(oldpolyframe); 
  test.pdf("MzgBkgShapeOldPoly")->plotOn(oldpolyframe,	
					 RooFit::Range("oldpolyfit"),
					 RooFit::LineColor(kGreen-3),
					 RooFit::Name("oldpoly"));
  Double_t polyChi2 = oldpolyframe->chiSquare();
  RooCurve* theoldpoly = oldpolyframe->getCurve("oldpoly")->Clone("oplyclone");
  frame->addObject(theoldpoly);
  
  //frame->GetYaxis()->SetRangeUser(0,70);
  frame->Draw();
  tlx.DrawLatex(0.60,0.88,Form("#chi^{2}_{Pol} = %.3f",gPolyChi2));
  tlx.DrawLatex(0.59,0.77,Form("#chi^{2}_{Exp} = %.3f",expchi2));
  tlx.DrawLatex(0.59,0.66,Form("#chi^{2}_{Old} = %.3f",polyChi2));
  tlx.DrawLatex(0.59,0.55,Form("cat = %i",category));
  
  canv.Print(Form("bkgshapetest_test_zg_%s.pdf",channel));  
  canv.Clear();
  canv.SetLogy();
  //frame->GetYaxis()->SetRangeUser(1e-3,70);
  frame->Draw();
  tlx.DrawLatex(0.60,0.88,Form("#chi^{2}_{Pol} = %.3f",gPolyChi2));
  tlx.DrawLatex(0.59,0.77,Form("#chi^{2}_{Exp} = %.3f",expchi2));
  canv.Print(Form("bkgshapetest_test_zg_log_%s.pdf",channel));
  canv.Clear();

  //delete frame;

  RooRealIntegral* testint = test.pdf("MzgBkgShapePolyTest")->createIntegral(RooArgSet(*test.var("Mzg")),
									     RooArgSet(*test.var("Mzg")));
  
  
  
  //std::cout << "Normalized integral of step bernstein x (gaus):: "<< testint->getVal() << std::endl;
  delete testint;

  fout->cd();
  test.Write();
  fout->Close();

  f->Close();
  f2->Close();
}

