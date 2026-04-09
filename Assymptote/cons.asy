import three;
import graph3;

// ---------------------------------
// Output / quality
// ---------------------------------
settings.outformat = "pdf";
settings.prc = false;
settings.render = 4;
size(11cm, 0);

// ---------------------------------
// Camera
// ---------------------------------
currentprojection = perspective(
  camera=(8,6,4),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ---------------------------------
// Parameters
// Geant4 / musrSim style:
// cons rmin1 rmax1 rmin2 rmax2 hz phi0 dphi
// z = -hz  -> suffix 1
// z = +hz  -> suffix 2
// ---------------------------------
real rmin1 = 1.05;
real rmax1 = 2.45;
real rmin2 = 0.55;
real rmax2 = 1.75;
real hz    = 1.35;
real phi0  = 70;
real dphi  = 220;

// ---------------------------------
// Styles
// ---------------------------------
pen edgepen   = linewidth(0.85bp) + black;
pen axispen   = linewidth(0.50bp) + rgb(0.10,0.28,0.55);
pen dimpen    = linewidth(0.80bp) + black;
pen dimtext   = black;
pen guidepen  = linewidth(0.45bp) + gray(0.55);
pen centerpen = linetype(new real[] {18,6,2,6}) + linewidth(0.55bp) + gray(0.40);

material solidmat = material(
  diffusepen  = opacity(0.58) + rgb(0.78,0.84,0.90),
  emissivepen = gray(0.25),
  specularpen = gray(0.15)
);

Label Lbl(string s, pen p=currentpen) {
  return Label(s, p=p, Fill(white));
}

// ---------------------------------
// Helpers
// ---------------------------------
triple P(real r, real phi, real z) {
  pair q = r*dir(phi);
  return (q.x, q.y, z);
}

path3 arc3(real r, real z, real a0, real a1, int n=72) {
  guide3 g = P(r,a0,z);
  for(int i=1; i<=n; ++i) {
    real a = a0 + (a1-a0)*i/n;
    g = g -- P(r,a,z);
  }
  return g;
}

real rlin(real r1, real r2, real v) {
  return r1 + (r2-r1)*v;
}

// ---------------------------------
// Parametric surfaces
// ---------------------------------
triple fOuter(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real phi = phi0 + dphi*u;
  real z   = -hz + 2*hz*v;
  real r   = rlin(rmax1,rmax2,v);
  return P(r,phi,z);
}

triple fInner(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real phi = phi0 + dphi*u;
  real z   = -hz + 2*hz*v;
  real r   = rlin(rmin1,rmin2,v);
  return P(r,phi,z);
}

triple fTop(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r   = rmin2 + (rmax2-rmin2)*u;
  real phi = phi0 + dphi*v;
  return P(r,phi,hz);
}

triple fBot(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r   = rmin1 + (rmax1-rmin1)*u;
  real phi = phi0 + dphi*v;
  return P(r,phi,-hz);
}

triple fCut0(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real z = -hz + 2*hz*v;
  real ra = rlin(rmin1,rmin2,v);
  real rb = rlin(rmax1,rmax2,v);
  real r  = ra + (rb-ra)*u;
  return P(r,phi0,z);
}

triple fCut1(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real z = -hz + 2*hz*v;
  real ra = rlin(rmin1,rmin2,v);
  real rb = rlin(rmax1,rmax2,v);
  real r  = ra + (rb-ra)*u;
  return P(r,phi0+dphi,z);
}

surface sOuter = surface(fOuter,(0,0),(1,1),36,12);
surface sInner = surface(fInner,(0,0),(1,1),36,12);
surface sTop   = surface(fTop,  (0,0),(1,1),10,36);
surface sBot   = surface(fBot,  (0,0),(1,1),10,36);
surface sCut0  = surface(fCut0, (0,0),(1,1),10,12);
surface sCut1  = surface(fCut1, (0,0),(1,1),10,12);

// ---------------------------------
// Draw solid faces
// ---------------------------------
draw(sOuter, solidmat);
draw(sInner, solidmat);
draw(sTop,   solidmat);
draw(sBot,   solidmat);
draw(sCut0,  solidmat);
draw(sCut1,  solidmat);

// ---------------------------------
// Draw edges
// ---------------------------------
draw(arc3(rmax1,-hz,phi0,phi0+dphi), edgepen);
draw(arc3(rmin1,-hz,phi0,phi0+dphi), edgepen);
draw(arc3(rmax2, hz,phi0,phi0+dphi), edgepen);
draw(arc3(rmin2, hz,phi0,phi0+dphi), edgepen);

draw(P(rmin1,phi0,-hz)      -- P(rmax1,phi0,-hz),      edgepen);
draw(P(rmin1,phi0+dphi,-hz) -- P(rmax1,phi0+dphi,-hz), edgepen);
draw(P(rmin2,phi0, hz)      -- P(rmax2,phi0, hz),      edgepen);
draw(P(rmin2,phi0+dphi, hz) -- P(rmax2,phi0+dphi, hz), edgepen);

draw(P(rmax1,phi0,-hz)      -- P(rmax2,phi0,hz),       edgepen);
draw(P(rmax1,phi0+dphi,-hz) -- P(rmax2,phi0+dphi,hz),  edgepen);
draw(P(rmin1,phi0,-hz)      -- P(rmin2,phi0,hz),       edgepen);
draw(P(rmin1,phi0+dphi,-hz) -- P(rmin2,phi0+dphi,hz),  edgepen);

// ---------------------------------
// Axes (small, internal)
// ---------------------------------
triple O = (0,0,0);
real L = 0.5;

draw(O--(L,0,0), axispen, Arrow3(5));
draw(O--(0,L,0), axispen, Arrow3(5));
draw(O--(0,0,L), axispen, Arrow3(5));

label(Lbl("$x$", axispen), (L,0,0), N);
label(Lbl("$y$", axispen), (0,L,0), N);
label(Lbl("$z$", axispen), (0,0,L), E);

// ---------------------------------
// Symmetry / center line
// ---------------------------------
draw((0,0,-hz-1.2)--(0,0,hz+0.8), centerpen);

// ---------------------------------
// Dimension annotations
// ---------------------------------
real aR = phi0 + dphi;

// r_max1 on lower face
triple rmax1a = P(0,     aR, -hz-1.2);
triple rmax1b = P(rmax1, aR, -hz-1.2);
draw(rmax1a--rmax1b, dimpen, Arrows3(4));
draw(P(rmax1,aR,-hz)--rmax1b, guidepen);
label(Lbl("$r_{\max 1}$", dimtext), midpoint(rmax1a--rmax1b), N);

// r_min1 on lower face
triple rmin1a = P(0,     aR, -hz-0.85);
triple rmin1b = P(rmin1, aR, -hz-0.85);
draw(rmin1a--rmin1b, dimpen, Arrows3(4));
draw(P(rmin1,aR,-hz)--rmin1b, guidepen);
label(Lbl("$r_{\min 1}$", dimtext), midpoint(rmin1a--rmin1b), N);

// r_max2 on upper face
triple rmax2a = P(0,     aR, hz+0.8);
triple rmax2b = P(rmax2, aR, hz+0.8);
draw(rmax2a--rmax2b, dimpen, Arrows3(4));
draw(P(rmax2,aR,hz)--rmax2b, guidepen);
label(Lbl("$r_{\max 2}$", dimtext), midpoint(rmax2a--rmax2b), N);

// r_min2 on upper face
triple rmin2a = P(0,     aR, hz+0.5);
triple rmin2b = P(rmin2, aR, hz+0.5);
draw(rmin2a--rmin2b, dimpen, Arrows3(4));
draw(P(rmin2,aR,hz)--rmin2b, guidepen);
label(Lbl("$r_{\min 2}$", dimtext), midpoint(rmin2a--rmin2b), N);

// height 2 h_z
triple dz1 = P(rmax1+0.1, aR, -hz);
triple dz2 = P(rmax1+0.1, aR,  hz);
draw(dz1--dz2, dimpen, Arrows3(4));
draw(P(rmax1,aR,-hz)--dz1, guidepen);
draw(P(rmax2,aR, hz)--dz2, guidepen);
label(Lbl("$2h_z$", dimtext), midpoint(dz1--dz2), E);

// phi_0
real rphi0 = 0.75*rmin1;
draw(arc3(rphi0,-hz,0,phi0), dimpen, Arrow3(3));
draw((0,0,-hz)--P(rmin1,0,-hz), guidepen, Arrow3(3));
draw((0,0,-hz)--P(rmin1,phi0,-hz), guidepen);
label(Lbl("$x$"), P(rmin1,0,-hz), N);
label(Lbl("$\phi_0$", dimtext), P(rphi0,0.7*phi0,-hz), S);

// Delta phi
real rdphi = 0.48*rmin1;
draw(arc3(rdphi,-hz,phi0,phi0+dphi), dimpen, Arrow3(3));
draw((0,0,-hz)--P(rmin1,phi0+dphi,-hz), guidepen);
label(Lbl("$\Delta\phi$", dimtext), P(1.2*rdphi,phi0+0.9*dphi,-hz), W);
