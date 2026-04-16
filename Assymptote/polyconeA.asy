// ============================================================
// polyconeA — schematic (rz profile, minimal)
// Parameters:
//   zPlane[], rInner[], rOuter[]
// ============================================================

import three;

settings.outformat = "pdf";
settings.prc = false;
settings.render = 4;
size(11cm, 0);
usepackage("amsmath");

// ---------- STYLE ----------
pen axisPen   = rgb(0.2,0.3,0.6) + 0.7;
pen guidePen  = gray(0.6) + 0.5;
pen outerPen  = black + 1.2;
pen innerPen  = dashed + gray(0.4);
pen dimPen    = black + 0.8;


// ---------- DATA (example) ----------
real[] zPlane = {-2, -1, 1, 3};
real[] rInner = {0.5, 0.8, 0.6, 0.9};
real[] rOuter = {1.5, 1.8, 1.6, 2.0};

int N = zPlane.length;

// ---------- AXES ----------
draw((0,-3)--(0,4), axisPen, Arrow);
draw((0,0)--(3.5,0), axisPen, Arrow);

label("$z$", (0,4), N);
label("$r$", (3.5,0), E);

// ---------- OUTER PROFILE ----------
for(int i=0; i<N-1; ++i)
  draw((rOuter[i], zPlane[i]) -- (rOuter[i+1], zPlane[i+1]), outerPen);

// ---------- INNER PROFILE ----------
for(int i=0; i<N-1; ++i)
  draw((rInner[i], zPlane[i]) -- (rInner[i+1], zPlane[i+1]), innerPen);

// ---------- GUIDE PLANES (only key ones) ----------
int[] idx = {0, 1, N-1};  // show first, one middle, last

for(int k=0; k<idx.length; ++k) {
  int i = idx[k];

  draw((0, zPlane[i]) -- (rOuter[i], zPlane[i]), guidePen);

  // plane label
  label("$z_{"+string(i)+"}$", (0, zPlane[i]), W);

  // outer radius
  draw((0, zPlane[i]) -- (rOuter[i], zPlane[i]), dimPen, Arrow);
  label("$r^{\mathrm{out}}_{"+string(i)+"}$", (rOuter[i]/2, zPlane[i] + 0.2), N);

  // inner radius (only if nonzero)
  if(rInner[i] > 0) {
    draw((0, zPlane[i]) -- (rInner[i], zPlane[i]), innerPen, Arrow);
    label("$r^{\mathrm{in}}_{"+string(i)+"}$",(rInner[i]/2, zPlane[i] - 0.3), S);
  }
}

// ---------- REVOLUTION INDICATION ----------
real zmid = (zPlane[0] + zPlane[N-1]) / 2;

draw(shift(2.5, zmid) * arc((0,0), 0.7, 0, 300), guidePen, Arrow);
label("rotation around $z$", (2.5, zmid + 1.0));

// ---------- TITLE ----------
label("\textbf{polyconeA (rz profile)}",(1.8, 3.5));
