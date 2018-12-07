
import rootpy.plotting.views as views
import rootpy.io as io
import rootpy.plotting as plotting
import ROOT
import os

def relative_to_bin1(hist):
    ret = hist.Clone()
    binx= ret.GetNbinsX()
    bin1= ret.GetBinContent(1)
    for i in range(binx):
        try:
            ret.SetBinContent(i+1,
                              ret.GetBinContent(i+1) / bin1)
        except ZeroDivisionError:
            raise ZeroDivisionError("bin %s is empty" % i)
    return ret

def relative_to_previous(hist):
    ret      = hist.Clone()
    binx     = ret.GetNbinsX()
    previous = ret.GetBinContent(1)
    for i in range(binx):
        current = ret.GetBinContent(i+1)
        ratio   = current / previous if previous > 0 else 0.
        ret.SetBinContent(i+1,
                          ratio)
        previous = current
    return ret

def relative_to(hist, bin_label):
    ret   = hist.Clone()
    binx  = ret.GetNbinsX()
    label = [ i for i in range(binx) if ret.GetXaxis().GetBinLabel(i+1) == bin_label][0]
    bin1  = ret.GetBinContent(label+1)
    for i in range(binx):
        content = ret.GetBinContent(i+1) / bin1
        content = content if content <= 1 else 0.
        ret.SetBinContent(i+1,
                          content)
    return ret

postfix = '_TEST_'

ROOT.gStyle.SetPaintTextFormat('.2g')
jobid    = os.environ['jobid']
channels = ['eet', 'emt', 'mmt']

public   = os.environ['pub']
chan_hists = {}
for ch, color in zip(channels, ['darkgreen','blue','red']):
    view = views.TitleView(
        views.StyleView(
            views.SumView(
                #                io.open('results/%s/WHAnalyze%s/VH_120_HWW.root' % (jobid, ch.upper()) ),
                io.open('results/%s/WHAnalyze%s/VH_H2Tau_M-120.root' % (jobid, ch.upper()) )
                ),
            drawstyle = 'hist TEXT00',
            linecolor = color,
            linewidth = 2,
            fillstyle = 'hollow',
            legendstyle = 'l',
            ),
        ch
        )
    chan_hists[ch] = view.Get('ss/CUT_FLOW')
    chan_hists[ch].SetLabelSize(0.035)

canvas   = plotting.Canvas(name='adsf', title='asdf')
canvas.SetGridx(True)
canvas.SetGridy(True)
canvas.SetLogy(True)
legend = plotting.Legend(len(channels), rightmargin=0.07, topmargin=0.05, leftmargin=0.45)
legend.SetEntrySeparation(0.0)
legend.SetMargin(0.35)

for graph in chan_hists.itervalues():
    legend.AddEntry(graph)

ymax = max([i.GetBinContent(1) for i in chan_hists.itervalues()])
for i, hist in enumerate(chan_hists.itervalues()):
    drawattr = '' if i == 0 else 'same'
    hist.GetYaxis().SetRangeUser(50, ymax*2)
    hist.Draw(drawattr)
legend.Draw()

canvas.Print(os.path.join(public,'bare_cut_flow%s.png' % postfix) )

to_keep = []
for i, h in enumerate(chan_hists.itervalues()):
    hist = relative_to_bin1(h)
    to_keep.append(hist)
    drawattr = '' if i == 0 else 'same'
    hist.GetYaxis().SetRangeUser(10**-3, 1.5)
    hist.Draw(drawattr)
legend.Draw()

canvas.Print(os.path.join(public,'relative_cut_flow%s.png' % postfix) )

to_keep  = []
canvas.SetLogy(False)
for i, h in enumerate(chan_hists.itervalues()):
    hist = relative_to_previous(h)
    to_keep.append(hist)
    drawattr = '' if i == 0 else 'same'
    hist.GetYaxis().SetRangeUser(0., 1.5)
    hist.Draw(drawattr)
legend.Draw()

canvas.Print(os.path.join(public,'relative_to_previous_cut_flow%s.png' % postfix) )

## to_keep  = []
## canvas.SetLogy(True)
## for i, h in enumerate(chan_hists.itervalues()):
##     hist = relative_to(h, 'obj3 GenMatching')
##     to_keep.append(hist)
##     drawattr = '' if i == 0 else 'same'
##     hist.GetYaxis().SetRangeUser(4*10**-2, 1.5)
##     hist.Draw(drawattr)
## legend.Draw()

## canvas.Print(os.path.join(public,'relative_to_MCMatched_cut_flow.png') )
