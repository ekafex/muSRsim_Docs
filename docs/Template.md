# Complete muSRSim Macro Template

Save as, for example:

```text
run_muSR_template.mac
```

```text
############################################################
# 0. GENERAL INITIALIZATION
############################################################

/control/verbose 1
/run/verbose 1
/tracking/verbose 0


############################################################
# 1. GEOMETRY
############################################################
# Put your geometry definition here, or call another macro:
#
# /control/execute geometry.mac
#
# Example:
# - world volume
# - sample
# - detectors
# - shielding
# - collimators
#
# IMPORTANT:
# Sensitive detector commands below must use the correct
# logical volume names from your geometry.


############################################################
# 2. PHYSICS CONFIGURATION
############################################################
# Physics in muSRSim is configured by attaching processes
# to particles using /musr/command process ...
#
# General syntax:
# /musr/command process addProcess particle process ordAtRest ordAlongStep ordPostStep
#
# Meaning:
# -1  = process inactive in that stage
#  0+ = process active; smaller number means earlier priority
#
# Example:
# /musr/command process addProcess mu+ G4StepLimiter -1 -1 5
#
# means:
# - not active when particle is at rest
# - not active continuously along the step
# - active after each step with priority 5


# --- Gamma processes ---
/musr/command process addDiscreteProcess gamma G4PhotoElectricEffect
/musr/command process addDiscreteProcess gamma G4ComptonScattering
/musr/command process addDiscreteProcess gamma G4GammaConversion


# --- Positron processes ---
# Important because mu+ decay produces e+
/musr/command process addProcess e+ G4eMultipleScattering -1 1 1
/musr/command process addProcess e+ G4eIonisation        -1 2 2
/musr/command process addProcess e+ G4eBremsstrahlung    -1 3 3
/musr/command process addProcess e+ G4eplusAnnihilation   0 -1 4


# --- Electron processes ---
# Useful if secondary electrons are relevant
/musr/command process addProcess e- G4eMultipleScattering -1 1 1
/musr/command process addProcess e- G4eIonisation        -1 2 2
/musr/command process addProcess e- G4eBremsstrahlung    -1 3 3


# --- Muon processes ---
/musr/command process addProcess mu+ G4MuMultipleScattering -1 1 1
/musr/command process addProcess mu+ G4MuIonisation         -1 2 2
/musr/command process addProcess mu+ G4MuBremsstrahlung     -1 3 3
/musr/command process addProcess mu+ G4MuPairProduction     -1 4 4


# --- Optional: step limiter ---
# Needed if you use SetUserLimits or need better precision
# in thin volumes, detectors, foils, or strong fields.
/musr/command process addProcess mu+ G4StepLimiter -1 -1 5
/musr/command process addProcess e+  G4StepLimiter -1 -1 5
/musr/command process addProcess e-  G4StepLimiter -1 -1 5


# --- Production cuts ---
/musr/command process cutForGamma 0.1
/musr/command process cutForElectron 0.1


############################################################
# 3. OPTIONAL USER LIMITS
############################################################
# Use only if needed.
#
# Syntax:
# /musr/command SetUserLimits logicalVolume ustepMax utrakMax utimeMax uekinMin urangMin
#
# Example for a target:
# /musr/command SetUserLimits log_Target 0.1 1000 10000 0 0
#
# Here:
# ustepMax = maximum step length
# utrakMax = maximum track length
# utimeMax = maximum track time
# uekinMin = minimum kinetic energy
# urangMin = minimum range


############################################################
# 4. PRIMARY PARTICLE / BEAM
############################################################

# Primary particle
/gun/primaryparticle mu+

# Initial position
/gun/vertex 0 0 -100 mm

# Beam spot size
# Positive values = Gaussian sigma
# Zero = no smearing
# Negative values = uniform distribution
/gun/vertexsigma 2 2 0 mm

# Direction
/gun/direction 0 0 1

# Beam momentum
/gun/momentum 28 MeV/c

# Muon spin polarization
/gun/muonPolarizVector 0 0 1
/gun/muonPolarizFraction 1


############################################################
# 5. SENSITIVE DETECTORS
############################################################
# Replace these logical volume names by your own.
#
# Typical detector ID convention:
# 11 = forward detector
# 12 = backward detector
# 13 = left detector
# 14 = right detector

/geom/volume/setSensitive log_DetectorForward  11
/geom/volume/setSensitive log_DetectorBackward 12

# Optional:
# /geom/volume/setSensitive log_DetectorLeft  13
# /geom/volume/setSensitive log_DetectorRight 14


############################################################
# 6. EVENT FILTERING
############################################################
# Store only events that hit detector 11 or 12.

/musr/onlyStoreEventsWithHits 11
/musr/onlyStoreEventsWithHits 12

# For debugging, you may instead store everything:
# /musr/storeAllEvents


############################################################
# 7. ROOT OUTPUT
############################################################

/musr/setRootOutput true
/musr/setRootOutputDirectoryName data
/musr/setRootOutputFileName run_muSR_template


############################################################
# 8. VISUALIZATION
############################################################

/vis/open OGLIQt 1000x800-0+0
/vis/drawVolume
/vis/viewer/set/style wireframe
/vis/viewer/set/background black
/vis/viewer/set/viewpointThetaPhi 70 20 deg
/vis/scene/add/axes 0 0 0 100 mm

# Event visualization
/vis/scene/endOfEventAction accumulate
/vis/scene/add/trajectories smooth
/vis/modeling/trajectories/create/drawByParticleID
/vis/scene/add/hits

/vis/viewer/flush


############################################################
# 9. INITIALIZE AND RUN
############################################################

/run/initialize

/run/beamOn 1000
```

---

# How to use this template

The most important parts to adapt are:

```text
/geom/volume/setSensitive log_DetectorForward  11
/geom/volume/setSensitive log_DetectorBackward 12
```

The names `log_DetectorForward` and `log_DetectorBackward` must match your actual **logical volume names**.

If your geometry uses, for example:

```text
log_FrontScint
log_BackScint
```

then use:

```text
/geom/volume/setSensitive log_FrontScint 11
/geom/volume/setSensitive log_BackScint  12
```

---

# Minimal first test

Before running many events, test with:

```text
/run/beamOn 10
```

If this works, then increase to:

```text
/run/beamOn 1000
```

or more.

---

# Expected successful output

You should see something like:

```text
Root tree and branches were defined.
Root tree written out.
ERROR SUMMARY:
Number of events = ...
```

An empty `ERROR SUMMARY` is good.

---

# Most likely problems

## 1. Wrong sensitive volume name

Symptom:

```text
No ID number assigned to sensitive volume ...
```

Fix: check the logical volume name.

---

## 2. Empty ROOT file

Possible causes:

```text
/musr/onlyStoreEventsWithHits 11
```

but no particles reach detector 11.

For debugging, use:

```text
/musr/storeAllEvents
```

---

## 3. Tracks not visible

Make sure these are present:

```text
/vis/scene/add/trajectories smooth
/vis/scene/endOfEventAction accumulate
/run/beamOn 10
```

---

# Recommended workflow

First run:

```text
/run/beamOn 10
```

with visualization.

Then confirm:

* beam starts in the right place
* muons go in the right direction
* positron tracks appear after decay
* detector volumes are hit

Only after that enable strong filtering and large statistics.

