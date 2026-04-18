# `musrSim` Macro Structure

## Big Picture

A musrSim macro defines a **complete simulation pipeline**:

```txt
Geometry → Fields → Physics → Gun → Limits → Detector Response → Event Filtering → Output

                ┌──────────────┐
                │   Geometry   │
                │   (Volumes)  │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │    Fields    │
                │  (B, E maps) │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │   Physics    │
                │ Interactions │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │     Gun      │
                │ Initial beam │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │   Limits     │
                │ Step control │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │   Detector   │
                │   Response   │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │ Event Filter │
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │   Output     │
                │   (ROOT)     │
                └──────────────┘
```

Each block is **independent and composable**.



# 1. Geometry (Volumes & Detectors)

## Purpose

Define **what exists physically**:

* shapes
* materials
* positions
* sensitive detectors

## Core command

```txt
/musr/command construct solid name dimensions 
    material x y z 
    motherVolume matrixName 
    sensitiveClass idNumber
```

## Key parameters

| Parameter        | Meaning                   |
| ---------------- | ------------------------- |
| `solid`          | shape (box, tubs, trd, …) |
| `material`       | Geant4 or custom          |
| `motherVolume`   | hierarchy                 |
| `matrixName`     | rotation                  |
| `sensitiveClass` | `dead` or `musr/ScintSD`  |
| `idNumber`       | detector ID               |

## Rotation

```txt
/musr/command rotation rot1 0 0 90
```

## Minimal example

```txt
# World
/musr/command construct box World 1000 1000 1000 G4_AIR 0 0 0 no logical volume norot dead 0

# Detector
/musr/command construct box det1 10 10 10 Scintillator 0 0 0 World norot musr/ScintSD 1
```



# 2. Fields

## Purpose

Define **electric/magnetic environment**

## Uniform field

```txt
/musr/command globalfield Bfield 
    50 50 50 uniform 
    0 0 0 logicalVolume 
    0 0 1 0 0 0
```

→ 1 Tesla in Z



## Field map

```txt
/musr/command globalfield Bmap 
    0 0 0 fromfile 
    3DB field.dat 
    logicalVolume 
    1.0
```

## Debug

```txt
/musr/command globalfield printFieldValueAtPoint 0 0 0
```



# 3. Physics

## Purpose

Define **interactions**

## Add process

```txt
/musr/command process addProcess particle process ord1 ord2 ord3
```

## Example

```txt
/musr/command process addProcess mu+ G4MuIonisation -1 -1 1
```

## Special μSR processes

```txt
/musr/command process addProcess mu+ musrMuFormation -1 -1 2
```



# 4. Primary Generation (Gun)

## Purpose

Define **initial particles**

## Basic setup

```txt
/gun/primaryparticle mu+
/gun/vertex 0 0 -100 mm
/gun/momentum 28 MeV
/gun/direction 0 0 1
```

## Beam spread

```txt
/gun/vertexsigma 5 5 0 mm
/gun/momentumsmearing 1 MeV
```

## Polarization

```txt
/gun/muonPolarizVector 0 0 1
```

## Alternative: GPS

```txt
/gps/particle ion
/gps/position 0 0 0
```



# 5. Simulation Engine (Limits & Controls)

## Purpose

Control **numerical behavior**

## Step limits

```txt
/musr/command SetUserLimits det1 1 mm 0 0 0 0
```

## Field accuracy

```txt
/musr/command globalfield setparameter SetLargestAcceptableStep 1 mm
```

## Kill particles

```txt
/musr/command killAllPositrons true
```

## Runtime limits

```txt
/musr/command maximumNrOfStepsPerTrack 10000
/musr/command maximumTimePerEvent 60
```



# 6. Detector Response

## Purpose

Model **how signals form**

## Hit merging (time resolution)

```txt
/musr/command signalSeparationTime 10 ns
```

## Optical photons

```txt
/musr/command G4OpticalPhotons true
```

## Material optical properties

```txt
/musr/command materialPropertiesTable MPT1 RINDEX 2 2.0 3.0 1.5 1.5
```



# 7. Event Filtering

## Purpose

Control **what events survive**

## Only events with hits

```txt
/musr/command storeOnlyEventsWithHits true
```

## Only specific detector

```txt
/musr/command storeOnlyEventsWithHitInDetID 11
```

## First hit only

```txt
/musr/command storeOnlyTheFirstTimeHit true
```

## Reweighting

```txt
/musr/command logicalVolumeToBeReweighted mu det1 10
```

---

# 8. Output (ROOT)

## Purpose

Control **what is saved**

## Run simulation

```txt
/run/beamOn 10000
```

## Output directory

```txt
/musr/command rootOutputDirectoryName data
```

## Disable variables

```txt
/musr/command rootOutput det_edep off
```



---



# Full Minimal Tutorial Example

## Realistic μSR Example

```txt
Muon beam → M0 trigger → sample (Target) → detectors (forward/backward)
```



```txt
##################################################
# 1. GEOMETRY
##################################################

# World (must exist)
# Large air box containing everything
/musr/command construct box World 
    1000 1000 1000 
    G4_AIR 
    0 0 0 
    no logical volume 
    norot 
    dead 
    0


# M0 detector (trigger BEFORE sample)
# Special name "M0" → automatic muM0Time saved
/musr/command construct box M0 
    10 10 2 
    Scintillator 
    0 0 -100 
    World 
    norot 
    musr/ScintSD 
    1


# Sample (Target)
# Special name "Target" → muTarget variables saved
/musr/command construct cylinder Target 
    0 5 10 0 360 
    G4_Cu 
    0 0 0 
    World 
    norot 
    dead 
    2


# Forward detector (after sample)
/musr/command construct box detForward 
    20 20 5 
    Scintillator 
    0 0 50 
    World 
    norot 
    musr/ScintSD 
    10


# Backward detector (before sample)
/musr/command construct box detBackward 
    20 20 5 
    Scintillator 
    0 0 -50 
    World 
    norot 
    musr/ScintSD 
    11


##################################################
# 2. FIELD
##################################################

# Uniform magnetic field along Z
/musr/command globalfield Bfield 
    100 100 100 uniform 
    0 0 0 World 
    0 0 0.3 0 0 0   # 0.3 Tesla


##################################################
# 3. PHYSICS
##################################################

# Muon ionization
/musr/command process addProcess mu+ G4MuIonisation -1 -1 1

# Optional μSR-specific process
/musr/command process addProcess mu+ musrMuFormation -1 -1 2


##################################################
# 4. GUN (PRIMARY BEAM)
##################################################

/gun/primaryparticle mu+
/gun/vertex 0 0 -200 mm
/gun/momentum 28 MeV
/gun/direction 0 0 1

# Beam spread
/gun/vertexsigma 5 5 0 mm

# Polarization along Z
/gun/muonPolarizVector 0 0 1


##################################################
# 5. LIMITS (NUMERICAL CONTROL)
##################################################

# Limit step size → better field accuracy
/musr/command globalfield setparameter SetLargestAcceptableStep 1 mm

# Prevent runaway tracks
/musr/command maximumNrOfStepsPerTrack 10000


##################################################
# 6. DETECTOR RESPONSE
##################################################

# Merge hits within 5 ns (detector resolution)
/musr/command signalSeparationTime 5 ns


##################################################
# 7. EVENT FILTERING
##################################################

# Only keep events with hits
/musr/command storeOnlyEventsWithHits true


##################################################
# 8. OUTPUT
##################################################

# Output directory
/musr/command rootOutputDirectoryName data

# Run simulation
/run/beamOn 5000
```



###  What This Simulation Produces

##### Automatically stored (because of naming + detectors):

From `M0`

```txt
muM0Time
muM0PolX/Y/Z
```

From Target

```txt
muTargetTime
muTargetMomX/Y/Z
muTargetPolX/Y/Z
From detectors (ID 10, 11)
```

From detectors (ID 10, 11)

```txt
det_ID[]
det_edep[]
det_time_start[]
```



### How to Think About This Setup

**Geometry logic:**

```txt
Beam → M0 → Target → detForward
                ↘ detBackward
```

**Physics logic:**

*   Muon enters
*   interacts in sample
*   decays → positron
*   positron hits detectors

**Data logic:**

*   Only events with detector hits are saved
*   Each detector has unique ID → easy filtering in ROOT



#### Subtle but Critical Points

1. Names control physics output
-   M0, Target are not cosmetic

2.   Fields are independent of geometry
     *   attached via logical volume
     *   not “inside” volumes physically
3.   Detector ≠ object
     *   it is just a volume + sensitivity flag



# Final Takeaway

* **Geometry** → what exists
* **Fields** → what acts
* **Physics** → how particles behave
* **Gun** → what you inject
* **Limits** → how computation runs
* **Response** → how signals form
* **Filtering** → what survives
* **Output** → what you record

