# Generic musrSim μSR Spectrometer Template

This package provides a clean starting point for a generic μSR spectrometer in musrSim:

- `template.mac` — main simulation template
- `vis.mac` — visualization settings
- `README.md` — usage notes and customization guide

This is a **skeleton template**, not a validated copy of a specific PSI instrument.

---

## 1. Geometry logic

The setup follows this layout:

```txt
beam --> M0 --> save plane --> collimator --> sample(Target)

around sample:
    forward bank   at +z
    backward bank  at -z
    veto planes    at ±x
```

Special musrSim names are used intentionally:

- `World` — required main mother volume
- `M0` — automatically stores `muM0Time`, `muM0Pol*`
- `Target` — automatically stores `muTargetTime`, `muTargetMom*`, `muTargetPol*`
- `saveBeamBeforeSample` — because the name begins with `save`, particle passage is recorded even without energy deposition

Sensitive detectors use:

```txt
musr/ScintSD
```

Passive material uses:

```txt
dead
```

---

## 2. What the template includes

### Geometry
- world
- beam pipe vacuum
- beam pipe wall
- upstream trigger detector `M0`
- beam diagnostic `save` plane
- simple collimator block
- sample holder
- sample `Target`
- forward detector bank
- backward detector bank
- left/right veto or auxiliary detectors

### Fields
- a simple uniform longitudinal magnetic field

### Physics
- a conservative starting set for `mu+` and `e+`

### Gun
- `mu+` beam
- finite beam spot
- momentum spread
- polarization

### Controls
- step/runtime protection
- event storage policy
- optional region cuts

### Visualization
- a separate macro to inspect the geometry cleanly

---

## 3. How to run it

### Option A — include from a numbered run macro

Create a numbered macro such as `1001.mac`:

```txt
/control/execute template_muSR_spectrometer.mac
```

Then run:

```bash
musrSim 1001.mac
```

### Option B — include visualization too

Create `1002.mac`:

```txt
/control/execute template_muSR_spectrometer.mac
/control/execute template_muSR_spectrometer_vis.mac
```

Then run:

```bash
musrSim 1002.mac
```

---

## 4. What to validate first

Before doing any real study, check these items:

### Geometry
- no overlap warnings
- all detector positions make sense
- sample and holder are where you expect

### Field
- confirm field at a few points with:

```txt
/musr/command globalfield printFieldValueAtPoint 0 0 0
```

### Output
- verify that `muM0*` and `muTarget*` are being filled
- verify detector IDs in the ROOT tree

### Detector hits
- inspect `det_ID[]`, `det_edep[]`, `det_time_start[]`

---

## 5. What to customize first

The usual first edits are:

### Sample
Change material and dimensions of `Target`.

Current example:

```txt
/musr/command construct tubs Target 0 5 7 0 360 G4_Cu 0 0 0 World norot dead 10
```

### Magnetic field
Change the field magnitude in:

```txt
/musr/command globalfield BzMain 300 300 300 uniform 0 0 0 World 0 0 0.03 0 0 0
```

This corresponds to 0.03 T along `+z`.

### Beam
Change start point, beam spot, momentum, and polarization:

```txt
/gun/vertex 0 0 -500 mm
/gun/vertexsigma 5 5 0 mm
/gun/momentum 28 MeV
/gun/momentumsmearing 1 MeV
/gun/muonPolarizVector 0 0 1
```

### Detector positions
Edit the forward/backward/veto bank positions and IDs.

---

## 6. Important caveats

### The collimator hole is only a placeholder

This line:

```txt
/musr/command construct box CollimatorHoleGuide 5 10 16 Vacuum 0 0 -120 World norot dead 111
```

is **not** a true subtraction solid. It only gives you a logical vacuum guide region. If you need a real geometric aperture, replace the simple block with one of the musrSim-supported custom solids where appropriate.

### Half-length convention

Most dimensions are Geant4-style half-lengths.

### Mother-before-daughter order matters

Always define the mother volume before volumes placed inside it.

---

## 7. Suggested next upgrades

Once this template runs cleanly, the next sensible upgrades are:

1. Replace the placeholder collimator with a proper custom solid
2. Introduce more realistic detector segmentation
3. Add `M1` / `M2` trigger volumes if needed
4. Refine local production cuts near the sample
5. Add a field map instead of a uniform field
6. Add optical photon simulation only after the basic geometry works

---

## 8. Minimal ROOT sanity checks

After a run, in ROOT:

```cpp
TFile *f = new TFile("data/musr_1001.root");
t1->Print();
t1->Draw("det_edep","det_ID==20");
t1->Draw("muTargetTime");
t1->Draw("muM0Time");
```

Adjust the ROOT filename to your actual run number and musrSim naming convention.

---

## 9. Recommended workflow

1. Run with visualization and very few events
2. Fix geometry issues first
3. Check field values second
4. Check ROOT branches third
5. Only then increase statistics

This order prevents wasting time on long runs with a broken geometry or wrong field orientation.
