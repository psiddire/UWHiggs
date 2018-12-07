'''

Analyze EMT events for the WH analysis

'''

from WHAnalyzerBase import WHAnalyzerBase, quad, inv_mass
from EMuTauTree import EMuTauTree
import glob
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import mcCorrectors
import baseSelections as selections
import fakerate_functions as frfits
import ROOT
import math
import optimizer
from FinalStateAnalysis.PlotTools.decorators import memo_last

################################################################################
#### Analysis logic ############################################################
################################################################################
is7TeV = bool('7TeV' in os.environ['jobid'])
use_iso_trigger = not is7TeV

class WHAnalyzeEMT(WHAnalyzerBase):
    tree = 'emt/final/Ntuple'

    def __init__(self, tree, outfile, **kwargs):
        self.channel = 'EMT'
        super(WHAnalyzeEMT, self).__init__(tree, outfile, EMuTauTree, **kwargs)

	def attr_getter(attribute):
            def f(row, weight):
                return (getattr(row,attribute), weight)
            return f

        def mass_scaler(fcn):
            def f(row, weight):
                val, w = fcn(row, weight)
                res = val
                if row.ePt < row.mPt:
                    res = frfits.default_scaler(val)
                return res, w
            return f

        def merge_functions(fcn_1, fcn_2):
            def f(row, weight):
                r1, w1 = fcn_1(row, weight)
                r2, w2 = fcn_2(row, weight)
                w = w1 if w1 == w2 else None
                return ((r1, r2), w)
            return f

        def sub_mass(row, weight):
            return (row.e_t_Mass, weight) if row.ePt < row.mPt else (row.m_t_Mass, weight)
        
        lead_iso = self.grid_search['']['leading_iso']
        sublead_iso = self.grid_search['']['subleading_iso']
        
        def f_prob(row, weight):
            p_m = ( self.obj1_weight(row, lead_iso, sublead_iso) + \
                    self.obj1_qcd_weight(row, lead_iso, sublead_iso))/2
            p_e = ( self.obj2_weight(row, lead_iso, sublead_iso) + \
                    self.obj2_qcd_weight(row, lead_iso, sublead_iso))/2
            p_t  = frfits.tau_fr(row.tPt)
            return ((p_m + p_e*(1 - p_m) + p_t*(1 - p_m)*(1 - p_e)), weight)

        def log_prob(row, weight):
            prob, weight = f_prob(row, weight)
            return math.log(prob), weight
        
        self.hfunc['faking_prob'] = f_prob
        self.hfunc['log_prob']    = log_prob
        self.hfunc["subMass#faking_prob"] = merge_functions( sub_mass, f_prob  )
        self.hfunc["subMass#log_prob"   ] = merge_functions( sub_mass, log_prob)
        self.hfunc["subMass#LT" ] = merge_functions( sub_mass, attr_getter('LT'))
        self.hfunc["subMass#tPt"] = merge_functions( sub_mass, attr_getter('tPt'))

        self.hfunc["subMass*#faking_prob"] = merge_functions( mass_scaler( sub_mass ), f_prob  )
        self.hfunc["subMass*#log_prob"   ] = merge_functions( mass_scaler( sub_mass ), log_prob)
        self.hfunc["subMass*#LT" ] = merge_functions( mass_scaler( sub_mass ), attr_getter('LT'))
        self.hfunc["subMass*#tPt"] = merge_functions( mass_scaler( sub_mass ), attr_getter('tPt'))

        #maps the name of non-trivial histograms to a function to get the proper value, the function MUST have two args (evt and weight). Used in WHAnalyzerBase.fill_histos later
        self.hfunc['subMass']   = sub_mass 
        self.hfunc['tLeadDR']   = lambda row, weight: (row.m_t_DR,   weight)    if row.ePt < row.mPt else (row.e_t_DR,   weight) 
        self.hfunc['tSubDR']    = lambda row, weight: (row.e_t_DR,   weight)    if row.ePt < row.mPt else (row.m_t_DR,   weight) 
        self.hfunc["subPt"]     = lambda row, weight: (row.ePt, weight)         if row.ePt < row.mPt else (row.mPt, weight) 
        self.hfunc["leadPt"]    = lambda row, weight: (row.mPt, weight)         if row.ePt < row.mPt else (row.ePt, weight)         
        self.hfunc["subJetPt"]  = lambda row, weight: (row.eJetPt, weight)      if row.ePt < row.mPt else (row.mJetPt, weight) 
        self.hfunc["leadJetPt"] = lambda row, weight: (row.mJetPt, weight)      if row.ePt < row.mPt else (row.eJetPt, weight)         
        self.hfunc['pt_ratio' ] = lambda row, weight: (row.ePt/row.mPt, weight) if row.ePt < row.mPt else (row.mPt/row.ePt, weight)
        self.hfunc["e*_t_Mass"] = lambda row, weight: ( frfits.default_scaler( row.e_t_Mass), weight)
        self.hfunc["e*_m_Mass"] = lambda row, weight: ( frfits.default_scaler( row.e_m_Mass), weight)
        self.hfunc["subMass*" ] = mass_scaler( sub_mass ) 
        self.hfunc["_recoilDaught" ] = lambda row, weight: (math.sqrt(row.recoilDaught) , weight)
        self.hfunc["_recoilWithMet"] = lambda row, weight: (math.sqrt(row.recoilWithMet), weight)

        self.pucorrector = mcCorrectors.make_puCorrector('mueg')

    def book_histos(self, folder):
        for key in self.grid_search:
            prefix = key+'$' if key else ''
            self.book(folder, prefix+"subMass", "Subleading Mass", 200, 0, 200)
            self.book(folder, prefix+"LT", "L_T", 100, 0, 300)
            #Charge mis-id special histograms
            if 'c2' in folder:
                self.book(folder, prefix+"subMass*", "Subleading Mass", 200, 0, 200)

        if len(self.grid_search.keys()) == 1:
            if 'c2' in folder:
                self.book(folder, "e*_t_Mass", "Electron-Tau Mass", 200, 0, 200)
                self.book(folder, "e*_m_Mass", "Electron-Muon Mass", 200, 0, 200)
                #self.book(folder, "subMass*#faking_prob", '', 200, 0, 200, 220, 0., 1.1, type=ROOT.TH2F)
                #self.book(folder, "subMass*#log_prob"   , '', 200, 0, 200, 200, -2,  1, type=ROOT.TH2F)
                self.book(folder, "subMass*#LT"         , '', 200, 0, 200, 120, 0, 600, type=ROOT.TH2F)
                self.book(folder, "subMass*#tPt"        , '', 200, 0, 200, 200, 0, 200, type=ROOT.TH2F)


            self.book(folder, prefix+"subMass#LT" , "subleadingMass", 200, 0, 200, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"subMass#tPt", "subleadingMass", 200, 0, 200, 200, 0, 200, type=ROOT.TH2F)

            #Pt
            self.book(folder, prefix+"mPt#LT" , "subleadingMass", 150, 0, 150, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"ePt#LT" , "subleadingMass", 150, 0, 150, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"tPt#LT" , "subleadingMass", 150, 0, 150, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"mJetPt#LT" , "subleadingMass", 150, 0, 150, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"eJetPt#LT" , "subleadingMass", 150, 0, 150, 120, 0, 600, type=ROOT.TH2F)

            #eta
            self.book(folder, prefix+"mAbsEta#LT" , "subleadingMass", 100, 0, 2.5, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"eAbsEta#LT" , "subleadingMass", 100, 0, 2.5, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"tAbsEta#LT" , "subleadingMass", 100, 0, 2.5, 120, 0, 600, type=ROOT.TH2F)

            #DR
            self.book(folder, prefix+"m_t_DR#LT" , "subleadingMass", 100, 0, 10, 120, 0, 600, type=ROOT.TH2F)
            self.book(folder, prefix+"e_t_DR#LT" , "subleadingMass", 100, 0, 10, 120, 0, 600, type=ROOT.TH2F)

            #Jet BTag
            self.book(folder, "mJetBtag#LT", "Muon 2 Pt", 30, -10, 5, 60, 0, 600, type=ROOT.TH2F)
            self.book(folder, "eJetBtag#LT", "Muon 2 Pt", 30, -10, 5, 60, 0, 600, type=ROOT.TH2F)

            self.book(folder, "subPt"   , "SubLeading Pt", 100, 0, 100)
            self.book(folder, "leadPt"  , "Leading Pt"   , 100, 0, 100)
            self.book(folder, "subJetPt"   , "SubLeading Pt", 100, 0, 100)
            self.book(folder, "leadJetPt"  , "Leading Pt"   , 100, 0, 100)
            self.book(folder, "e_m_Mass", "Electron-Muon Mass", 200, 0, 200)
            self.book(folder, "m_t_Mass", "Electron-Muon Mass", 200, 0, 200)
            self.book(folder, "e_t_Mass", "Electron-Tau Mass", 200, 0, 200)
            self.book(folder, "nTruePU", "NPU", 62, -1.5, 60.5)
            self.book(folder, "mPt", "Muon Pt", 100, 0, 100)
            self.book(folder, "ePt", "Electron Pt", 100, 0, 100)
            self.book(folder, "mJetPt", "Muon Pt", 100, 0, 100)
            self.book(folder, "eJetPt", "Electron Pt", 100, 0, 100)
            self.book(folder, "tPt", "Tau Pt", 100, 0, 100)
            self.book(folder, "mAbsEta", "Muon AbsEta", 100, 0, 2.4)
            self.book(folder, "eAbsEta", "Electron AbsEta", 100, 0, 2.5)
            self.book(folder, "tAbsEta", "Tau AbsEta", 100, 0, 2.3)
            self.book(folder, "eChargeIdTight", "Elec charge ID tight", 2, -0.5, 1.5)
            self.book(folder, "tLeadDR", "DR between leading lepton and tau", 100, 0, 5)
            self.book(folder, "tSubDR", "DR between subleading lepton and tau", 100, 0, 5)
            self.book(folder, "e_m_DR", "", 200, 0, 5)
            self.book(folder, "m_t_DR", "", 200, 0, 5)
            self.book(folder, "e_t_DR", "", 200, 0, 5)

        
            #let's look for osme other possible selections
            self.book(folder, "Mass"          , "mass"          , 800, 0, 800 )
            self.book(folder, "pt_ratio"      , "pt_ratio"      , 100, 0, 1)
            self.book(folder, "tToMETDPhi"    , "tToMETDPhi"    , 100, 0, 4)
            self.book(folder, "type1_pfMetEt"         , "metEt"         , 300, 0, 2000)


    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    def preselection( self, row, cut_flow_trk = None, LT_threshold = 80., taupt_thr = 0.):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        mu17e8, mu8e17 = False, False
        if use_iso_trigger:
            mu17e8 = row.mu17ele8isoPass and \
                row.mMatchesMu17Ele8IsoPath > 0 and \
                row.eMatchesMu17Ele8IsoPath > 0 and \
                row.mPt >= 20
            mu8e17 = row.mu8ele17isoPass and \
                row.mMatchesMu8Ele17IsoPath > 0 and \
                row.eMatchesMu8Ele17IsoPath > 0 and \
                row.ePt >= 20
        else:
            mu17e8 = row.mu17ele8Pass and \
                row.mMatchesMu17Ele8Path > 0 and \
                row.eMatchesMu17Ele8Path > 0 and \
                row.mPt >= 20
            mu8e17 = row.mu8ele17Pass and \
                row.mMatchesMu8Ele17Path > 0 and \
                row.eMatchesMu8Ele17Path > 0 and \
                row.ePt >= 20
            
        if not (mu17e8 or mu8e17):                return False
        cut_flow_trk.Fill('trigger')

        if not selections.muSelection(row, 'm'):  return False #applies basic selection (eta, pt > 10, DZ, pixHits, jetBTag)
        #cut_flow_trk.Fill('pt requirements 1', 'eta requirements 1', 'MissingHits 1', 'HasConversion 1', 'JetBtag 1', 'DZ 1',)
        cut_flow_trk.Fill('obj1 Presel')

        if not selections.eSelection(row, 'e'):   return False #applies basic selection (eta, pt > 10, DZ, missingHits, jetBTag, HasConversion and chargedIdTight)
        cut_flow_trk.Fill('obj2 Presel')
        #FIXME
        #if row.ePt < 10:           return False
	#cut_flow_trk.Fill('pt requirements 2')
    	#if row.eAbsEta > 2.5:      return False
	#cut_flow_trk.Fill('eta requirements 2')
    	#if row.eMissingHits:       return False
	#cut_flow_trk.Fill('MissingHits 2')
    	#if row.eHasConversion:     return False
	#cut_flow_trk.Fill('HasConversion 2')
    	#if row.eJetBtag > 3.3:     return False
	#cut_flow_trk.Fill('JetBtag 2')
    	#if abs(row.eDZ) > 0.2:     return False
	#cut_flow_trk.Fill('DZ 2')


        if not selections.tauSelection(row, 't'): return False #applies basic selection (eta, pt > 20, DZ)
        if row.tPt < taupt_thr: return False
        if row.tMuOverlap:         return False
        if not row.tAntiMuonTight: return False
        cut_flow_trk.Fill('obj3 Presel')

        if row.LT < LT_threshold:            return False
        cut_flow_trk.Fill('LT')

        if row.e_m_SS and row.e_t_SS: return False #remove three SS leptons
        if not selections.vetos(row): return False #applies mu bjet e additional tau vetoes
        cut_flow_trk.Fill('vetos')
        #FIXME
    	if not row.eChargeIdTight: return False
        #cut_flow_trk.Fill('ChargeIdTight')
       
        if e_m_Mass < 20:          return False
        cut_flow_trk.Fill('charge_fakes') #no charge fakes here

        #FIXME: ONLY FOR CUT-FLOW PRODUCTION
        #if not row.mPFIDTight: return False
        #cut_flow_trk.Fill('obj1 ID')
        #if not selections.lepton_id_iso(row, 'm', 'h2taucuts'): return False
        #cut_flow_trk.Fill('obj1 Iso')
        #if not selections.summer_2013_eid(row, 'e'): return False
        #cut_flow_trk.Fill('obj2 ID')
        #if not selections.lepton_id_iso(row, 'e', 'h2taucuts'): return False
        #cut_flow_trk.Fill('obj2 Iso')
        #if not row.tLooseIso3Hits: return False
        #cut_flow_trk.Fill('obj3 IDIso')

        return True

    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    @staticmethod
    def sign_cut( row):
        ''' Returns true if muons are SS '''
        return bool(row.e_m_SS)

    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    @staticmethod
    def obj1_id( row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        return selections.lepton_id_iso(row, 'm', ledleptonId) 

    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    @staticmethod
    def obj2_id( row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        return selections.lepton_id_iso(row, 'e', subledleptonId)

    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    @staticmethod
    def obj3_id(row, tauId=None, LT_threshold = 80., taupt_thr = 0.):
        if row.LT >= LT_threshold and row.tPt >= taupt_thr:
            return bool(row.tLooseIso3Hits)
        else:
            return bool( getattr(row, tauId) )

    #There is no call to self, so just promote it to statucmethod, to allow usage by other dedicated analyzers
    @staticmethod
    def anti_wz( row):
        if row.e_t_Zcompat < 20:
            if not row.tAntiElectronMVA3Medium:
                return False
        elif not row.tAntiElectronMVA3Loose:
            return False
        return True

    def enhance_wz(self, row):
        if row.e_t_Zcompat < 15 and not row.tAntiElectronMVA:
            return True
        return False

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m') * \
            mcCorrectors.get_electron_corrections(row,'e') * \
            mcCorrectors.correct_mueg_mu(row.mPt, row.mAbsEta) * \
            mcCorrectors.correct_mueg_e(row.ePt, row.eAbsEta)

    def obj1_weight(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        if mu17e8:
            return frfits.highpt_mu_fr[ledleptonId](muonJetPt=max(row.mJetPt, row.mPt), muonPt=row.mPt, muonJetCSVBtag=max(0, row.mJetCSVBtag)) 
        else:
            return frfits.lowpt_mu_fr[ledleptonId](muonJetPt=max(row.mJetPt, row.mPt), muonPt=row.mPt, muonJetCSVBtag=max(0, row.mJetCSVBtag)) 

    def obj2_weight(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        if mu17e8:
            return frfits.lowpt_e_fr[subledleptonId](electronJetPt=max(row.eJetPt, row.ePt), electronPt=row.ePt) 
        else:
            return frfits.highpt_e_fr[subledleptonId](electronJetPt=max(row.eJetPt, row.ePt), electronPt=row.ePt)

    def obj3_weight(self, row, notUsed1=None, notUsed2=None):
        return frfits.tau_fr(row.tPt)

    def obj1_qcd_weight(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        if mu17e8:
            return frfits.highpt_mu_qcd_fr[ledleptonId](muonJetPt=max(row.mJetPt, row.mPt), muonPt=row.mPt, muonJetCSVBtag=max(0, row.mJetCSVBtag))
        else:
            return frfits.lowpt_mu_qcd_fr[ledleptonId](muonJetPt=max(row.mJetPt, row.mPt), muonPt=row.mPt, muonJetCSVBtag=max(0, row.mJetCSVBtag))

    def obj2_qcd_weight(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        if mu17e8:
            return frfits.lowpt_e_qcd_fr[subledleptonId](electronJetPt=max(row.eJetPt, row.ePt), electronPt=row.ePt)
        else:
            return frfits.highpt_e_qcd_fr[subledleptonId](electronJetPt=max(row.eJetPt, row.ePt), electronPt=row.ePt)

    def obj3_qcd_weight(self, row, notUsed1=None, notUsed2=None):
        return frfits.tau_qcd_fr(row.tPt)

    # For measuring charge flip probability
    # Not really used in this channel
    def obj1_obj3_SS(self, row):
        return row.m_t_SS

    ## def obj1_charge_flip(self, row):
    ##     return 0

    def obj2_charge_flip(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        if ledleptonId.startswith('lead4muon_'):
            ledleptonId = subledleptonId
            subledleptonId = subledleptonId 
        return frfits.e_charge_flip[ledleptonId](row.eAbsEta,row.ePt) \
            if row.ePt > row.mPt else \
            frfits.e_charge_flip[subledleptonId](row.eAbsEta,row.ePt)

    def obj2_charge_flip_sysup(self, row, ledleptonId='h2taucuts', subledleptonId='h2taucuts'):
        if ledleptonId.startswith('lead4muon_'):
            ledleptonId = subledleptonId
            subledleptonId = subledleptonId 
        return frfits.e_charge_flip_up[ledleptonId](row.eAbsEta,row.ePt) \
            if row.ePt > row.mPt else \
            frfits.e_charge_flip_up[subledleptonId](row.eAbsEta,row.ePt) \
