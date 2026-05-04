# Visualization in muSRSim — Concise Documentation

## 1. Core concept

Visualization is handled by Geant4’s **/vis/** command system:

* **Geometry view** → static detector
* **Event view** → particle tracks + hits
* Driven via a **vis.mac** file

---

# 2. Opening a viewer

```text
/vis/open OGLIQt
```

Common options:

```text
/vis/open OGLIQt 1000x800-0+0
/vis/open OGLIX
/vis/open RayTracer
```

### Practical choice

* `OGLIQt` → interactive GUI (best for development)
* `OGLIX` → fallback (no Qt)
* `RayTracer` → high-quality static rendering

---

# 3. Drawing geometry

```text
/vis/drawVolume
```

This is mandatory — nothing appears without it.

---

## Style control

```text
/vis/viewer/set/style wireframe
/vis/viewer/set/style surface
```

* `wireframe` → debugging geometry overlaps
* `surface` → realistic visualization

---

## Visibility of daughters (nested volumes)

```text
/vis/viewer/set/visibility true
/vis/viewer/set/hiddenEdge true
```

---

# 4. Camera control

### View direction

```text
/vis/viewer/set/viewpointThetaPhi 70 20 deg
```

* θ → polar angle
* φ → azimuth

---

### Zoom

```text
/vis/viewer/zoom 1.5
```

---

### Pan / move

```text
/vis/viewer/pan dx dy
```

---

### Auto-refresh

```text
/vis/viewer/set/autoRefresh true
```

---

### Flush (force redraw)

```text
/vis/viewer/flush
```

---

# 5. Background and aesthetics

```text
/vis/viewer/set/background black
```

Other options:

```text
white
grey
```

---

# 6. Adding axes (very useful)

```text
/vis/scene/add/axes 0 0 0 100 mm
```

---

# 7. Event visualization (tracks)

## Enable event storage

```text
/vis/scene/endOfEventAction accumulate
```

Options:

```text
accumulate   # keep all events
refresh      # show only last event
```

---

## Draw trajectories

```text
/vis/scene/add/trajectories smooth
```

---

## Color by particle

```text
/vis/modeling/trajectories/create/drawByParticleID
```

---

## Draw hits

```text
/vis/scene/add/hits
```

---

## Optional: step points

```text
/vis/scene/add/trajectories rich
```

---

# 8. Running events for visualization

```text
/run/beamOn 10
```

Important:

* Visualization only updates after events are generated

---

# 9. Minimal working vis.mac

```text
# Open viewer
/vis/open OGLIQt 1000x800-0+0

# Draw geometry
/vis/drawVolume

# Style
/vis/viewer/set/style wireframe
/vis/viewer/set/background black

# Camera
/vis/viewer/set/viewpointThetaPhi 70 20 deg

# Add axes
/vis/scene/add/axes 0 0 0 100 mm

# Event visualization
/vis/scene/endOfEventAction accumulate
/vis/scene/add/trajectories smooth
/vis/modeling/trajectories/create/drawByParticleID
/vis/scene/add/hits

# Refresh
/vis/viewer/flush
```

---

# 10. Geometry-only debug mode

```text
/vis/open OGLIQt
/vis/drawVolume
/vis/viewer/set/style wireframe
/vis/viewer/flush
```

Use this when:

* Checking overlaps
* Verifying positions and rotations

---

# 11. Exporting images / vector output

## RayTracer output

```text
/vis/open RayTracer
/vis/drawVolume
/vis/viewer/flush
```

Produces raster images.

---

## DAWNFILE (vector)

```text
/vis/open DAWNFILE
/vis/drawVolume
/vis/viewer/flush
```

Output:

```text
g4_*.prim
```

Then convert externally to vector formats (PS/PDF).

⚠️ You cannot reliably mix multiple `/vis/open` in one session — use separate runs/macros.

---

# 12. Common mistakes

### Nothing appears

* Missing:

```text
/vis/drawVolume
```

---

### Tracks not visible

* Missing:

```text
/vis/scene/add/trajectories
```

---

### Hits not visible

* Missing:

```text
/vis/scene/add/hits
```

---

### Only geometry, no events

* Forgot:

```text
/run/beamOn N
```

---

### Viewer opens but blank

* Missing flush:

```text
/vis/viewer/flush
```

---

# 13. Practical workflow

### Step 1 — Geometry debug

```text
wireframe + no events
```

### Step 2 — Beam alignment

```text
few events + trajectories
```

### Step 3 — Detector validation

```text
enable hits + accumulate
```

---

# 14. What matters most

### Critical

* `/vis/open`
* `/vis/drawVolume`
* `/vis/scene/add/trajectories`
* `/run/beamOn`

### Secondary

* Camera tuning
* Background / style

---

# Final structure

You now have complete macro coverage:

```text
Geometry
Fields
Physics
Primary (gun)
Visualization
Sensitive detectors
Output (ROOT)
```

