# -*- coding: utf-8 -*-
"""
Created on Sat May 2 09:05:10 2026

@author: drago
"""

#import ROOT
#
#fname = "musr_0.root"
#
#with ROOT.TFile.Open(fname) as f:
#    tree = f.Get("t1")
#    #print(tree)
#    #print(tree.Print())
#    #print('Num. entries: ', tree.GetEntries())
#    #for bra in tree.GetListOfBranches():
#    #    print(bra.GetName())
#    for event in tree:
#        print(event.det_n, event.det_ID, event.det_edep)


# =====================================================

out = {
 "BFieldAtDecay.B3", "BFieldAtDecay.B4", "BFieldAtDecay.B5", "BFieldAtDecay.Bx", 
 "BFieldAtDecay.By", "BFieldAtDecay.Bz", "det_ID", "det_VrtxKine", "det_VrtxParticleID", 
 "det_VrtxProcID", "det_VrtxTrackID", "det_VrtxVolID", "det_VrtxX", "det_VrtxY", 
 "det_VrtxZ", "det_VvvKine", "det_VvvParticleID", "det_VvvProcID", "det_VvvTrackID", 
 "det_VvvVolID", "det_VvvX", "det_VvvY", "det_VvvZ", "det_edep", "det_edep_el", 
 "det_edep_gam", "det_edep_mup", "det_edep_pos", "det_kine", "det_length", "det_n", 
 "det_nsteps", "det_time_end", "det_time_start", "det_x", "det_y", "det_z", "eventID", 
 "fieldNomVal", "muDecayDetID", "muDecayPolX", "muDecayPolY", "muDecayPolZ", 
 "muDecayPosX", "muDecayPosY", "muDecayPosZ", "muDecayTime", "muIniMomX", "muIniMomY", 
 "muIniMomZ", "muIniPolX", "muIniPolY", "muIniPolZ", "muIniPosX", "muIniPosY", 
 "muIniPosZ", "muIniTime", "muTargetMomX", "muTargetMomY", "muTargetMomZ", 
 "muTargetPolX", "muTargetPolY", "muTargetPolZ", "muTargetTime", "nFieldNomVal", 
 "posIniMomX", "posIniMomY", "posIniMomZ", "runID", "timeToNextEvent", "weight" 
 }

import ROOT

ROOT.EnableImplicitMT()   # optional: use multiple CPU cores
#print(ROOT.GetThreadPoolSize())

df = ROOT.RDataFrame("t1", "musr_0.root")

#print(df.GetColumnNames())
#for name in df.GetColumnNames():
#    print(name)


#h = df.Histo1D(("h_Ek", ";T [MeV];Counts", 300, 0, 4), "det_kine")
# c = ROOT.TCanvas()
# h.Draw()
# c.SaveAs("Kenergy.pdf")


# ===========================================
#h = df.Histo1D(
#    ("h_muDecayTime", "Muon decay time;time [ns];Counts", 200, 0, 10000),
#    "muDecayTime"
#)
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("muDecayTime.pdf")

# ===========================================

#h2 = df.Histo2D(("h_decay_xy", "Muon decay position;x [mm];y [mm]",
#     200, -20, 20, 200, -20, 20),"muDecayPosX","muDecayPosY")
#c = ROOT.TCanvas()
#h2.Draw("COLZ")
#c.SaveAs("muDecayXY.pdf")

# ===========================================

#df2 = df.Define("muIniMom",
#    "sqrt(muIniMomX*muIniMomX + muIniMomY*muIniMomY + muIniMomZ*muIniMomZ)")
#h = df2.Histo1D(("h_muIniMom", "Initial muon momentum;p [MeV/c];Counts", 200, 20, 30),"muIniMom")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("muIniMom.pdf")

# ===========================================

#df2 = df.Define("muIniR","sqrt(muIniPosX*muIniPosX + muIniPosY*muIniPosY)")
#df2 = df2.Define("muDecayR","sqrt(muDecayPosX*muDecayPosX + muDecayPosY*muDecayPosY)")
#h = df2.Histo1D(("h_muDecayR", "Muon decay radius;r [mm];Counts", 200, 0, 30),"muDecayR")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("muDecayR.pdf")

# ===========================================

#h2 = df.Histo2D(("h_det_xy", "Detector hit positions;x [mm];y [mm]",
#     200, -20, 20, 200, -20, 20),"det_x","det_y")
#c = ROOT.TCanvas()
#h2.Draw("COLZ")
#c.SaveAs("detXY.pdf")

# ===========================================

#h = df.Histo1D(("h_det_edep", "Detector energy deposition;E_{dep} [MeV];Counts",200, 0, 2),"det_edep")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("detEdep.pdf")

# ===========================================

#h = df.Histo1D(("h_det_ID", "Detector ID;detector ID;Counts",100, 99, 104),"det_ID")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("detID.pdf")

# ===========================================
# ===========================================

# FILTERING

## events where at least one hit occurred in detector 103.
#df_det103_events = df.Filter("ROOT::VecOps::Any(det_ID == 103)")
#h = df_det103_events.Histo1D(("h_det103_edep", "Energy deposition in detector 103;E_{dep} [MeV];Counts",
#     200, 0, 2),"det_edep")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("det103_edep.pdf")

# ===========================================

## get only the detector-103 hit quantities, define masked vectors
#df103 = (
#    df
#    .Define("mask103", "det_ID == 103")
#    .Define("det103_x", "det_x[mask103]")
#    .Define("det103_y", "det_y[mask103]")
#    .Define("det103_z", "det_z[mask103]")
#    .Define("det103_edep", "det_edep[mask103]")
#    .Define("det103_t_start", "det_time_start[mask103]")
#)
#
#h = df103.Histo1D(
#    ("h_det103_edep", "Energy deposition in detector 103;E_{dep} [MeV];Counts",
#     200, 0, 0.5),"det103_edep")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("det103a_edep.pdf")
#
#h2 = df103.Histo2D(("h_det103_xy", "Detector 103 hit positions;x [mm];y [mm]",
#     200, -20, 20, 200, -20, 20),"det103_x","det103_y")
#c = ROOT.TCanvas()
#h2.Draw("COLZ")
#c.SaveAs("det103_xy.pdf")

# ===========================================

#df2 = df.Define("det_r","sqrt(det_x*det_x + det_y*det_y)")
#h = df2.Histo1D(("h_det_r", "Detector hit radius;r [mm];Counts",
#     200, 0, 30),"det_r")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("det_r.pdf")

# ===========================================

#df101 = (
#    df
#    .Define("mask101", "det_ID == 101")
#    .Define("det101_x", "det_x[mask101]")
#    .Define("det101_y", "det_y[mask101]")
#    .Define("det101_r", "sqrt(det101_x*det101_x + det101_y*det101_y)")
#)
#h = df101.Histo1D(("h_det101_r", "Detector 101 radial hit position;r [mm];Counts",
#     200, 0, 30), "det101_r")
#c = ROOT.TCanvas()
#h.Draw()
#c.SaveAs("det101_r.pdf")

# ===========================================
# ===========================================

# Coincidence-style checks

df_coin = df.Filter(
    "ROOT::VecOps::Any(det_ID == 101) && ROOT::VecOps::Any(det_ID == 102)"
)
h = df_coin.Histo1D(
    ("h_muDecayTime_coin", "Muon decay time with detector 101-102 coincidence;time [ns];Counts",
     200, 0, 20),"muDecayTime"
)

c = ROOT.TCanvas()
h.Draw()
c.SaveAs("muDecayTime_coin_101_102.pdf")

# Count events:
n_all = df.Count()
n_coin = df_coin.Count()

print("All events:", n_all.GetValue())
print("Coincidence events:", n_coin.GetValue())



















