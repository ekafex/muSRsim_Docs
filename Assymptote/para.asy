import three;

settings.outformat = "pdf";
settings.prc = false;
settings.render = 4;
size(11cm,0);

// ============================================================
// Camera
// ============================================================
currentprojection = perspective(
  camera=(7,5,3),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ============================================================
// Style
// ============================================================
pen edgepen  = linewidth(0.85bp) + black;
pen guidepen = linewidth(0.45bp) + gray(0.65);
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

// ============================================================
// Parameters
// G4Para(hx, hy, hz, alpha, theta, phi)
// hx, hy, hz are HALF-LENGTHS
// alpha : shear of the face in x as y changes
// theta, phi : direction of the shift vector of the top face
// ============================================================
real hx = 1.2;
real hy = 0.9;
real hz = 1.5;

real alpha = 30;   // degrees
real theta = 30;   // degrees
real phi   = 40;   // degrees

// ============================================================
// Helpers
// ============================================================
real deg(real x) { return x*pi/180; }

triple normalize(triple v)
{
  real a = abs(v);
  if(a == 0) return (0,0,0);
  return v/a;
}

triple midpt(triple A, triple B) { return 0.5*(A+B); }

path3 arcPlane(triple C, real r, triple e1, triple e2,
               real a0, real a1, int n=48)
{
  guide3 g;
  for(int i=0; i<=n; ++i) {
    real a = a0 + (a1-a0)*i/n;
    triple P = C + r*(cos(a)*e1 + sin(a)*e2);
    if(i == 0) g = P;
    else g = g -- P;
  }
  return g;
}

// ============================================================
// Geometry construction
// ============================================================

// Shear inside each z-face:
// y-directed edge has an x-component controlled by alpha
triple ex = (hx,0,0);
triple ey = (hy*tan(deg(alpha)), hy, 0);

// Global shift of top face relative to bottom face:
// direction set by theta, phi
real sh = 2*hz*tan(deg(theta));
triple d = (sh*cos(deg(phi)), sh*sin(deg(phi)), 0);

// Centers of bottom and top faces
triple cb = -0.5*d - (0,0,hz);
triple ct =  0.5*d + (0,0,hz);

// Bottom face
triple A = cb - ex - ey;
triple B = cb + ex - ey;
triple C = cb + ex + ey;
triple D = cb - ex + ey;

// Top face
triple E = ct - ex - ey;
triple F = ct + ex - ey;
triple G = ct + ex + ey;
triple H = ct - ex + ey;

// ============================================================
// Draw solid
// ============================================================
draw(surface(A--B--C--D--cycle), solidmat);
draw(surface(E--F--G--H--cycle), solidmat);
draw(surface(A--B--F--E--cycle), solidmat);
draw(surface(B--C--G--F--cycle), solidmat);
draw(surface(C--D--H--G--cycle), solidmat);
draw(surface(D--A--E--H--cycle), solidmat);

draw(A--B--C--D--cycle, edgepen);
draw(E--F--G--H--cycle, edgepen);
draw(A--E, edgepen);
draw(B--F, edgepen);
draw(C--G, edgepen);
draw(D--H, edgepen);

// ============================================================
// Small internal axes
// ============================================================
triple O = (0,0,0);
real La = 0.55;

draw(O--(La,0,0), axispen, Arrow3(5));
draw(O--(0,La,0), axispen, Arrow3(5));
draw(O--(0,0,La), axispen, Arrow3(5));

label(Lbl("$x$"), (La,0,0), E);
label(Lbl("$y$"), (0,La,0), NW);
label(Lbl("$z$"), (0,0,La), N);

// ============================================================
// Dimensions
// ============================================================

// 2hx on front lower edge
triple x1 = C + (0,0.23,0);
triple x2 = D + (0,0.23,0);
draw(C--x1, guidepen);
draw(D--x2, guidepen);
draw(x1--x2, dimpen, Arrows3(4));
label(Lbl("$2h_x$"), midpt(x1,x2), S);

// 2hy on lower right edge direction inside bottom face
triple y1 = B + (0.24,0,0);
triple y2 = C + (0.24,0,0);
draw(B--y1, guidepen);
draw(C--y2, guidepen);
draw(y1--y2, dimpen, Arrows3(4));
label(Lbl("$2h_y$"), midpt(y1,y2), W);

// 2hz on left visible side
triple z1 = B + (0.2,0,0);
triple z2 = F + (0.2,0,0);
draw(B--z1, guidepen);
draw(F--z2, guidepen);
draw(z1--z2, dimpen, Arrows3(4));
label(Lbl("$2h_z$"), midpt(z1,z2), W);


// ============================================================
// Angle constructions
// ============================================================

// ------------------------------------------------------------
// 1) alpha
// alpha = angle between pure +y and skewed in-face direction ey
// ------------------------------------------------------------
triple eyPure = normalize((0,1,0));
triple eySkew = normalize(ey);

// place local construction on the bottom face near edge BC
triple Palpha = B + 0.22*(C-B) + 0.10*(D-A);

real ra = 0.22;
real alphaRad = atan2(eySkew.x, eySkew.y);

// two guide rays
draw(Palpha--(Palpha + 0.55*eyPure), guidepen);
draw(Palpha--(Palpha + 0.55*eySkew), guidepen);

// clean arc from +y to skewed direction, in the bottom-face plane
draw(arcPlane(Palpha, ra, eyPure, (1,0,0), 0, alphaRad), dimpen);

label(Lbl("$\alpha$"), Palpha + 0.38*normalize(eyPure + eySkew), E);

// ------------------------------------------------------------
// 2) theta and phi
//
// s  = vector from bottom-face center to top-face center
// sp = projection of s onto xy-plane
//
// theta = angle between s and +z
// phi   = azimuth of sp measured from +x
// ------------------------------------------------------------
triple s  = ct - cb;
triple sp = (s.x, s.y, 0);

triple es  = normalize(s);
triple esp = normalize(sp);
triple exy = (1,0,0);
triple eyy = (0,1,0);
triple ez  = (0,0,1);

// local origin for the construction
triple P0 = O + (0.02,0.02,-0.02);

// reference rays
draw(P0--(P0 + 0.62*exy), guidepen);   // +x reference for phi
draw(P0--(P0 + 0.72*ez),  guidepen);   // +z reference for theta
draw(P0--(P0 + 0.62*esp), guidepen);   // projection of s
draw(P0--(P0 + 0.84*es),  dimpen, Arrow3(5)); // s itself

label(Lbl("$\vec{s}$"), P0 + 0.92*es, E);

// phi arc in xy-plane: from +x to projected direction
if(abs(sp) > 0) {
  path3 phiarc = arcPlane(P0, 0.22, exy, eyy, 0, deg(phi), 40);
  draw(phiarc, dimpen);
  label(Lbl("$\phi$"), P0 + 0.30*normalize(exy + esp), S);
}

// theta arc in plane spanned by z and sp: from +z to s
if(abs(sp) > 0) {
  path3 tharc = arcPlane(P0, 0.30, ez, esp, 0, deg(theta), 40);
  draw(tharc, dimpen);
  label(Lbl("$\theta$"), P0 + 0.39*normalize(ez + es), E);
}
