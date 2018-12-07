/*****************************************************************************
 * Project: RooFit                                                           *
 * Package: RooFitModels                                                     *
 * @(#)root/roofit:$Id: RooStepExponential.cxx 44507 2012-06-04 12:30:41Z axel $
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
// Exponential p.d.f
// END_HTML
//

#include "RooFit.h"

#include "Riostream.h"
#include "Riostream.h"
#include <math.h>

#include "UWHiggs/hzg/interface/RooStepExponential.h"
#include "RooRealVar.h"

using namespace std;

ClassImp(RooStepExponential)


//_____________________________________________________________________________
RooStepExponential::RooStepExponential(const char *name, const char *title,
				       RooAbsReal& _x, 
				       RooAbsReal& _c,
				       RooAbsReal& _stepVal) :
  RooAbsPdf(name, title), 
  x("x","Dependent",this,_x),
  c("c","Exponent",this,_c),
  stepVal("stepVal","stepLocation",this,_stepVal)
{
}


//_____________________________________________________________________________
RooStepExponential::RooStepExponential(const RooStepExponential& other, 
				       const char* name) :
  RooAbsPdf(other, name), 
  x("x",this,other.x), 
  c("c",this,other.c),
  stepVal("stepVal",this,other.stepVal)
{
}


//_____________________________________________________________________________
Double_t RooStepExponential::evaluate() const{
  //cout << "exp(x=" << x << ",c=" << c << ")=" << exp(c*x) << endl ;
  if( x < stepVal) return 0;  
  return exp(c*x);
}


//_____________________________________________________________________________
Int_t RooStepExponential::getAnalyticalIntegral(RooArgSet& allVars, 
						RooArgSet& analVars, 
						const char* /*rangeName*/) const 
{
  if (matchArgs(allVars,analVars,x)) return 1 ;
  return 0 ;
}


//_____________________________________________________________________________
Double_t RooStepExponential::analyticalIntegral(Int_t code, 
						const char* rangeName) const 
{
  switch(code) {
  case 1: 
    {
      Double_t ret(0) ;
      if(c == 0.0) {
	ret = (x.max(rangeName) - stepVal);
      } else {
	ret =  ( exp( c*x.max(rangeName) ) - 
		 exp( c*stepVal ) )/c;
      }      
      return ret ;
    }
  }
  
  assert(0) ;
  return 0 ;
}

