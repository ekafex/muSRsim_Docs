import three;

settings.outformat = "pdf";
settings.prc = false;
settings.render = 4;
size(11cm,0);

// ------------------------------------------------------------
// Camera
// ------------------------------------------------------------
currentprojection = perspective(
  camera=(6,6,4),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ------------------------------------------------------------
// Style
// ------------------------------------------------------------
pen edgepen  = linewidth(0.85bp) + black;
pen guidepen = linewidth(0.45bp) + gray(0.60);
pen dimpen   = linewidth(0.80bp) + black;
pen axispen  = linewidth(0.50bp) + rgb(0.10,0.28,0.55);

material solidmat = material(
  diffusepen  = opacity(0.58) + rgb(0.78,0.84,0.90),
  emissivepen = gray(0.20),
  specularpen = gray(0.15)
);

Label Lbl(string s, pen p=currentpen) {
  return Label(s, p=p, Fill(white));
}

// ------------------------------------------------------------
// Parameters (example)
// G4Trd: dx1 dx2 dy1 dy2 dz
// These are HALF-LENGTHS in Geant4
// ------------------------------------------------------------
/*
real hx1 = 0.90;   // x half-length at z = -hz
real hx2 = 1.55;   // x half-length at z = +hz
real hy1 = 0.65;   // y half-length at z = -hz
real hy2 = 1.10;   // y half-length at z = +hz
real hz  = 1.45;
*/

real hx1 = 1.6;   // x half-length at z = -hz
real hx2 = 0.9;   // x half-length at z = +hz
real hy1 = 1.1;   // y half-length at z = -hz
real hy2 = 0.7;   // y half-length at z = +hz
real hz  = 1.5;

// ------------------------------------------------------------
// Vertices
// z = -hz face
// ------------------------------------------------------------
triple A = (-hx1,-hy1,-hz);
triple B = ( hx1,-hy1,-hz);
triple C = ( hx1, hy1,-hz);
triple D = (-hx1, hy1,-hz);

// z = +hz face
triple E = (-hx2,-hy2, hz);
triple F = ( hx2,-hy2, hz);
triple G = ( hx2, hy2, hz);
triple H = (-hx2, hy2, hz);

// ------------------------------------------------------------
// Faces
// ------------------------------------------------------------
draw(surface(A--B--C--D--cycle), solidmat);
draw(surface(E--F--G--H--cycle), solidmat);
draw(surface(A--B--F--E--cycle), solidmat);
draw(surface(B--C--G--F--cycle), solidmat);
draw(surface(C--D--H--G--cycle), solidmat);
draw(surface(D--A--E--H--cycle), solidmat);

// edges
draw(A--B--C--D--cycle, edgepen);
draw(E--F--G--H--cycle, edgepen);
draw(A--E, edgepen);
draw(B--F, edgepen);
draw(C--G, edgepen);
draw(D--H, edgepen);

// ------------------------------------------------------------
// Small internal axes
// ------------------------------------------------------------
triple O = (0,0,0);
real La = 0.55;

draw(O--(La,0,0), axispen, Arrow3(5));
draw(O--(0,La,0), axispen, Arrow3(5));
draw(O--(0,0,La), axispen, Arrow3(5));

label(Lbl("$x$"), (La,0,0), E);
label(Lbl("$y$"), (0,La,0), NW);
label(Lbl("$z$"), (0,0,La), N);

// ------------------------------------------------------------
// Dimension helpers
// ------------------------------------------------------------
triple midpt(triple P, triple Q) { return 0.5*(P+Q); }

// ------------------------------------------------------------
// 2h_x^(1) on z=-hz face
// ------------------------------------------------------------
triple x1a = C + (0,0.22,0);
triple x1b = D + (0,0.22,0);
draw(C--x1a, guidepen);
draw(D--x1b, guidepen);
draw(x1a--x1b, dimpen, Arrows3(4));
label(Lbl("$2h_{x1}$"), midpt(x1a,x1b), SE);

// ------------------------------------------------------------
// 2h_x^(2) on z=+hz face
// ------------------------------------------------------------
triple x2a = G + (0,0.7,0);
triple x2b = H + (0,0.7,0);
draw(G--x2a, guidepen);
draw(H--x2b, guidepen);
draw(x2a--x2b, dimpen, Arrows3(4));
label(Lbl("$2h_{x2}$"), midpt(x2a,x2b), SE);

// ------------------------------------------------------------
// 2h_y^(1) on z=-hz face
// ------------------------------------------------------------
triple y1a = B + (0.22,0,0);
triple y1b = C + (0.22,0,0);
draw(B--y1a, guidepen);
draw(C--y1b, guidepen);
draw(y1a--y1b, dimpen, Arrows3(4));
label(Lbl("$2h_{y1}$"), midpt(y1a,y1b), W);

// ------------------------------------------------------------
// 2h_y^(2) on z=+hz face
// ------------------------------------------------------------
triple y2a = F + (0.7,0,0);
triple y2b = G + (0.7,0,0);
draw(F--y2a, guidepen);
draw(G--y2b, guidepen);
draw(y2a--y2b, dimpen, Arrows3(4));
label(Lbl("$2h_{y2}$"), midpt(y2a,y2b), SW);

// ------------------------------------------------------------
// 2h_z along a visible slanted side
// ------------------------------------------------------------
triple z1 = (hx1+0.32,-hy1,-hz);
triple z2 = (hx1+0.32,-hy2,hz);
draw(A--z1, guidepen);
draw(E--z2, guidepen);
draw(z1--z2, dimpen, Arrows3(4));
label(Lbl("$2h_z$"), midpt(z1,z2), W);

