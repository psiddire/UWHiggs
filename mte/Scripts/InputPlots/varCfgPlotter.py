### File to store all of the configurations for the
### LFV H prefit/prefit plotter

from collections import OrderedDict

# Provide the category names (folder names)
def getCategories( channel="et", prefix="" ) :
    categories = ["_1_", "_2_", "_3_", "_4_"]
    categories[0] = "0jet"
    categories[1] = "1jet"
    categories[2] = "2jet_gg"
    categories[3] = "2jet_vbf"
    return categories

# Provide standard mapping to our files
# this can be overridden with --inputFile
def getFile( channel ) :
    fileMap = {
        "et" : "shapesETBDT.root",
        "mt" : "shapesMTBDT.root",
        "em" : "shapesEMuBDTQCD.root",
        "me" : "shapesMuEBDTQCD.root",
    }
    return fileMap[ channel ]

def getInfoMap( higgsSF, channel, shift="" ) :
    if channel == "mt" : sub = ("h", "#mu") 
    if channel == "et" : sub = ("h", "e")
    if channel == "em" : sub = ("e", "#mu")
    if channel == "me" : sub = ("#mu", "e")
    
    infoMap = OrderedDict()
    # Name : Add these shapes [...], legend name, leg type, fill color
    infoMap["data_obs"] = [["data_obs",], "Observed", "elp", 1]
    infoMap["ZTT"] = [["ZTauTau"+shift],"Z#rightarrow#tau#tau", "f", "#ffcc66"]
    infoMap["ZJ"] = [["Zothers"+shift],"Z#rightarrowee/#mu#mu", "f", "#4496c8"]
    infoMap["TT"] = [["TT"+shift, "T"+shift], "t#bar{t},t+jets", "f", "#9999cc"]
    infoMap["EWK"] = [["EWK"+shift], "EWKW/Z", "f", "#32cd32"]
    infoMap["Diboson"] = [["Diboson"+shift], "Diboson", "f", "#12cadd"]
    if channel=="et" or channel=="mt":
       infoMap["QCD"] = [["Fakes",], "W+Jets/QCD", "f", "#ffccff"]
    if channel == "me" or channel=="em":
       infoMap["QCD"] = [["QCD", "W"+shift], "W+Jets/QCD", "f", "#ffccff"]
    infoMap["SMH"] = [["ggH_htt"+shift, "qqH_htt"+shift, "ggH_hww"+shift, "qqH_hww"+shift], "SM Higgs", "f", "#c243cd"]	
    if channel=="em" or channel=="et":
       infoMap["H125"] = [["LFVGG125"+shift, "LFVVBF125"+shift], "H#rightarrowe#tau (B=%i%%)"%higgsSF, "l", "#111bbb"]
    elif channel=="me" or channel=="mt":
       infoMap["H125"] = [["LFVGG125"+shift, "LFVVBF125"+shift], "H#rightarrow#mu#tau (B=%i%%)"%higgsSF, "l", "#111bbb"]
    return infoMap

def getBackgrounds(channel) :
    if channel=="em" or channel=="me":    
       bkgs=["QCD", "SMH", "EWK", "Diboson", "TT", "ZTT", "ZJ"]
       return bkgs
    if channel=="et" or channel=="mt":
       bkgs=["QCD", "SMH", "EWK", "Diboson", "TT", "ZJ", "ZTT"]
       return bkgs

def getSignals() :
    signals=["H125"]
    return signals

