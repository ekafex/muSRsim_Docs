import three;

settings.outformat = "pdf";
settings.prc = false;
settings.render = 4;
size(11cm,0);

// ------------------------------------------------------------
// Camera
// ------------------------------------------------------------
currentprojection = perspective(
  camera=(7.2,5.4,4.0),
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
// Parameters (example values)
// Geant4 G4Para:
//   hx, hy, hz, alpha, theta, phi
// half-lengths + skew angles
// ------------------------------------------------------------
real hx = 1.20;
real hy = 0.9;
real hz = 1.5;

real alpha = 20;   // shear of x with z
real theta = 30;   // direction of lateral edge wrt z
real phi   = 40;   // azimuth of that direction

// ------------------------------------------------------------
// Skew vectors
// ------------------------------------------------------------

// global shift of the top face relative to bottom face
triple s = hz*tan(theta) * (sin(theta) != 0 ? unit((sin(theta)*cos(phi), sin(theta)*sin(phi), 0)) : (0,0,0));

// x-shear inside top/bottom faces due to alpha
triple ax = hy*tan(alpha) * X;

// local spanning vectors
triple ex = (hx,0,0);
triple ey = ax + (0,hy,0);

// ------------------------------------------------------------
// Vertices
// Bottom face centered at -s/2, top face at +s/2
// ------------------------------------------------------------
triple cb = -0.5*s - (0,0,hz);
triple ct =  0.5*s + (0,0,hz);

// bottom
triple A = cb - ex - ey;
triple B = cb + ex - ey;
triple C = cb + ex + ey;
triple D = cb - ex + ey;

// top
triple E = ct - ex - ey;
triple F = ct + ex - ey;
triple G = ct + ex + ey;
triple H = ct - ex + ey;

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
// Helper
// ------------------------------------------------------------
triple midpt(triple P, triple Q) { return 0.5*(P+Q); }

// ------------------------------------------------------------
// 2h_x
// placed on front lower edge
// ------------------------------------------------------------
triple x1 = A + (0,-0.24,0);
triple x2 = B + (0,-0.24,0);
draw(A--x1, guidepen);
draw(B--x2, guidepen);
draw(x1--x2, dimpen, Arrows3(4));
label(Lbl("$2h_x$"), midpt(x1,x2), S);

// ------------------------------------------------------------
// 2h_y
// placed on right bottom edge direction
// ------------------------------------------------------------
triple y1 = B + (0.26,0,0);
triple y2 = C + (0.26,0,0);
draw(B--y1, guidepen);
draw(C--y2, guidepen);
draw(y1--y2, dimpen, Arrows3(4));
label(Lbl("$2h_y$"), midpt(y1,y2), E);

// ------------------------------------------------------------
// 2h_z
// placed on visible left slanted vertical edge
// ------------------------------------------------------------
triple z1 = A + (-0.28,0,0);
triple z2 = E + (-0.28,0,0);
draw(A--z1, guidepen);
draw(E--z2, guidepen);
draw(z1--z2, dimpen, Arrows3(4));
label(Lbl("$2h_z$"), midpt(z1,z2), W);

// ------------------------------------------------------------
// Angle alpha (shown in a face-parallel schematic way)
// ------------------------------------------------------------
real aLen = 0.55;
triple a0 = D + 0.12*unit(C-D);
triple aRef1 = a0 + aLen*Y;
triple aRef2 = a0 + aLen*unit((C-D));

draw(a0--aRef1, guidepen);
draw(a0--aRef2, guidepen);

label(Lbl("$\alpha$"), a0 + 0.42*(unit(aRef1-a0)+unit(aRef2-a0)), NE);

// ------------------------------------------------------------
// Theta / phi indicator using top-face center and shift vector
// ------------------------------------------------------------
triple P0 = (0,0,0);
triple P1 = 0.55*unit(s == (0,0,0) ? (1,1,0) : s);
triple Pz = (0,0,0.75);

draw(P0--P1, guidepen);
draw(P0--Pz, guidepen);

label(Lbl("$\theta,\phi$"), P1, E);
