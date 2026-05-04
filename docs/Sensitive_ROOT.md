# **Sensitive detectors + event filtering + ROOT output in muSRSim**


# 1. Core concept (what actually happens)

In muSRSim:

1. You define a **volume**
2. You mark it as a **sensitive detector**
3. Each time a particle interacts there → a **hit is recorded**
4. Selected hits/events are written to a **ROOT file**

---

# 2. Defining a sensitive detector

This is done at the **geometry level**, not separately.

### Typical pattern

```text
/geom/volume/setSensitive volumeName detectorID
```

Example:

```text
/geom/volume/setSensitive log_scintillator 11
```

### Key rules

* `volumeName` → **logical volume name**
* `detectorID` → integer used in output
* Must match exactly the geometry definition

---

## ⚠️ Common error (you already saw this)

```
No ID number assigned to sensitive volume log_World
```

Meaning:

* A volume is being treated as sensitive **without an assigned ID**

### Fix

Either:

* Assign an ID explicitly

```text
/geom/volume/setSensitive log_detector 11
```

or ensure:

* Only intended volumes are sensitive

---

# 3. What is recorded per hit

Each hit typically includes:

* Detector ID
* Time
* Energy deposition
* Particle type
* Position
* Momentum (depending on configuration)

You **do not define this manually** — it is handled internally.

---

# 4. Event filtering (VERY important)

Without filtering, output becomes huge and mostly useless.

### Store only events with hits in a detector

```text
/musr/onlyStoreEventsWithHits detectorID
```

Example:

```text
/musr/onlyStoreEventsWithHits 11
```

This is exactly what your log showed:

```
Only the events with at least one hit in the detector ID=11 are stored
```

---

## Multiple detectors

```text
/musr/onlyStoreEventsWithHits 11
/musr/onlyStoreEventsWithHits 12
```

---

## Disable filtering

```text
/musr/storeAllEvents
```

⚠️ This will generate very large files.

---

# 5. ROOT output configuration

## Output directory

```text
/musr/setRootOutputDirectoryName data
```

Default is often already `data/`.

---

## Output file name

```text
/musr/setRootOutputFileName myRun
```

Result:

```text
data/myRun.root
```

---

## Enable ROOT output

```text
/musr/setRootOutput true
```

---

## Minimal output block

```text
/musr/setRootOutput true
/musr/setRootOutputDirectoryName data
/musr/setRootOutputFileName test_run
```

---

# 6. What is inside the ROOT file

The ROOT file typically contains:

* **Event tree**
* **Hit information**
* **Timing distributions**
* **Detector IDs**

You will later analyze it with:

* ROOT
* Python (uproot)
* Custom scripts

---

# 7. Minimal working detector + output example

```text
# --- Sensitive detector ---
/geom/volume/setSensitive log_detector 11

# --- Event filtering ---
/musr/onlyStoreEventsWithHits 11

# --- ROOT output ---
/musr/setRootOutput true
/musr/setRootOutputDirectoryName data
/musr/setRootOutputFileName run01

# --- Run ---
/run/beamOn 10000
```

---

# 8. Debugging checklist

### No output file

* Did you enable ROOT?

```text
/musr/setRootOutput true
```

---

### Empty ROOT file

* Check filtering:

```text
/musr/storeAllEvents
```

---

### Warning: no ID assigned

* You forgot:

```text
/geom/volume/setSensitive ...
```

---

### Too large file

* Add filtering:

```text
/musr/onlyStoreEventsWithHits ID
```

---

# 9. Practical design strategy (important)

For a realistic μSR setup:

### Define detectors as:

* Scintillators
* PMTs
* Sample region (optional)

### Assign IDs:

```text
11 → Forward detector
12 → Backward detector
13 → Left
14 → Right
```

Then filter:

```text
/musr/onlyStoreEventsWithHits 11
/musr/onlyStoreEventsWithHits 12
```

---

# 10. Conceptual pipeline (full picture)

```text
Geometry
   ↓
Sensitive volumes (detectors)
   ↓
Primary particle
   ↓
Physics processes
   ↓
Hits generated
   ↓
Event filtering
   ↓
ROOT output
```

---

# 11. What matters most (cut through noise)

### Critical

* `/geom/volume/setSensitive`
* `/musr/onlyStoreEventsWithHits`
* ROOT output enabled

### Secondary

* Output naming

### Ignore for now

* Internal hit structure (handled by muSRSim)

