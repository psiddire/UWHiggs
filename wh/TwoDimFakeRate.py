'''

Implements a lookup of an efficiency in two dimensions.

Takes as arguments a path to a numerator, denominator, the data,
and any contaminating MC that should be subtracted.

    efficiency(x, y)

returns a tuple of (numerator, denominator, efficiency)

'''

from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView

class TwoDimFakeRate(object):
    def __init__(self, path_to_num, path_to_denom, data, *subtract_mc):
        self.corrected_data = SubtractionView(
            data, *subtract_mc, restrict_positive=True)
        #self.corrected_data = data
        self.num = self.corrected_data.Get(path_to_num)
        self.denom = self.corrected_data.Get(path_to_denom)

    def __call__(self, x, y):
        bin = self.num.FindBin(x, y)
        num = self.num.GetBinContent(bin)
        den = self.denom.GetBinContent(bin)
        return num/den if den else 0

    def plot(self, filename):
        import ROOT
        canvas = ROOT.TCanvas('asdf', 'asdf', 1200, 400)
        canvas.Divide(3)
        canvas.cd(1)
        ROOT.gPad.SetLogy(True)
        ROOT.gPad.SetLogx(True)
        ROOT.gStyle.SetPaintTextFormat("0.f")
        self.num.Draw('text')
        canvas.cd(2)
        ROOT.gPad.SetLogy(True)
        ROOT.gPad.SetLogx(True)
        self.denom.Draw('text')
        eff_percent = self.num.Clone()
        eff_percent.Divide(self.denom)
        eff_percent.Scale(100)
        ROOT.gStyle.SetPaintTextFormat("0.1f")
        canvas.cd(3)
        ROOT.gPad.SetLogy(True)
        ROOT.gPad.SetLogx(True)
        eff_percent.Draw('text')
        print "Saving TwoDimFakeRate control plots in %s" % filename
        canvas.SaveAs(filename)
