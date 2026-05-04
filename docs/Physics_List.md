# Physics Configuration in muSRSim — Concise Guide

## 1. Core idea

In muSRSim, the physics is **not selected as a whole list**.
Instead, you **attach individual physics processes to particles** using macro commands.

These processes control:

-   Energy loss
-   Scattering
-   Decay
-   Optical effects (if used)
-   Special μSR-specific interactions

------

# 2. How to add physics processes

## General command

```text
/musr/command process addProcess particle process ordAtRest ordAlongStep ordPostStep
```

Example:

```text
/musr/command process addProcess mu+ G4StepLimiter -1 -1 5
```

------

## Meaning of each field

```text
particle        → which particle (mu+, mu-, e+, e-, gamma, opticalphoton, etc.)
process         → Geant4 process name
ordAtRest       → execution order when particle is at rest
ordAlongStep    → execution order during continuous tracking
ordPostStep     → execution order after each step
```

------

# 3. What do the numbers mean?

These three integers define **when and in what order a process acts**.

## Key rules

### `-1`

```text
Process is NOT active in this phase
```

### `0, 1, 2, 3, ...`

```text
Process is active
Smaller number = higher priority (executed earlier)
```

------

## Three execution stages (important concept)

### 1. AtRest

```text
Processes acting when particle is stopped
```

Example:

-   Decay at rest

------

### 2. AlongStep

```text
Continuous processes during motion
```

Example:

-   Ionization (energy loss)
-   Multiple scattering

------

### 3. PostStep

```text
Discrete processes applied after a step
```

Example:

-   Interactions
-   Step limiter
-   Secondary generation

------

## Example explained

```text
/musr/command process addProcess mu+ G4StepLimiter -1 -1 5
```

Interpretation:

| Field     | Value | Meaning                           |
| --------- | ----- | --------------------------------- |
| AtRest    | -1    | Not used when particle is stopped |
| AlongStep | -1    | Not applied continuously          |
| PostStep  | 5     | Applied after each step           |

👉 So:

>   “Apply the StepLimiter only after each step, with priority 5”

------

## Another example (typical EM process)

```text
/musr/command process addProcess e- G4eIonisation -1 2 2
```

Meaning:

-   Not active at rest
-   Active during motion (AlongStep = 2)
-   Also contributes post-step (PostStep = 2)

------

# 4. Discrete processes

Some processes are purely discrete (no ordering needed):

```text
/musr/command process addDiscreteProcess particle process
```

Example:

```text
/musr/command process addDiscreteProcess gamma G4ComptonScattering
```

------

# 5. Common processes you will use

## Gamma interactions

```text
/musr/command process addDiscreteProcess gamma G4PhotoElectricEffect
/musr/command process addDiscreteProcess gamma G4ComptonScattering
/musr/command process addDiscreteProcess gamma G4GammaConversion
```

------

## Electron / positron

```text
/musr/command process addProcess e- G4eMultipleScattering -1 1 1
/musr/command process addProcess e- G4eIonisation        -1 2 2
/musr/command process addProcess e- G4eBremsstrahlung    -1 3 3

/musr/command process addProcess e+ G4eMultipleScattering -1 1 1
/musr/command process addProcess e+ G4eIonisation        -1 2 2
/musr/command process addProcess e+ G4eBremsstrahlung    -1 3 3
/musr/command process addProcess e+ G4eplusAnnihilation   0 -1 4
```

------

## Muons

```text
/musr/command process addProcess mu+ G4MuMultipleScattering -1 1 1
/musr/command process addProcess mu+ G4MuIonisation         -1 2 2
/musr/command process addProcess mu+ G4MuBremsstrahlung     -1 3 3
```

------

# 6. Step limiter (important for precision)

```text
/musr/command process addProcess mu+ G4StepLimiter -1 -1 5
```

Use this when:

-   Geometry is thin
-   You need better spatial resolution
-   Strong magnetic fields are present

------

# 7. Production cuts (separate from processes)

```text
/musr/command process cutForGamma 0.1
/musr/command process cutForElectron 0.1
```

Meaning:

-   Minimum range required to create secondary particles

------

# 8. Loss fluctuation control

```text
/musr/command process SetLossFluctuations_OFF particle process
```

Example:

```text
/musr/command process SetLossFluctuations_OFF mu+ G4MuIonisation
```

Use only for controlled/debug simulations.

------

# 9. Minimal practical physics setup

For a typical μSR detector:

```text
# Gamma
/musr/command process addDiscreteProcess gamma G4PhotoElectricEffect
/musr/command process addDiscreteProcess gamma G4ComptonScattering

# Positrons (from muon decay)
/musr/command process addProcess e+ G4eMultipleScattering -1 1 1
/musr/command process addProcess e+ G4eIonisation        -1 2 2

# Muons
/musr/command process addProcess mu+ G4MuMultipleScattering -1 1 1
/musr/command process addProcess mu+ G4MuIonisation         -1 2 2

# Optional precision control
/musr/command process addProcess mu+ G4StepLimiter -1 -1 5
```

------

# 10. What matters most (practical view)

### Essential

-   Add **muon + positron processes**
-   Add **gamma processes** if detector response matters

### Important for accuracy

-   StepLimiter
-   Production cuts

### Advanced (optional)

-   Optical processes
-   Muonium/foil physics
-   Loss fluctuation control

------

# Final takeaway

Think of muSRSim physics as:

```text
You build physics by attaching processes to particles.
```

And for the ordering numbers:

```text
-1 → not active
0,1,2,... → active (lower = earlier execution)
```

