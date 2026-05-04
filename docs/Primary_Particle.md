## Primary event definition in muSRSim

In muSRSim, the primary particle is usually configured through `/gun/*` commands. Internally this uses the Geant4 particle gun unless `/gps/*` is used, in which case the GPS generator takes over and `/gun/*` commands are ignored. 

### 1. Particle type

```text
/gun/primaryparticle mu+
```

Default is `mu+`. Common alternatives:

```text
/gun/primaryparticle mu-
/gun/primaryparticle e+
/gun/primaryparticle e-
/gun/primaryparticle gamma
/gun/primaryparticle geantino
```

Use `geantino` only for geometry/debugging, not for real detector response.

---

### 2. Initial position

```text
/gun/vertex x0 y0 z0 unit
```

Example:

```text
/gun/vertex 0 0 -100 mm
```

This sets the mean starting position of the primary particle. Default units in muSRSim are mm for length, MeV for energy, MeV/c for momentum, ns/µs for time depending on context, and degrees for angles. 

---

### 3. Beam spot size / position smearing

```text
/gun/vertexsigma sx sy sz unit
```

Examples:

```text
/gun/vertexsigma 0 0 0 mm      # point source
/gun/vertexsigma 5 5 0 mm      # Gaussian beam spot
/gun/vertexsigma -5 -5 0 mm    # uniform distribution in x,y
```

Meaning:

```text
sigma > 0  → Gaussian smearing
sigma = 0  → no smearing
sigma < 0  → uniform distribution over ±|sigma|
```



---

### 4. Restricting the source region

Cylindrical restriction:

```text
/gun/vertexboundary Rmax zmin zmax unit
```

Example:

```text
/gun/vertexboundary 20 -200 0 mm
```

Box-shaped restriction:

```text
/gun/boxboundarycentre x0 y0 z0 unit
/gun/boxboundary hx hy hz unit
```

Example:

```text
/gun/boxboundarycentre 0 0 -100 mm
/gun/boxboundary 10 10 1 mm
```

Useful when you want particles generated only inside a beam pipe, window, source plate, or small entrance aperture. 

---

### 5. Beam direction

```text
/gun/direction dx dy dz
```

Example:

```text
/gun/direction 0 0 1
```

The vector does **not** need to be normalized. Important: muSRSim first generates the beam as if it were along the z-axis, then rotates the beam direction and beam spot into the requested direction. 

---

### 6. Energy or momentum

Kinetic energy:

```text
/gun/kenergy value unit
```

Example:

```text
/gun/kenergy 4 MeV
```

Momentum is usually more natural for muon beams:

```text
/gun/momentum value unit
```

Example:

```text
/gun/momentum 28 MeV/c
```

For a realistic beam, add momentum spread if available in your muSRSim version, for example using the relevant `/gun/*momentum*` commands from the manual/source.

---

### 7. Muon polarization

```text
/gun/muonPolarizVector px py pz
/gun/muonPolarizFraction f
```

Example:

```text
/gun/muonPolarizVector 0 0 1
/gun/muonPolarizFraction 1
```

Interpretation:

```text
f =  1   → all muons polarized along the vector
f = -1   → all muons polarized opposite to the vector
f =  0.9 → 95% along vector, 5% opposite
```

The fraction command is ignored if the polarization vector magnitude is essentially zero. 

---

### 8. Decay time control

Normally Geant4 handles muon decay time. To force decay within a time window:

```text
/gun/decaytimelimits tmin tmax meanLife unit
```

Example:

```text
/gun/decaytimelimits 0 10000 2197.03 ns
```

If `tmax <= 0`, this command is ignored and the default Geant4 decay handling is used. 

---

## Minimal fixed muon beam example

```text
# Primary particle
/gun/primaryparticle mu+

# Source position
/gun/vertex 0 0 -100 mm
/gun/vertexsigma 2 2 0 mm

# Beam direction
/gun/direction 0 0 1

# Beam momentum
/gun/momentum 28 MeV/c

# Muon spin
/gun/muonPolarizVector 0 0 1
/gun/muonPolarizFraction 1

# Run
/run/beamOn 10000
```

## Minimal geometry-debug beam

```text
/gun/primaryparticle geantino
/gun/vertex 0 0 -100 mm
/gun/vertexsigma 0 0 0 mm
/gun/direction 0 0 1
/run/beamOn 10
```

## TURTLE input beam

For realistic beam-line simulations, muSRSim can read TURTLE files:

```text
/gun/turtlefilename beam.dat
/gun/turtleZ0position -1000 mm
/gun/turtleInterpretAxes xy
/gun/turtleMomentumScalingFactor 1.0
/gun/turtleMomentumBite 28 100 0
```

`/gun/turtlefilename` activates TURTLE-based initialization; if no file is given, muons are generated randomly from the `/gun/*` settings. 

## Practical order in the macro

```text
# 1. Geometry
# 2. Fields
# 3. Physics processes
# 4. Primary particle / gun
# 5. Output settings
# 6. /run/beamOn
```

