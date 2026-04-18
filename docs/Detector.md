# `musrSim` Detector Cheat-Sheet

## 1. Core Concept

A “detector” in musrSim is:

> A **volume** defined via `/musr/command construct` that becomes **sensitive** if assigned a `sensitiveClass` and an `idNumber`. 


---


## 2. Detector Definition (Single Command)

### Syntax

```txt
/musr/command construct 
    solid name dimensions 
    material 
    x y z 
    motherVolume 
    matrixName 
    sensitiveClass 
    idNumber
```


---


## 3. Geometry Options


### Supported solids

```txt
tubs, cons, box, trd, sphere, para, polyconeA, polyconeB
```


### musrSim-specific solids

```txt
uprofile, alcSupportPlate, tubsbox, tubsboxsegm,
trd90y, cylpart, GPDcollimator
```


> These map directly to Geant4 solids or custom implementations. 


---


## 4. Sensitivity Options

### `sensitiveClass` parameter

| Value          | Meaning                           |
| -------------- | --------------------------------- |
| `dead`         | NOT sensitive (passive material)  |
| `musr/ScintSD` | Sensitive detector (scintillator) |


> Currently, **only one detector type exists**:

* `musr/ScintSD` 


---


## 5. Detector Identification

### `idNumber` (integer)

Used for:

* hit identification (`det ID`)
* muon decay location (`muDecayDetID`)

> Must be **unique per volume**.


---


## 6. Special Volume Names (IMPORTANT)

These change behavior implicitly:

| Name             | Effect                                                   |
| ---------------- | -------------- |
| `Target`         | saves muon entry properties |
| `M0`, `M1`, `M2` | trigger detectors |
| `save*`          | records particle passage (no need for energy deposition) |
| `kill*`          | kills all particles |
| `shield*`        | kills all except muons |


> These are **not geometry features — they affect simulation logic**. 


---



## 7. Fields (Detector Environment)

### Uniform field

```txt
/musr/command globalfield fieldName 
    halfX halfY halfZ uniform 
    X Y Z logicalVolume 
    Bx By Bz Ex Ey Ez
```

### Field map

```txt
/musr/command globalfield fieldName 
    X Y Z fromfile 
    fieldType fileName 
    logicalVolume 
    fieldValue
```

### Key ideas

* Fields are **not tied to geometry directly**
* They are **assigned via logicalVolume**
* They can **overlap**

> This is a major abstraction vs pure Geant4. 


---


## 8. Detector Physics Control

### Add physics processes

```txt
/musr/command process addProcess particle process ...
```

Examples:

```txt
mu+ → musrMuFormation
mu+ → musrMuEnergyLossLandau
```


---


## 9. Detector Signal Behavior

### Hit merging (detector resolution)

```txt
/musr/command signalSeparationTime 10 ns
```

> Two hits within this time → merged into one.


---


### Store only relevant events

```txt
/musr/command storeOnlyEventsWithHits false
/musr/command storeOnlyEventsWithHitInDetID 11
```


---


### First-hit only

```txt
/musr/command storeOnlyTheFirstTimeHit true
```


---


## 10. Advanced Detector Control

### User limits (step size, time, etc.)

```txt
/musr/command SetUserLimits logicalVolume 
    step track time energy range
```

> Requires enabling Geant4 processes like `G4StepLimiter`. 

---


### Region-based control

```txt
/musr/command region define regionName logicalVolume
/musr/command region setProductionCut regionName gamma e- e+
```

---


## 11. Optical Detector (Advanced)

Enable photon tracking:

```txt
/musr/command G4OpticalPhotons true
```

Then define:

* material optical properties
* surfaces (reflection, efficiency)
* photon signal analysis (OPSA)

> Very expensive computationally. 

---

# Tutorial: Minimal Detector Setup

## Example 1 — Single Scintillator Detector

```txt
# World
/musr/command construct box World 1000 1000 1000 G4_AIR 0 0 0 no_logical_volume norot dead 0

# Detector
/musr/command construct box det1 10 10 10 Scintillator 0 0 0 World norot musr/ScintSD 1
```

---


## Example 2 — Passive + Active System

```txt
# Passive support
/musr/command construct box support 50 50 5 Aluminum 0 0 -20 World norot dead 2

# Active detector
/musr/command construct box detector 20 20 5 Scintillator 0 0 0 World norot musr/ScintSD 10
```

---


## Example 3 — Detector + Magnetic Field

```txt
# Detector
/musr/command construct box det 10 10 10 Scintillator 0 0 0 World norot musr/ScintSD 1

# Field
/musr/command globalfield Bfield 50 50 50 uniform 0 0 0 det 0 0 1 0 0 0
```

> 1 Tesla field in Z direction.


---


## Example 4 — Save Volume (diagnostics)

```txt
/musr/command construct box savePlane 50 50 1 G4_Galactic 0 0 50 World norot dead 99
```

> Records particle passage **without requiring energy deposition**.

---

 
## Example 5 — Trigger Detector (M0)

```txt
/musr/command construct box M0 10 10 2 Scintillator 0 0 -100 World norot musr/ScintSD 5
```

> Automatically stores:

* `muM0Time`
* `muM0PolX/Y/Z`

---


# Key Takeaways

### 1. Detector = geometry + sensitivity + ID
* No separate detector object exists


### 2. Only one detector type
* `musr/ScintSD`


### 3. Behavior is controlled by:
* **name** (Target, M0, save, kill)
* **idNumber**
* **macro commands**


### 4. Fields are independent objects
* Assigned via logical volume
* Can overlap


### 5. musrSim simplifies Geant4 heavily
* No manual `G4LogicalVolume`
* No manual SD attachment
* Everything through macro

