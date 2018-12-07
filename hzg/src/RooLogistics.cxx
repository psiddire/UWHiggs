/*****************************************************************************
 * Project: RooFit                                                           *
 * Package: RooFitModels                                                     *
 * @(#)root/roofit:$Id: RooLogistics.cxx 44507 2012-06-04 12:30:41Z axel $
 * Authors:                                                                  *
 *   WV, Wouter Verkerke, UC Santa Barbara, verkerke@slac.stanford.edu       *
 *   DK, David Kirkby,    UC Irvine,         dkirkby@uci.edu                 *
 *                                                                           *
 * Copyright (c) 2000-2005, Regents of the University of California          *
 *                          and Stanford University. All rights reserved.    *
 *                                                                           *
 * Redistribution and use in source and binary forms,                        *
 * with or without modification, are permitted according to the terms        *
 * listed in LICENSE (http://roofit.sourceforge.net/license.txt)             *
 *****************************************************************************/

//////////////////////////////////////////////////////////////////////////////
//
// BEGIN_HTML
// Plain Gaussian p.d.f
// END_HTML
//

#include "RooFit.h"

#include "Riostream.h"
#include "Riostream.h"
#include <math.h>

#include "UWHiggs/hzg/interface/RooLogistics.h"
#include "RooAbsReal.h"
#include "RooRealVar.h"
#include "RooRandom.h"
#include "RooMath.h"

#include <cmath>

using namespace std;

ClassImp(RooLogistics)


//_____________________________________________________________________________
RooLogistics::RooLogistics(const char *name, const char *title,
			 RooAbsReal& _x, RooAbsReal& _mean,
			 RooAbsReal& _sigma) :
  RooAbsPdf(name,title),
  x("x","Observable",this,_x),
  mean("mean","Mean",this,_mean),
  sigma("sigma","Width",this,_sigma)
{
}



//_____________________________________________________________________________
RooLogistics::RooLogistics(const RooLogistics& other, const char* name) : 
  RooAbsPdf(other,name), x("x",this,other.x), mean("mean",this,other.mean),
  sigma("sigma",this,other.sigma)
{
}



//_____________________________________________________________________________
Double_t RooLogistics::evaluate() const
{
  Double_t arg= x - mean;  
  Double_t sig = sigma ;
  Double_t ret = logistics(arg/sig);
//   cout << "gauss(" << GetName() << ") x = " << x << " mean = " << mean << " sigma = " << sigma << " ret = " << ret << endl ;
  return ret ;
}



//_____________________________________________________________________________
Int_t RooLogistics::getAnalyticalIntegral(RooArgSet& allVars, RooArgSet& analVars, const char* /*rangeName*/) const 
{
  if (matchArgs(allVars,analVars,x)) return 1 ;
  if (matchArgs(allVars,analVars,mean)) return 2 ;
  return 0 ;
}



//_____________________________________________________________________________
Double_t RooLogistics::analyticalIntegral(Int_t code, const char* rangeName) const 
{
  assert(code==1 || code==2) ;  
  Double_t ret = 0;
  if(code==1){  
    ret = sigmoid((x.max(rangeName)-mean)/sigma)-sigmoid((x.min(rangeName)-mean)/sigma);
  } else if(code==2) {
    ret = sigmoid((mean.max(rangeName)-x)/sigma)-sigmoid((mean.min(rangeName)-x)/sigma);
  } else{
    cout << "Error in RooLogistics::analyticalIntegral" << endl;
  }
  return ret ;
}

Double_t RooLogistics::sigmoid(const double x) const {
  return (1.0)/(1.0 + std::exp(-x));
}

Double_t RooLogistics::logistics(const double x) const {
  return std::exp(-x)/(sigma*std::pow(1+std::exp(-x),2.0));
}
