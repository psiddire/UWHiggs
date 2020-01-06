      if self.is_embed:                                                                                                                                                            
        tID = 0.97                                                                                                                                                                 
        if row.tDecayMode == 0:                                                                                                                                                    
          dm = 0.975                                                                                                                                                               
        elif row.tDecayMode == 1:                                                                                                                                                  
          dm = 0.975*1.051                                                                                                                                                         
        elif row.tDecayMode == 10:                                                                                                                                                 
          dm = pow(0.975, 3)                                                                                                                                                       
        msel = self.EmbedId(myMuon.Pt(), myMuon.Eta())                                                                                                                             
        tsel = self.EmbedId(myTau.Pt(), myTau.Eta())                                                                                                                               
        trgsel = self.EmbedTrg(myMuon.Pt(), myMuon.Eta(), myTau.Pt(), myTau.Eta())                                                                                                 
        self.w1.var("m_pt").setVal(myMuon.Pt())                                                                                                                                    
        self.w1.var("m_eta").setVal(myMuon.Eta())                                                                                                                                  
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)                                                                                                                     
        m_id_sf = self.w1.function("m_id_data").getVal()/self.w1.function("m_id_emb").getVal()                                                                                     
        #m_iso_sf = self.w1.function("m_iso_data").getVal()/self.w1.function("m_iso_emb").getVal()                                                                                 
        if self.obj1_tight(row):                                                                                                                                                   
          m_iso_sf = self.w1.function("m_iso_data").getVal()                                                                                                                       
        else:                                                                                                                                                                      
          m_iso_sf = self.w1.function("m_looseiso_data").getVal()                                                                                                                  
        m_trk_sf = self.muTracking(myMuon.Eta())[0]                                                                                                                                
        #m_trg_sf = self.w1.function("m_trg_data").getVal()/self.w1.function("m_trg_emb").getVal()                                                                                 
        weight = row.GenWeight*tID*dm*msel*tsel*trgsel*m_trg_sf*m_id_sf*m_iso_sf*m_trk_sf*self.EmbedPt(myMuon.Pt(), njets, mjj)                                                    
        weight = self.mcWeight.lumiWeight(weight)                                                                                                                                  
