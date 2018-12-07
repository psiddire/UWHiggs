/*****************************************************************************
 * Project: RooFit                                                           *
 * Package: RooFitModels                                                     *
 *    File: $Id: RooStepExponential.h,v 1.10 2007/07/12 20:30:49 wouter Exp $
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
#ifndef ROO_STEPEXPONENTIAL
#define ROO_STEPEXPONENTIAL

#include "RooAbsPdf.h"
#include "RooRealProxy.h"

class RooRealVar;
class RooAbsReal;

class RooStepExponential : public RooAbsPdf {
public:
  RooStepExponential() {} ;
  RooStepExponential(const char *name, const char *title,
		     RooAbsReal& _x, RooAbsReal& _c, RooAbsReal& _stepVal);
  RooStepExponential(const RooStepExponential& other, const char* name=0);
  virtual TObject* clone(const char* newname) const 
     { return new RooStepExponential(*this,newname); }
  inline virtual ~RooStepExponential() { }

  Int_t getAnalyticalIntegral(RooArgSet& allVars, 
			      RooArgSet& analVars, 
			      const char* rangeName=0) const ;
  Double_t analyticalIntegral(Int_t code, 
			      const char* rangeName=0) const ;

protected:
  RooRealProxy x;
  RooRealProxy c;
  RooRealProxy stepVal;

  Double_t evaluate() const;

private:
  ClassDef(RooStepExponential,1) // Exponential PDF
};

#endif
