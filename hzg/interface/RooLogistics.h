/*****************************************************************************
 * Project: RooFit                                                           *
 * Package: RooFitModels                                                     *
 *    File: $Id: RooGaussian.h,v 1.16 2007/07/12 20:30:49 wouter Exp $
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
#ifndef ROO_LOGISTICS
#define ROO_LOGISTICS

#include "RooAbsPdf.h"
#include "RooRealProxy.h"

class RooRealVar;

class RooLogistics : public RooAbsPdf {
public:
  RooLogistics() {} ;
  RooLogistics(const char *name, const char *title,
	      RooAbsReal& _x, RooAbsReal& _mean, RooAbsReal& _sigma);
  RooLogistics(const RooLogistics& other, const char* name=0) ;
  virtual TObject* clone(const char* newname) const { return new RooLogistics(*this,newname); }
  inline virtual ~RooLogistics() { }

  Int_t getAnalyticalIntegral(RooArgSet& allVars, RooArgSet& analVars, const char* rangeName=0) const ;
  Double_t analyticalIntegral(Int_t code, const char* rangeName=0) const ;
  
protected:

  RooRealProxy x ;
  RooRealProxy mean ;
  RooRealProxy sigma ;
  
  Double_t evaluate() const ;

private:
  Double_t sigmoid(const double x) const;
  Double_t logistics(const double x) const;

  ClassDef(RooLogistics,1) // Logistics (sech) PDF
};

#endif
