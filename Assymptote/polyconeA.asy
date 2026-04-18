// ============================================================
// polyconeA.asy
// Schematic visual cheat-sheet for Geant4 / musrSim polyconeA
//
// polyconeA uses arrays:
//   zPlane[], rInner[], rOuter[]
//
// This figure shows:
//   LEFT  = true rz profile (definition space)
//   RIGHT = schematic revolved 3D cue
// ============================================================

settings.outformat = "pdf";
size(15cm, 0);
usepackage("amsmath");

// ------------------------------------------------------------
// STYLE
// ------------------------------------------------------------
pen axisPen   = rgb(0.20, 0.30, 0.60) + 0.7;
pen guidePen  = gray(0.60) + 0.5;
pen dimPen    = black + 0.8;
pen edgePen   = black + 1.0;
pen hiddenPen = gray(0.55) + dashed + 0.5;

pen fillOuter = opacity(0.18) + rgb(0.65, 0.73, 0.82);
pen fillSide  = opacity(0.22) + rgb(0.55, 0.64, 0.76);
pen fillCut   = opacity(0.20) + rgb(0.45, 0.45, 0.45);

// ------------------------------------------------------------
// EXAMPLE DATA
// Replace these arrays with your own examples if needed
// ------------------------------------------------------------
real[] zPlane = {-2, -1, 1, 3};
real[] rInner = {0.5, 0.8, 0.6, 0.9};
real[] rOuter = {1.5, 1.8, 1.6, 2.0};

int nP = zPlane.length;

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------
path ellipsePath(pair c, real rx, real ry)
{
  return shift(c) * scale(rx, ry) * unitcircle;
}

// visible front half of an ellipse (right/front cue)
path frontHalfEllipse(pair c, real rx, real ry)
{
  return shift(c) * scale(rx, ry) * arc((0,0), 1, -20, 200);
}

// hidden back half
path backHalfEllipse(pair c, real rx, real ry)
{
  return shift(c) * scale(rx, ry) * arc((0,0), 1, 200, 340);
}

// ------------------------------------------------------------
// GLOBAL LAYOUT
// ------------------------------------------------------------
real sx = 1.25;        // radial scale
real sz = 1.10;        // z scale

pair L = (0,0);        // left panel origin
pair R = (8.4,0);      // right panel origin

// ------------------------------------------------------------
// LEFT PANEL: rz PROFILE
// ------------------------------------------------------------

// axes extents
real zMin = min(zPlane) * sz - 0.8;
real zMax = max(zPlane) * sz + 0.8;
real rMax = max(rOuter) * sx + 0.9;

// title
//label("\textbf{polyconeA: profile definition}", L + (1.75, zMax + 0.35), N);

// axes
draw(L + (0, zMin) -- L + (0, zMax), axisPen, Arrow);
draw(L + (0, 0)    -- L + (rMax, 0), axisPen, Arrow);

label("$z$", L + (0, zMax), N);
label("$r$", L + (rMax, 0), E);

// build profile points
pair[] pout;
pair[] pin;

for(int i = 0; i < nP; ++i)
{
  pair po = L + (rOuter[i]*sx, zPlane[i]*sz);
  pair pi = L + (rInner[i]*sx, zPlane[i]*sz);

  pout.push(po);
  pin.push(pi);
}

// draw outer and inner profile
for(int i = 0; i < nP-1; ++i)
{
  draw(pout[i] -- pout[i+1], edgePen);
  draw(pin[i]  -- pin[i+1],  guidePen);
}

// draw plane sections and selected annotations
int[] idx = {0, 1, nP-1};

for(int k = 0; k < idx.length; ++k)
{
  int i = idx[k];

  real zz = zPlane[i]*sz;
  real ro = rOuter[i]*sx;
  real ri = rInner[i]*sx;

  // full plane guide
  draw(L + (0, zz) -- L + (ro, zz), guidePen);

  // z_i label
  label("$z_{"+string(i)+"}$", L + (0, zz), W);

  // outer radius arrow
  draw(L + (0, zz) -- L + (ro, zz), dimPen, Arrow);
  label("$r^{\mathrm{out}}_{"+string(i)+"}$", L + (0.5*ro, zz + 0.20), N);

  // inner radius arrow
  if(ri > 0)
  {
    draw(L + (0, zz) -- L + (ri, zz), hiddenPen, Arrow);
    label("$r^\mathrm{in}_{"+string(i)+"}$", L + (0.5*ri, zz - 0.24), S);
  }

  dot(L + (ro, zz));
  if(ri > 0) dot(L + (ri, zz));
}

// axis-side array hints
label("$z\mathrm{Plane}[i]$", L + (-0.42, 0.50*(zMin+zMax)), W);
label("$r\mathrm{Inner}[i]$", L + (rMax - 0.15, zMin + 0.55), E);
label("$r\mathrm{Outer}[i]$", L + (rMax - 0.15, zMin + 0.95), E);

// revolution hint
pair cRot = L + (rMax - 0.65, zMax - 0.70);
draw(shift(cRot) * scale(0.40, 0.25) * arc((0,0), 1, 20, 330), guidePen, Arrow);
//label("rotate around $z$", cRot + (0, 0.48), N);

// ------------------------------------------------------------
// RIGHT PANEL: SCHEMATIC 3D REVOLVED CUE
// ------------------------------------------------------------

//label("\textbf{resulting revolved solid}", R + (2.0, zMax + 0.35), N);

// local perspective parameters
real ey = 0.23;      // ellipse flattening
real cutFrac = 0.22; // small cutaway wedge fraction

// transformed centers
pair[] C;
for(int i = 0; i < nP; ++i)
{
  C.push(R + (0, zPlane[i]*sz));
}

// fill front side bands (outer shell, schematic)
for(int i = 0; i < nP-1; ++i)
{
  real ro1 = rOuter[i]*sx;
  real ro2 = rOuter[i+1]*sx;

  pair A1 = C[i]   + ( ro1, 0);
  pair A2 = C[i+1] + ( ro2, 0);
  pair B2 = C[i+1] + (-ro2, 0);
  pair B1 = C[i]   + (-ro1, 0);

  fill(B1 -- A1 -- A2 -- B2 -- cycle, fillOuter);
}

// fill inner hollow band very lightly by masking center strips
for(int i = 0; i < nP-1; ++i)
{
  real ri1 = rInner[i]*sx;
  real ri2 = rInner[i+1]*sx;

  pair A1 = C[i]   + ( ri1, 0);
  pair A2 = C[i+1] + ( ri2, 0);
  pair B2 = C[i+1] + (-ri2, 0);
  pair B1 = C[i]   + (-ri1, 0);

  fill(B1 -- A1 -- A2 -- B2 -- cycle, white);
}

// draw outer ellipses and inner ellipses at each z plane
for(int i = 0; i < nP; ++i)
{
  real ro = rOuter[i]*sx;
  real ri = rInner[i]*sx;

  // outer top/bottom rings
  draw(frontHalfEllipse(C[i], ro, ey*ro), edgePen);
  draw(backHalfEllipse (C[i], ro, ey*ro), hiddenPen);

  // inner ring
  if(ri > 0)
  {
    draw(frontHalfEllipse(C[i], ri, ey*ri), edgePen);
    draw(backHalfEllipse (C[i], ri, ey*ri), hiddenPen);
  }
}

// draw visible outer side generators
for(int i = 0; i < nP-1; ++i)
{
  real ro1 = rOuter[i]*sx;
  real ro2 = rOuter[i+1]*sx;
  real ri1 = rInner[i]*sx;
  real ri2 = rInner[i+1]*sx;

  // outer visible right side
  draw(C[i] + ( ro1, 0) -- C[i+1] + ( ro2, 0), edgePen);

  // outer hidden left side
  draw(C[i] + (-ro1, 0) -- C[i+1] + (-ro2, 0), hiddenPen);

  // inner visible right side
  if(ri1 > 0 || ri2 > 0)
    draw(C[i] + ( ri1, 0) -- C[i+1] + ( ri2, 0), edgePen);

  // inner hidden left side
  if(ri1 > 0 || ri2 > 0)
    draw(C[i] + (-ri1, 0) -- C[i+1] + (-ri2, 0), hiddenPen);
}

// simple cutaway wedge on the front-right side
for(int i = 0; i < nP-1; ++i)
{
  real ro1 = rOuter[i]*sx;
  real ro2 = rOuter[i+1]*sx;
  real ri1 = rInner[i]*sx;
  real ri2 = rInner[i+1]*sx;

  pair P1 = C[i]   + ( cutFrac*ro1,  0.95*ey*ro1);
  pair P2 = C[i+1] + ( cutFrac*ro2,  0.95*ey*ro2);
  pair Q2 = C[i+1] + ( cutFrac*ri2,  0.95*ey*ri2);
  pair Q1 = C[i]   + ( cutFrac*ri1,  0.95*ey*ri1);

  fill(P1 -- P2 -- Q2 -- Q1 -- cycle, fillCut);
  draw(P1 -- P2, edgePen);
  draw(Q1 -- Q2, edgePen);
}

// selected z-plane guides on 3D cue
for(int k = 0; k < idx.length; ++k)
{
  int i = idx[k];
  real ro = rOuter[i]*sx;

  draw(C[i] + (-1.10*ro, 0) -- C[i] + (1.10*ro, 0), guidePen);
}

// subtle axis hint on 3D cue
draw(R + (0, zMin) -- R + (0, zMax), axisPen);
label("$z$", R + (0, zMax), N);

// ------------------------------------------------------------
// OVERALL NOTE
// ------------------------------------------------------------
//label("schematic only: profile defines the solid", (7.3, zMin - 0.55), S);
