# 1. Standard Geant4 solids

### **1. box**

<img src="../figs/aBox.jpg" style="zoom:60%;" />

```text
box hx hy hz
```

* Half-lengths along x, y, z

---

### **2. tubs (cylinder)**

<img src="../figs/aTubs.jpg" style="zoom:60%;" />

```text
tubs rMin rMax hz phiStart phiDelta
```

* Inner radius, outer radius
* Half-length (z)
* Start angle, angular span

---

### **3. cons (truncated cone)**

<img src="../figs/aCons.jpg" style="zoom:60%;" />

```text
cons rMin1 rMax1 rMin2 rMax2 hz phiStart phiDelta
```

* Radii at -z face (1) and +z face (2)
* Half-length (z)
* Angular parameters

---

### **4. sphere**

<img src="../figs/aSphere.jpg" style="zoom:60%;" />

```text
sphere rMin rMax phiStart phiDelta thetaStart thetaDelta
```

* Inner/outer radius
* Azimuthal + polar angular ranges

---

### **5. trd (trapezoid)**

<img src="../figs/aTrd.jpg" style="zoom:60%;" />

```text
trd hx1 hx2 hy1 hy2 hz
```

* Half-lengths in x and y at both z faces
* Half-length in z

---

### **6. para (parallelepiped)**

<img src="../figs/aPara.jpg" style="zoom:60%;" />

```text
para hx hy hz alpha theta phi
```

* Half-lengths
* Tilt angles (geometry skew)

---

### **7. polyconeA**

<img src="../figs/aBREPSolidPCone.jpg" style="zoom:60%;" />

```text
polyconeA phiStart phiTotal numZPlanes zPlane[] rInner[] rOuter[]
```

* Arrays must be defined via:

```text
/musr/command arrayDef
```

---

### **8. polyconeB**

<img src="../figs/aBREPSolidPCone.jpg" style="zoom:60%;" />

```text
polyconeB phiStart phiTotal numRZ r[] z[]
```

* Alternative polycone definition using (r, z) pairs

---

# 2. musrSim-specific solids

These are **custom shapes** (less standardized, parameters follow internal implementation):

### **9. uprofile**

```text
uprofile (custom parameters)
```

* U-shaped bar geometry

---

### **10. alcSupportPlate**

```text
alcSupportPlate (...)
```

* Specific geometry for ALC setup

---

### **11. tubsbox**

```text
tubsbox (...)
```

* Cylinder with rectangular hole

---

### **12. tubsboxsegm**

```text
tubsboxsegm (...)
```

* Intersection of cylinder and box

---

### **13. trd90y**

```text
trd90y (same as trd)
```

* `trd` rotated 90° around y-axis

---

### **14. cylpart**

```text
cylpart (...)
```

* Cylinder with subtracted box

---

### **15. GPDcollimator**

```text
GPDcollimator (...)
```

* Collimator geometry used in GPD instrument

---

# Critical notes

* **All lengths are in mm, angles in degrees** 
* **Dimensions are usually half-lengths** (very common source of errors) 
* **polycone requires arrays defined beforehand**
* Custom solids require checking source (`musrDetectorConstruction.cc`) for exact parameter order

---

# Minimal mental model

You can classify solids into:

* **Primitive shapes** → `box`, `tubs`, `cons`, `sphere`, `trd`, `para`
* **Profile-based** → `polyconeA/B`
* **Composite/custom** → everything else (musrSim-specific)

