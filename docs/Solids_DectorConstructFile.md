# Solids Cheat-Sheet for musrSim

This note is a compact reference for the solids handled in `musrDetectorConstruction.cc` through

```text
/musr/command construct
```

Units:
- lengths in **mm**
- angles in **degrees**

General placement syntax:

```text
/musr/command construct <solid> <name> <shape parameters...> <material> x y z <mother> <rotation> <sensitive> <id> [field]
```

For the top volume:
- the world must be named `World`
- its mother must be `no_logical_volume`

For daughter volumes:
- the mother name is typically `log_<MotherName>`

---

# 1. Standard Geant4 solids and direct wrappers

These map directly to Geant4 constructors in the source.

## `box`

```text
box hx hy hz
```

Source mapping:
- `G4Box(name, x1, x2, x3)`

Parameters:
- `hx`, `hy`, `hz` = half-lengths along `x`, `y`, `z`

---

## `tubs`

```text
tubs rMin rMax hz phiStart phiDelta
```

Source mapping:
- `G4Tubs(name, x1, x2, x3, x4, x5)`

Parameters:
- `rMin` = inner radius
- `rMax` = outer radius
- `hz` = half-length along `z`
- `phiStart` = start azimuth
- `phiDelta` = azimuth span

---

## `cons`

```text
cons rMin1 rMax1 rMin2 rMax2 hz phiStart phiDelta
```

Source mapping:
- `G4Cons(name, x1, x2, x3, x4, x5, x6, x7)`

Parameters:
- `rMin1`, `rMax1` = inner/outer radii at `-z`
- `rMin2`, `rMax2` = inner/outer radii at `+z`
- `hz` = half-length along `z`
- `phiStart`, `phiDelta` = azimuth range

---

## `trd`

```text
trd dx1 dx2 dy1 dy2 dz
```

Source mapping:
- `G4Trd(name, x1, x2, x3, x4, x5)`

Parameters:
- `dx1`, `dx2` = half-length in `x` at the `-z` and `+z` faces
- `dy1`, `dy2` = half-length in `y` at the `-z` and `+z` faces
- `dz` = half-length along `z`

---

## `trd90y`

```text
trd90y dx1 dx2 dy1 dy2 dz
```

Source mapping:
- same internal solid as `trd`: `G4Trd(name, x1, x2, x3, x4, x5)`
- later the code applies an additional built-in 90° rotation about local `y`

Parameters:
- same geometric parameters as `trd`

Practical note:
- this is not a new Geant4 primitive, but a musrSim convenience/orientation variant

---

## `sphere`

```text
sphere rMin rMax phiStart phiDelta thetaStart thetaDelta
```

Source mapping:
- `G4Sphere(name, x1, x2, x3, x4, x5, x6)`

Parameters:
- `rMin`, `rMax` = inner/outer radius
- `phiStart`, `phiDelta` = azimuth range
- `thetaStart`, `thetaDelta` = polar range

---

## `para`

```text
para hx hy hz alpha theta phi
```

Source mapping:
- `G4Para(name, x1, x2, x3, x4, x5, x6)`

Parameters:
- `hx`, `hy`, `hz` = half-lengths
- `alpha`, `theta`, `phi` = Geant4 parallelepiped angles

Note:
- the source comments mark this branch as “NOT YET TESTED”

---

## `torus`

```text
torus rMin rMax rTorus phiStart phiDelta
```

Source mapping:
- `G4Torus(name, x1, x2, x3, x4, x5)`

Parameters:
- `rMin` = bore radius
- `rMax` = outer tube radius
- `rTorus` = swept radius from torus center to tube center
- `phiStart` = start angle
- `phiDelta` = swept angle

The source comment explicitly describes it as: “Torus piece, Rmin (bore), Rmax (outer), Rtorus (swept), pSPhi (start angle), pDPhi (swept angle)”.

---

## `polyconeA`

```text
polyconeA phiStart phiDelta numZPlanes zPlane[] rInner[] rOuter[]
```

Source mapping:
- `G4Polycone(name, x1, x2, numZPlanes, zPLANE, rINNER, rOUTER)`

Parameters:
- `phiStart`, `phiDelta` = azimuth range
- `numZPlanes` = number of axial planes
- `zPlane[]` = array of `z` coordinates
- `rInner[]` = inner radius at each plane
- `rOuter[]` = outer radius at each plane

Arrays must be defined first with `arrayDef`.

---

## `polyconeB`

```text
polyconeB phiStart phiDelta numRZ r[] z[]
```

Source mapping:
- parsed as `name, x1, x2, numZPlanes, zPlane, rInner`
- then passed to the alternate `G4Polycone(name, x1, x2, numZPlanes, zPLANE, rINNER)` constructor

Parameters:
- `phiStart`, `phiDelta` = azimuth range
- `numRZ` = number of `(r,z)` contour points
- `r[]`, `z[]` = polygon contour arrays

Important note:
- in the code the variable names are recycled (`zPlane`, `rInner`), but functionally this is the 2-array polycone form

---

# 2. Custom musrSim / Boolean solids with explicit comments

These are built from unions, subtractions, or intersections. Here the source comments are the primary documentation.

## `cylpart`

```text
cylpart x1 x2 x3 x4
```

Source construction:
- half-cylinder: `G4Tubs(0, x2, x3, 0, 180)`
- subtract box: `G4Box(x2, x2-x4, x3)`

Recovered meaning:
- `x1` = parsed but not used in the constructor
- `x2` = outer radius of the semicylinder
- `x3` = half-length along `z`
- `x4` = cut parameter controlling the height of the subtracted box via `(x2 - x4)`

Practical constraint:
- to keep the subtraction meaningful, `x4 < x2`

---

## `uprofile`

```text
uprofile x1 x2 x3 x4
```

Source comment:
- `x1, x2, x3` define the outer dimensions of the U-profile (as a box)
- `x4` is the wall thickness
- the center of the U-profile is the center of the outer box

Recovered geometry:
- outer box = `(x1, x2, x3)`
- inner cut box = `(x1-x4, x2-x4/2, x3)`, shifted by `+x4/2` in `y`

---

## `BarWithBevelledEdgesX`

```text
BarWithBevelledEdgesX x1 x2 x3 x4
```

Source comment:
- box with “cut out” edges
- `x1, x2, x3` = box half-lengths
- `x4` = full width cut away at each edge
- four edges parallel to the `x` direction are bevelled

Recovered geometry:
- start from a box `(x1,x2,x3)`
- subtract the same rotated cutter from the four `(±y, ±z)` edge locations

---

## `alcSupportPlate`

```text
alcSupportPlate x1 x2 x3 x4
```

Source comment:
- ALC holder geometry
- `x1` = half-width of the holder (main plate)
- `x2` = half-height of the spacer

Recovered behavior from code:
- the main dimensions in `y` and `z` are mostly hard-coded (`4.7 mm`, `130 mm`)
- if `x2 != 0`, a spacer block is added below the holder
- `x3` and `x4` are parsed but not used in this implementation

So, in this source version:
- `x1` = active
- `x2` = active if the spacer is present
- `x3`, `x4` = unused placeholders

---

## `TubeWithTubeHole`

```text
TubeWithTubeHole rHole rOuter hz phiStart phiDelta holeDepth
```

Source comment:
- first 5 parameters are as for the outer tube
- 6th parameter is the depth of the hole

Recovered construction:
- outer tube = `G4Tubs(0, x2, x3, x4, x5)`
- inner blind hole = `G4Tubs(0, x1, x6/2, x4, x5)` shifted along `z`

Recovered meaning:
- `x1` = radius of the blind hole
- `x2` = outer radius of the tube
- `x3` = half-length of the outer tube
- `x4`, `x5` = azimuth range
- `x6` = hole depth

Note:
- the outer tube is solid, not hollow

---

## `TubeWithHoleAndTubeHole`

```text
TubeWithHoleAndTubeHole rInner rOuter hz phiStart phiDelta holeRadius holeDepth
```

Source comment:
- first 5 parameters are as for the outer tube
- 6th parameter is the depth of the hole

Recovered construction:
- outer tube = `G4Tubs(x1, x2, x3, x4, x5)`
- blind inner hole = `G4Tubs(0, x6, x7/2, x4, x5)` shifted along `z`

Recovered meaning:
- `x1` = inner radius of the outer annular tube
- `x2` = outer radius
- `x3` = half-length
- `x4`, `x5` = azimuth range
- `x6` = radius of the blind hole
- `x7` = hole depth

---

## `TubeWithHolePlusTubeHole`

```text
TubeWithHolePlusTubeHole rInner rOuter hz phiStart phiDelta holeRMin holeRMax holeDepth
```

Source comment:
- first 5 parameters are as for the outer tube
- 6th, 7th and 8th define the second hole

Recovered construction:
- outer tube = `G4Tubs(x1, x2, x3, x4, x5)`
- subtracted blind annular hole = `G4Tubs(x6, x7, x8/2, x4, x5)` shifted along `z`

Recovered meaning:
- `x1`, `x2`, `x3`, `x4`, `x5` = outer tube parameters
- `x6`, `x7` = inner and outer radii of the second annular hole
- `x8` = hole depth

---

## `tubsbox`

```text
tubsbox x1 x2 x3 x4 x5
```

Source comment:
- create a tube from which a centered box is cut out
- `x1 = box half-width`
- `x2, x3, x4, x5` define the tube

Recovered meaning:
- inner cut box = `(x1, x1, x3)`
- outer tube = `G4Tubs(0, x2, x3, x4, x5)`

So:
- `x1` = square-hole half-width in `x` and `y`
- `x2` = outer tube radius
- `x3` = half-length along `z`
- `x4`, `x5` = azimuth range

---

## `tubsbox2`

```text
tubsbox2 x1 x2 x3 x4 x5 x6 x7 x8
```

Source comment:
- more general version of `tubsbox`
- `x1, x2, x3` = box half-widths
- `x4, x5, x6, x7, x8` define the tube

Recovered meaning:
- cut box = `(x1, x2, x3)`
- tube = `G4Tubs(x4, x5, x6, x7, x8)`

So:
- `x1`, `x2`, `x3` = rectangular opening half-lengths
- `x4` = tube inner radius
- `x5` = tube outer radius
- `x6` = half-length along `z`
- `x7`, `x8` = azimuth range

---

## `boxbox`

```text
boxbox x1 x2 x3 x4 x5 x6
```

Source comment:
- create a box from which a centered box is cut out
- `x1, x2, x3` = inner box half-widths of the opening
- `x4, x5, x6` define the big box

Recovered meaning:
- inner cut box = `(x1, x2, x3)`
- outer box = `(x4, x5, x6)`

---

## `GPSforward`

```text
GPSforward x1 x2 x3 x4 x5
```

Source comment:
- create a box from which a cone is cut out
- `x1, x2, x3` = box half-widths
- `x4, x5` = radii of the cone at the two faces of the box

Recovered construction:
- outer box = `G4Box(x1, x2, x3)`
- subtraction solid = `G4Cons(0, x4, 0, x5, x3, 0, 360)`

So:
- `x4` = radius on one face of the conical cut
- `x5` = radius on the opposite face

---

## `GPSbackward`

```text
GPSbackward x1 x2 x3 x4 x5
```

Source comment:
- create a box from which a trapezoid is cut out
- `x1, x2, x3` = box half-widths
- `x4, x5` = `dx1=dy1` and `dx2=dy2` of the trapezoid

Recovered construction:
- outer box = `G4Box(x1, x2, x3)`
- subtraction solid = `G4Trd(x4, x5, x4, x5, x3)`

---

## `GPSbackwardVeto`

```text
GPSbackwardVeto x1 x2 x3 x4 x5 x6 x7 x8 x9
```

Source comment:
- create a trapezoid from which a trapezoid is cut out
- `x1, x2, x3, x4, x5` = half-dimensions of the outer trapezoid
- `x6, x7, x8, x9` = half-dimensions of the inner trapezoid
- expected that `dz = x5` is the same for both trapezoids

Recovered construction:
- outer = `G4Trd(x1,x2,x3,x4,x5)`
- inner = `G4Trd(x6,x7,x8,x9,x5)`

---

## `tubeWithWindows`

```text
tubeWithWindows x1 x2 x3 x4 x5 x6 x7
```

Source comment:
- `x1` = inner radius of the tube
- `x2` = outer radius of the tube
- `x3` = half-length of the tube
- `x4` = radius of the backward window
- `x5` = distance between the center of the backward window and the end of the shield
- `x6` = radius of the forward window
- `x7` = distance between the center of the forward window and the end of the shield

Recovered geometry:
- start from a cylindrical shield
- subtract two transverse cylindrical windows from opposite sides

---

## `GPDcollimator`

```text
GPDcollimator x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12
```

Source comment:
- create a box from which a tube and a rectangular opening are cut out
- `x1, x2, x3` = box half-widths
- `x4, x5, x6, x7` define the tube
- `x8, x9, x10` = distances between the tube and box centers
- `x11, x12` = half-widths of the rectangular opening in the collimator

Recovered construction:
- outer box = `G4Box(x1, x2, x3)`
- rectangular opening = `G4Box(x11, x2, x12)`
- cylindrical cut = `G4Tubs(0, x4, x5, x6, x7)` shifted by `(-x8,-x9,-x10)`

So:
- `x4` = tube outer radius
- `x5` = half-length of the tube cut
- `x6`, `x7` = azimuth range of the tube cut
- `x8`, `x9`, `x10` = shift of the tube cut relative to the box center

---

## `tubsboxsegm`

```text
tubsboxsegm <orientation> x1 x2 x3 x4 x5
```

Source comment:
- create a volume that looks like an intersection of tube and box

Recovered construction:
- box = `G4Box(x2, x2, x3)`
- tube = `G4Tubs(0, x2, x3, x4, x5)`
- final solid = intersection of both after shifting the box

Recovered meaning:
- `orientation` ∈ `{U,D,L,R}`
- `x1` = offset/placement control for the square segment
- `x2` = common half-width and outer radius
- `x3` = half-length along `z`
- `x4`, `x5` = azimuth range of the tube

Orientation mapping in the source:
- `U` = shifted to positive `x,y`
- `D` = shifted to positive `x`, negative `y`
- `R` = shifted to negative `x`, positive `y`
- `L` = shifted to positive `x`, near left branch according to code naming

The exact geometric naming of `L/R/U/D` follows the source implementation, not a human-optimized convention.

---

## `GPDsampleHolderA`

```text
GPDsampleHolderA x1 x2 x3 x4 x5
```

Source comment:
- first part of the GPD sample holder
- `posx,posy,posz` are interpreted as the center of the whole long tube
- specifically the code comments say this is `111.25 mm` below the center of the holes

Recovered behavior:
- the actual shape dimensions are almost entirely hard-coded in the implementation
- `x1..x5` are parsed but not used to build the solid

So, in this source version:
- shape parameters are placeholders
- placement is the important part

---

## `GPDmHolder`

```text
GPDmHolder x1 x2 x3
```

Source comment:
- light guide that holds `m0` in position

Recovered construction:
- outer box = `G4Box(sqrt(2)*x1, x2, x3)`
- subtract centered cut box = `G4Box(x1, x1, x3)` rotated by 45° around `z` and shifted by `(0, x2, 0)`

Recovered meaning:
- `x1` = half-size controlling the central rotated square cut
- `x2` = half-height / offset control in `y`
- `x3` = half-length in `z`

---

## `cruciform`

```text
cruciform x1 x2 x3 x4 x5
```

Source comment:
- solid cruciform = union of 3 mutually perpendicular cylinders
- top port can differ from bottom
- `x1` = radius of main `±z` bore
- `x2` = radius of `±x` and `-y` bore
- `x3` = radius of `+y` bore
- `x4` = `z` extent
- `x5` = `x,y` extent

Recovered construction:
- main vertical cylinder along `z`
- horizontal cross-bore along `x`
- separate bottom and top `y` bores with potentially different radii

---

# 3. Present in the source, but not commented in detail

These solids are handled in the file, but their inline comments are minimal or absent. Their parameter lists can still be read from the constructor calls.

## `drum`

No dedicated constructor branch was found in the extracted portion with parameter comments, so this name should be treated cautiously unless it appears elsewhere in another source file.

## `tubslowerend`

Not found as a `construct` branch in this uploaded `musrDetectorConstruction.cc`.

## `horizontallyDividedCylinder`

Not found as a `construct` branch in this uploaded `musrDetectorConstruction.cc`.

## `tubsCuttedTop`

Not found as a `construct` branch in this uploaded `musrDetectorConstruction.cc`.

## `tubeWithAHole`

The actual branch names in this source are:
- `TubeWithTubeHole`
- `TubeWithHoleAndTubeHole`
- `TubeWithHolePlusTubeHole`

So the manual name `tubeWithAHole` appears to be a looser label, not the literal keyword in this file.

## `boxWithAHole`, `boxWithAFrustumHole`, `boxWithTrdHole`, `trdWithATrdHole`, `shield`

The corresponding literal branch names in this source are:
- `boxbox`
- `GPSforward`
- `GPSbackward`
- `GPSbackwardVeto`
- `tubeWithWindows`

In other words, the source uses more instrument- or implementation-specific keywords than the generic names used in the older note.

---

# 4. Minimal examples

## World + standard solid

```text
/musr/command construct box World 300 300 300 G4_AIR 0 0 0 no_logical_volume norot dead -1
/musr/command construct tubs Cyl1 0 50 40 0 360 G4_Al 0 0 0 log_World norot dead 1
```

## `polyconeA`

```text
/musr/command construct box World 300 300 300 G4_AIR 0 0 0 no_logical_volume norot dead -1
/musr/command arrayDef zA    4 -50 0 50 100
/musr/command arrayDef rinA  4   0 0  0   0
/musr/command arrayDef routA 4  10 30 20 40
/musr/command construct polyconeA PolyA 0 360 4 zA rinA routA G4_Al 0 0 0 log_World norot dead 1
```

## `uprofile`

```text
/musr/command construct box World 300 300 300 G4_AIR 0 0 0 no_logical_volume norot dead -1
/musr/command construct uprofile U1 60 40 200 5 G4_Al 0 0 0 log_World norot dead 1
```

## `tubsbox`

```text
/musr/command construct box World 300 300 300 G4_AIR 0 0 0 no_logical_volume norot dead -1
/musr/command construct tubsbox TB1 10 25 40 0 360 G4_Al 0 0 0 log_World norot dead 1
```

## `GPDcollimator`

```text
/musr/command rotation rot0 0 0 0
/musr/command construct box World 300 300 300 G4_AIR 0 0 0 no_logical_volume norot dead -1
/musr/command construct GPDcollimator GPD1 40 15 60 59 60.01 0 360 0 59 0 2.5 6 G4_Cu 0 0 0 log_World rot0 dead 1
```

---

# 5. What changed relative to the earlier note

This revision does two things:
1. it uses the actual literal branch names from `musrDetectorConstruction.cc`
2. it marks clearly which parameter meanings come from comments and which were recovered from the Boolean construction itself

That matters because the earlier note mixed together:
- literal source keywords
- generic descriptive names
- some empirically inferred meanings from visualization tests

This updated version is closer to the source of truth.
