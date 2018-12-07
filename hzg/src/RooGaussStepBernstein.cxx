/*****************************************************************************
 * Project: RooFit                                                           *
 * Package: RooFitModels                                                     *
 * @(#)root/roofit:$Id: RooBernstein.cxx 45779 2012-08-31 15:44:51Z moneta $
 * Authors:                                                                  *
 *   Kyle Cranmer
 *                                                                           *
 *****************************************************************************/

//////////////////////////////////////////////////////////////////////////////
//
// BEGIN_HTML
// Bernstein basis polynomials are positive-definite in the range [0,1].
// In this implementation, we extend [0,1] to be the range of the parameter.
// There are n+1 Bernstein basis polynomials of degree n.
// Thus, by providing N coefficients that are positive-definite, there 
// is a natural way to have well bahaved polynomail PDFs.
// For any n, the n+1 basis polynomials 'form a partition of unity', eg.
//  they sum to one for all values of x. See
// http://www.idav.ucdavis.edu/education/CAGDNotes/Bernstein-Polynomials.pdf
// Step function piece means that for x < value f(x) = 0 and for
// x >= value: f(x) = Gauss(x)RooBernstein
// END_HTML
//

#include "RooFit.h"

#include "Riostream.h"
#include <math.h>
#include "TMath.h"
#include "Math/SpecFunc.h"
#include <UWHiggs/hzg/interface/RooGaussStepBernstein.h>
#include "RooAbsReal.h"
#include "RooRealVar.h"
#include "RooArgList.h"

using namespace std;

ClassImp(RooGaussStepBernstein)

namespace { 
  double zeroth(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);
    const double erf_parm = (m-x)/(root2*s);
    return ( std::sqrt(M_PI/2.0)*s*std::erfc(erf_parm) );
  }
  double first(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));
    return s*s*gaus + rootpiover2*s*(x-m)*std::erfc(erf_parm);
  }
  double second(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));
    return ( s*s*(x-m)*gaus + 
	     rootpiover2*s*(s*s +(m-x)*(m-x))*std::erfc(erf_parm) );
  }
  double third(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));
    return ( s*s*(2.0*s*s + (m-x)*(m-x))*gaus - 
	     rootpiover2*s*(3.0*s*s +(m-x)*(m-x))*(m-x)*std::erfc(erf_parm) );
  }
  double fourth(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));

    const double x2 = std::pow(x,2);
    const double x3 = x2*x;
    const double x4 = x3*x;
    //const double x5 = x4*x;
    //const double x6 = x5*x;

    const double mmx2 = std::pow(m-x,2);
    //const double mmx3 = mmx2*(m-x);
    //const double mmx4 = mmx3*(m-x);
    //const double mmx5 = mmx4*(m-x);

    const double m2 = std::pow(m,2);
    const double m3 = m2*m;
    const double m4 = m3*m;
    //const double m5 = m4*m;
    //const double m6 = m5*m;

    const double s2 = std::pow(s,2);
    const double s3 = s2*s;
    const double s4 = s3*s;
    //const double s5 = s4*s;
    //const double s6 = s5*s;

    const double poly =
      (m4 + 3.0*s4 - 4.0*m3*x + 6.0*s2*x2 + x4 + 
       6.0*m2*(s2+x2) - 4.0*m*(3.0*s2*x + x3));
    return ( -s2*(5.0*s2 + mmx2)*(m-x)*gaus +
	     rootpiover2*s*poly*std::erfc(erf_parm) );
  }
  double fifth(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);    
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));

    const double x2 = std::pow(x,2);
    const double x3 = x2*x;
    const double x4 = x3*x;
    //const double x5 = x4*x;
    //const double x6 = x5*x;

    const double mmx2 = std::pow(m-x,2);
    const double mmx3 = mmx2*(m-x);
    const double mmx4 = mmx3*(m-x);
    //const double mmx5 = mmx4*(m-x);

    const double m2 = std::pow(m,2);
    const double m3 = m2*m;
    const double m4 = m3*m;
    //const double m5 = m4*m;
    //const double m6 = m5*m;

    const double s2 = std::pow(s,2);
    const double s3 = s2*s;
    const double s4 = s3*s;
    //const double s5 = s4*s;
    //const double s6 = s5*s;

    const double poly1 =
      ( 8.0*s4 + 9.0*s2*mmx2 + mmx4 );
    const double poly2 =
      ( m4 + 10.0*m2*s2 + 15.0*s4- 4.0*m*(m2 + 5.0*s2)*x +
	2.0*(3.0*m2 + 5.0*s2)*x2 - 4.0*m*x3 + x4 );
    const double poly3 = 
      ( m4 + 15.0*s4 - 4.0*m3*x + 10.0*s2*x2 + x4 +
	2.0*m2*(5.0*s2 +3.0*x2) - 4.0*m*(5.0*s2*x + x3) );
    return ( s*gaus*( s*poly1 - 
		      gaus*rootpiover2*(m-x)*poly2 +
		      gaus*rootpiover2*(m-x)*poly3*std::erf(erf_parm) ) );
  }
  double sixth(const double x, const double m, const double s) {
    const double root2 = std::sqrt(2);    
    const double rootpiover2 = std::sqrt(M_PI/2.0);
    const double erf_parm = (m-x)/(root2*s);
    const double gaus = std::exp(-0.5*(m-x)*(m-x)/(s*s));
    
    const double x2 = std::pow(x,2);
    const double x3 = x2*x;
    const double x4 = x3*x;
    const double x5 = x4*x;
    const double x6 = x5*x;

    const double mmx2 = std::pow(m-x,2);
    //const double mmx3 = mmx2*(m-x);
    //const double mmx4 = mmx3*(m-x);
    //const double mmx5 = mmx4*(m-x);

    const double m2 = std::pow(m,2);
    const double m3 = m2*m;
    const double m4 = m3*m;
    const double m5 = m4*m;
    const double m6 = m5*m;

    const double s2 = std::pow(s,2);
    const double s3 = s2*s;
    const double s4 = s3*s;
    const double s5 = s4*s;
    const double s6 = s5*s;
    
    const double poly1 =
      ( (3.0*s2 + mmx2)*(11.0*s2 + mmx2)*(m-x) );
    const double poly2 =
      ( m6 +15.0*m4*s2 + 45.0*m2*s4 + 15.0*s6 - 6.0*m*(m4 + 10.0*m2*s2 + 15.0*s4)*x +
	15.0*(m4 + 6.0*m2*s2 +3.0*s4)*x2 - 20.0*m*(m2 + 3.0*s2)*x3 + 
	15.0*(m2+s2)*x4 - 6.0*m*x5 + x6 );
    const double poly3 = 
      ( m6 + 15.0*s6 - 6.0*m5*x + 45.0*s4*x2 + 15.0*s2*x4 + x6 +15.0*m4*(s2 + x2) -
	20.0*m3*(3.0*s2*x + x3) +15*m2*(3.0*s4 + 6.0*s2*x2 + x4) - 
	6.0*m*(15.0*s4*x + 10.0*s2*x3 + x5) );
    return ( s*gaus*( -s*poly1 +
		      gaus*rootpiover2*(m-x)*poly2 -
		      gaus*rootpiover2*poly3*std::erf(erf_parm) ) );
  }

  double poly_conv(double x, double mean, 
		   double sigma, int i) {
    switch( i ) {
    case 0:
      return zeroth(x,mean,sigma);
      break;
    case 1:
      return first(x,mean,sigma);
      break;
    case 2:
      return second(x,mean,sigma);
      break;
    case 3:
      return third(x,mean,sigma);
      break;
    case 4:
      return fourth(x,mean,sigma);
      break;
    case 5:
      return fifth(x,mean,sigma);
      break;
    case 6:
      return sixth(x,mean,sigma);
      break;
    default:
      assert(1 == 0 && "You requested a convolution that we haven't calculated yet!");
      return -1;
    }
    return -1;
  }
}


//_____________________________________________________________________________
RooGaussStepBernstein::RooGaussStepBernstein()
{
}


//_____________________________________________________________________________
RooGaussStepBernstein::RooGaussStepBernstein(const char* name, 
					     const char* title, 
					     RooAbsReal& x, 
					     RooAbsReal& mean,
					     RooAbsReal& sigma,
					     const RooArgList& coefList): 
  RooAbsPdf(name, title),
  _x("x", "Dependent", this, x),
  _mean("mean","mean of gaussian convolved with polyn",this,mean),
  _sigma("sigma","sigma of gaussian convolved with polyn",this,sigma),
  _coefList("coefficients","List of coefficients",this)
{
  // Constructor
  TIterator* coefIter = coefList.createIterator() ;
  RooAbsArg* coef ;
  while((coef = (RooAbsArg*)coefIter->Next())) {
    if (!dynamic_cast<RooAbsReal*>(coef)) {
      cout << "RooGaussStepBernstein::ctor(" << GetName() 
	   << ") ERROR: coefficient " << coef->GetName() 
	   << " is not of type RooAbsReal" << endl ;
      assert(0) ;
    }
    _coefList.add(*coef) ;
  }
  delete coefIter ;
}



//_____________________________________________________________________________
RooGaussStepBernstein::RooGaussStepBernstein(const RooGaussStepBernstein& other, const char* name) :
  RooAbsPdf(other, name), 
  _x("x", this, other._x), 
  _mean("mean",this,other._mean),
  _sigma("sigma",this,other._sigma),
  _coefList("coefList",this,other._coefList)
{
}


//_____________________________________________________________________________
Double_t RooGaussStepBernstein::evaluate() const 
{
  // something that's positive definite!!!!!!
  const Double_t xmin = _x.min(); // old  

  //Double_t xmin = _stepThresh;
  const Double_t x = (_x - xmin) / (_x.max() - xmin);   

  Int_t degree = _coefList.getSize() - 1; // n+1 polys of degree n  
  RooFIter iter;
  
  const Double_t mean  = _mean;//( _mean - xmin )/( _x.max() - xmin ); // scale to [0,1]
  const Double_t sigma = _sigma;//(_sigma) / (_x.max() - xmin) ;// scale to [0,1]
      
  double beta = 0.0;  
  // iterate through each 
  Double_t result = 0.0;
  for(Int_t i = 0; i <= degree; ++i) {    
    // calculate the coefficient in the 'power basis'
    // i.e. the naive polynomial basis
    beta = 0.0;
    iter = _coefList.fwdIterator();
    for(Int_t k=i; k <= degree; ++k) {
      // coef is the bernstein polynomial coefficient
      beta += (std::pow(-1.,k-i)*TMath::Binomial(degree,k)*TMath::Binomial(k,i));
    }    
    beta *= ((RooAbsReal *)iter.next())->getVal();
    
    result += beta*poly_conv(x,mean,sigma,i);    
  }

  //std::cout << result << std::endl;

  return result;
}


//_____________________________________________________________________________
Int_t RooGaussStepBernstein::getAnalyticalIntegral(RooArgSet& allVars, 
						   RooArgSet& analVars, 
						   const char* rangeName) const
{
  // No analytical calculation available (yet) of integrals over subranges
  if (rangeName && strlen(rangeName)) {
    return 0 ;
  }
  
  
  if (matchArgs(allVars, analVars, _x)) return 0;
  return 0;
}


//_____________________________________________________________________________
Double_t RooGaussStepBernstein::analyticalIntegral(Int_t code, 
						   const char* rangeName) const
{
  assert(code==1) ;
  return 1.0;
}
