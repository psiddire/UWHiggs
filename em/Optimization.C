#include <cstdlib>
#include <iostream>
#include <map>
#include <string>

#include "TChain.h"
#include "TFile.h"
#include "TTree.h"
#include "TString.h"
#include "TObjString.h"
#include "TSystem.h"
#include "TROOT.h"

#include "TMVA/Factory.h"
#include "TMVA/Tools.h"
#include "TMVA/MethodCategory.h"
#include "TMVA/MethodBase.h"
#include "TMVA/MethodCuts.h"
//#endif

void Optimization(const char* outputFileName = "TMVA_Opt") {
  
  TMVA::Tools::Instance();
  char a[100];
  sprintf(a, "%s.root", outputFileName);
  TFile* outputFile = TFile::Open(a, "RECREATE");
  TMVA::Factory *factory = new TMVA::Factory(outputFileName, outputFile, "!V:!Silent");
  TMVA::DataLoader *dataloader=new TMVA::DataLoader("dataset");

  dataloader->AddVariable("mPt", 'F');
  dataloader->AddVariable("ePt", 'F');
  dataloader->AddVariable("type1_pfMetEt", 'F');

  TFile* input = TFile::Open("Input/Opt.root");
  TTree* inputTree = (TTree*)input->Get("opttree");
  outputFile->cd();

  dataloader->SetInputTrees(inputTree, "e_m_Mass > 110 & itype == -1", "e_m_Mass > 110 & itype == 0");
  dataloader->SetWeightExpression("weight");

  dataloader->PrepareTrainingAndTestTree("", "", "nTrain_Signal=0:nTrain_Background=0::nTest_Signal=0:nTest_Background=0:SplitMode=Random:!V" );

  const int nCategories = 1;
  const int nMethods = 1;
  TMVA::MethodCategory* mcat[nMethods];
  TMVA::MethodBase* methodBase[nMethods];

  // TString vars = "mPt:ePt:type1_pfMetEt";
  TString vars = "type1_pfMetEt";
  
  TCut cat_definition[nCategories];
  cat_definition[0] = "e_m_Mass < 160";

  TString methodOptions[nMethods];
  methodOptions[0] = "!H:!V:EffMethod=EffSel:FitMethod=GA:VarProp[0]=FMin"; //VarProp[0]=FMax:VarProp[1]=FMax:VarProp[2]=FMin
  
  for (int i=0; i<1; i++) {
    sprintf(a, "Category_Cuts%d", i);
    methodBase[i] = factory->BookMethod(dataloader, TMVA::Types::kCategory, a, "!V");
    mcat[i] = dynamic_cast<TMVA::MethodCategory*>(methodBase[i]);
    for (int j=0; j<nCategories; j++) {
      sprintf(a, "Category_Cuts%d_%d", i, j);
      mcat[i]->AddMethod(cat_definition[j], vars, TMVA::Types::kCuts, a, methodOptions[i]);
    }
  }

  // factory->BookMethod(dataloader, TMVA::Types::kCategory, "Category_Cuts", "!V");
    
  factory->TrainAllMethods();
  factory->TestAllMethods();
  factory->EvaluateAllMethods();
  
  outputFile->Close();

  delete factory;
}
