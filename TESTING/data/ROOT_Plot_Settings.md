Below is a compact **PyROOT publication-style template**. It centralizes the most useful ROOT drawing settings: canvas, margins, fonts, axes, ticks, legends, histograms, lines, markers, palettes, and PDF/SVG export.

```python
#!/usr/bin/env python3

import ROOT

def set_root_style():
    """
    Publication-style ROOT plotting defaults.
    Call once at the beginning of your script.
    """

    ROOT.gROOT.SetBatch(True)   # no GUI windows, useful for scripts

    style = ROOT.TStyle("PubStyle", "Publication-quality ROOT style")

    # ------------------------------------------------------------
    # Canvas and pads
    # ------------------------------------------------------------
    style.SetCanvasColor(0)
    style.SetCanvasBorderMode(0)
    style.SetCanvasDefW(800)
    style.SetCanvasDefH(650)

    style.SetPadColor(0)
    style.SetPadBorderMode(0)
    style.SetPadTopMargin(0.06)
    style.SetPadBottomMargin(0.14)
    style.SetPadLeftMargin(0.16)
    style.SetPadRightMargin(0.06)

    # For 2D COLZ plots, increase right margin manually later.
    # c.SetRightMargin(0.16)

    # ------------------------------------------------------------
    # Backgrounds
    # ------------------------------------------------------------
    style.SetFrameFillColor(0)
    style.SetFrameBorderMode(0)
    style.SetFrameLineWidth(1)

    # ------------------------------------------------------------
    # Fonts
    # ROOT font 42 = Helvetica-like, good default for publications
    # ------------------------------------------------------------
    font = 42
    style.SetTextFont(font)
    style.SetLabelFont(font, "XYZ")
    style.SetTitleFont(font, "XYZ")
    style.SetLegendFont(font)
    style.SetStatFont(font)

    # ------------------------------------------------------------
    # Text sizes
    # ------------------------------------------------------------
    style.SetTextSize(0.045)
    style.SetTitleSize(0.050, "XYZ")
    style.SetLabelSize(0.045, "XYZ")

    # Axis title offsets
    style.SetTitleOffset(1.25, "X")
    style.SetTitleOffset(1.45, "Y")
    style.SetTitleOffset(1.25, "Z")

    # ------------------------------------------------------------
    # Axis ticks and divisions
    # ------------------------------------------------------------
    style.SetPadTickX(1)
    style.SetPadTickY(1)

    style.SetNdivisions(510, "X")
    style.SetNdivisions(510, "Y")
    style.SetNdivisions(510, "Z")

    style.SetTickLength(0.025, "X")
    style.SetTickLength(0.025, "Y")

    # ------------------------------------------------------------
    # Lines, markers, histograms
    # ------------------------------------------------------------
    style.SetHistLineWidth(2)
    style.SetLineWidth(2)

    style.SetMarkerStyle(20)
    style.SetMarkerSize(1.0)

    # Remove default histogram title and statistics box
    style.SetOptTitle(0)
    style.SetOptStat(0)
    style.SetOptFit(0)

    # ------------------------------------------------------------
    # Legends
    # ------------------------------------------------------------
    style.SetLegendBorderSize(0)
    style.SetLegendFillColor(0)
    style.SetLegendTextSize(0.040)

    # ------------------------------------------------------------
    # Color palette for 2D histograms
    # ------------------------------------------------------------
    style.SetPalette(ROOT.kViridis)

    # ------------------------------------------------------------
    # Numeric formatting
    # ------------------------------------------------------------
    style.SetStripDecimals(True)

    # Apply style globally
    ROOT.gROOT.SetStyle("PubStyle")
    ROOT.gROOT.ForceStyle()


def save_canvas(canvas, basename):
    """
    Save figures in vector and raster formats.
    """
    canvas.SaveAs(f"{basename}.pdf")
    canvas.SaveAs(f"{basename}.svg")
    canvas.SaveAs(f"{basename}.png")


# ----------------------------------------------------------------
# Example 1: 1D histogram
# ----------------------------------------------------------------

def plot_mu_decay_time(filename="musr_0.root"):
    set_root_style()

    df = ROOT.RDataFrame("t1", filename)

    h = df.Histo1D(
        (
            "h_muDecayTime",
            "Muon decay time;Decay time [ns];Events",
            200,
            0,
            10000,
        ),
        "muDecayTime",
    )

    c = ROOT.TCanvas("c_muDecayTime", "c_muDecayTime", 800, 650)
    c.SetGrid(False)

    hist = h.GetValue()
    hist.SetLineColor(ROOT.kBlack)
    hist.SetLineWidth(2)
    hist.SetFillStyle(0)

    hist.GetXaxis().CenterTitle(False)
    hist.GetYaxis().CenterTitle(False)

    hist.Draw("HIST")

    save_canvas(c, "muDecayTime")


# ----------------------------------------------------------------
# Example 2: 2D histogram
# ----------------------------------------------------------------

def plot_decay_xy(filename="musr_0.root"):
    set_root_style()

    df = ROOT.RDataFrame("t1", filename)

    h2 = df.Histo2D(
        (
            "h_muDecayXY",
            "Muon decay position;x [mm];y [mm]",
            200,
            -100,
            100,
            200,
            -100,
            100,
        ),
        "muDecayPosX",
        "muDecayPosY",
    )

    c = ROOT.TCanvas("c_muDecayXY", "c_muDecayXY", 800, 700)

    # Needed for color-bar space
    c.SetRightMargin(0.16)
    c.SetLeftMargin(0.14)
    c.SetBottomMargin(0.13)

    hist = h2.GetValue()
    hist.GetZaxis().SetTitle("Events")
    hist.GetZaxis().SetTitleOffset(1.25)

    hist.Draw("COLZ")

    save_canvas(c, "muDecayXY")


# ----------------------------------------------------------------
# Example 3: overlay two histograms
# ----------------------------------------------------------------

def plot_overlay(filename="musr_0.root"):
    set_root_style()

    df = ROOT.RDataFrame("t1", filename)

    df2 = (
        df
        .Define("muIniR", "sqrt(muIniPosX*muIniPosX + muIniPosY*muIniPosY)")
        .Define("muDecayR", "sqrt(muDecayPosX*muDecayPosX + muDecayPosY*muDecayPosY)")
    )

    h_ini = df2.Histo1D(
        ("h_muIniR", "Muon radial position;r [mm];Normalized events", 150, 0, 100),
        "muIniR",
    )

    h_dec = df2.Histo1D(
        ("h_muDecayR", "Muon radial position;r [mm];Normalized events", 150, 0, 100),
        "muDecayR",
    )

    c = ROOT.TCanvas("c_overlay", "c_overlay", 800, 650)

    h1 = h_ini.GetValue()
    h2 = h_dec.GetValue()

    if h1.Integral() > 0:
        h1.Scale(1.0 / h1.Integral())
    if h2.Integral() > 0:
        h2.Scale(1.0 / h2.Integral())

    h1.SetLineColor(ROOT.kBlack)
    h1.SetLineWidth(2)

    h2.SetLineColor(ROOT.kRed + 1)
    h2.SetLineWidth(2)
    h2.SetLineStyle(2)

    h1.SetMaximum(1.15 * max(h1.GetMaximum(), h2.GetMaximum()))

    h1.Draw("HIST")
    h2.Draw("HIST SAME")

    leg = ROOT.TLegend(0.60, 0.72, 0.88, 0.88)
    leg.AddEntry(h1, "Initial", "l")
    leg.AddEntry(h2, "Decay", "l")
    leg.Draw()

    save_canvas(c, "muon_radius_overlay")


if __name__ == "__main__":
    plot_mu_decay_time("musr_0.root")
    plot_decay_xy("musr_0.root")
    plot_overlay("musr_0.root")
```

## The most important ROOT style controls

For publication plots, these are the settings you will adjust most often:

```python
ROOT.gStyle.SetOptStat(0)          # remove statistics box
ROOT.gStyle.SetOptTitle(0)         # remove automatic title
ROOT.gStyle.SetPadTickX(1)         # ticks on top
ROOT.gStyle.SetPadTickY(1)         # ticks on right
ROOT.gStyle.SetPalette(ROOT.kViridis)
```

Canvas and margins:

```python
c = ROOT.TCanvas("c", "c", 800, 650)
c.SetLeftMargin(0.16)
c.SetRightMargin(0.06)
c.SetBottomMargin(0.14)
c.SetTopMargin(0.06)
```

For 2D plots with color bar:

```python
c.SetRightMargin(0.16)
```

Axis labels and titles:

```python
h.GetXaxis().SetTitle("x [mm]")
h.GetYaxis().SetTitle("Counts")

h.GetXaxis().SetTitleSize(0.050)
h.GetYaxis().SetTitleSize(0.050)

h.GetXaxis().SetLabelSize(0.045)
h.GetYaxis().SetLabelSize(0.045)

h.GetXaxis().SetTitleOffset(1.20)
h.GetYaxis().SetTitleOffset(1.45)
```

Line and marker style:

```python
h.SetLineColor(ROOT.kBlack)
h.SetLineWidth(2)
h.SetLineStyle(1)

h.SetMarkerStyle(20)
h.SetMarkerSize(1.0)
h.SetMarkerColor(ROOT.kBlack)
```

Legend:

```python
leg = ROOT.TLegend(0.60, 0.72, 0.88, 0.88)
leg.SetBorderSize(0)
leg.SetFillStyle(0)
leg.SetTextSize(0.040)
leg.AddEntry(h, "Simulation", "l")
leg.Draw()
```

Export:

```python
c.SaveAs("figure.pdf")   # best for documents
c.SaveAs("figure.svg")   # useful for editing in Inkscape
c.SaveAs("figure.png")   # quick preview
```

My practical recommendation: use **ROOT for fast diagnostic plots**, but for final publication figures, consider exporting the reduced quantities to NumPy and plotting with `matplotlib`. ROOT can produce publication-quality figures, but matplotlib usually gives finer control with less frustration.

