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
  camera=(8,6,3),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ---------------------------------
// Parameters
// Geant4 / musrSim style:
// tubs rmin rmax hz phi0 dphi
// ---------------------------------
real rmin = 0.8;
real rmax = 2.0;
real hz   = 1.2;
real phi0 = 60;
real dphi = 250;

// ---------------------------------
// Styles
// ---------------------------------
pen edgepen   = linewidth(0.85bp) + black;
pen axispen   = linewidth(0.5bp) + rgb(0.10,0.28,0.55);
pen dimpen    = linewidth(0.80bp) + black;
pen dimtext   = black;


pen guidepen  = linewidth(0.45bp) + gray(0.55);
pen centerpen = linetype(new real[] {18,6,2,6}) + linewidth(0.55bp) + gray(0.40);
pen markpen   = rgb(0.75,0.12,0.12);

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

// ---------------------------------
// Parametric surfaces
// ---------------------------------
triple fOuter(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real phi = phi0 + dphi*u;
  real z   = -hz + 2*hz*v;
  return P(rmax,phi,z);
}

triple fInner(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real phi = phi0 + dphi*u;
  real z   = -hz + 2*hz*v;
  return P(rmin,phi,z);
}

triple fTop(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r   = rmin + (rmax-rmin)*u;
  real phi = phi0 + dphi*v;
  return P(r,phi,hz);
}

triple fBot(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r   = rmin + (rmax-rmin)*u;
  real phi = phi0 + dphi*v;
  return P(r,phi,-hz);
}

triple fCut0(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r = rmin + (rmax-rmin)*u;
  real z = -hz + 2*hz*v;
  return P(r,phi0,z);
}

triple fCut1(pair uv) {
  real u = uv.x;
  real v = uv.y;
  real r = rmin + (rmax-rmin)*u;
  real z = -hz + 2*hz*v;
  return P(r,phi0+dphi,z);
}

surface sOuter = surface(fOuter,(0,0),(1,1),36,10);
surface sInner = surface(fInner,(0,0),(1,1),36,10);
surface sTop   = surface(fTop,  (0,0),(1,1),10,36);
surface sBot   = surface(fBot,  (0,0),(1,1),10,36);
surface sCut0  = surface(fCut0, (0,0),(1,1),10,10);
surface sCut1  = surface(fCut1, (0,0),(1,1),10,10);

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
draw(arc3(rmax, hz,  phi0, phi0+dphi), edgepen);
draw(arc3(rmax,-hz,  phi0, phi0+dphi), edgepen);
draw(arc3(rmin, hz,  phi0, phi0+dphi), edgepen);
draw(arc3(rmin,-hz,  phi0, phi0+dphi), edgepen);

draw(P(rmin,phi0,      hz)--P(rmax,phi0,      hz), edgepen);
draw(P(rmin,phi0+dphi, hz)--P(rmax,phi0+dphi, hz), edgepen);
draw(P(rmin,phi0,     -hz)--P(rmax,phi0,     -hz), edgepen);
draw(P(rmin,phi0+dphi,-hz)--P(rmax,phi0+dphi,-hz), edgepen);

draw(P(rmax,phi0,     -hz)--P(rmax,phi0,      hz), edgepen);
draw(P(rmax,phi0+dphi,-hz)--P(rmax,phi0+dphi, hz), edgepen);
draw(P(rmin,phi0,     -hz)--P(rmin,phi0,      hz), edgepen);
draw(P(rmin,phi0+dphi,-hz)--P(rmin,phi0+dphi, hz), edgepen);

// ---------------------------------
// Axes
// ---------------------------------
triple O = (0,0,0);
real L = 0.5;

draw(O--(L,0,0), axispen, Arrow3(5));
draw(O--(0,L,0), axispen, Arrow3(5));
draw(O--(0,0,L), axispen, Arrow3(5));

label(Lbl("$x$"), (L,0,0), N);
label(Lbl("$y$"), (0,L,0), N);
label(Lbl("$z$"), (0,0,L), E);

// ---------------------------------
// Symmetry / center line
// ---------------------------------
draw((0,0,-hz-0.1)--(0,0,hz+0.7), centerpen);

// ---------------------------------
// Dimension annotations
// ---------------------------------

// r_max
real aR = phi0 + dphi;
triple rmax1 = P(0,    aR, hz+0.65);
triple rmax2 = P(rmax, aR, hz+0.65);
draw(rmax1--rmax2, dimpen, Arrows3(4));
draw(P(rmax,aR,hz)--rmax2, guidepen);
label(Lbl("$r_{\max}$", dimtext), midpoint(rmax1--rmax2), N);

// r_min
real aRi = phi0 + dphi;
triple rmin1 = P(0,    aRi, hz+0.35);
triple rmin2 = P(rmin, aRi, hz+0.35);
draw(rmin1--rmin2, dimpen, Arrows3(4));
draw(P(rmin,aRi,hz)--rmin2, guidepen);
label(Lbl("$r_{\min}$", dimtext), midpoint(rmin1--rmin2), N);

// height 2 h_z
real aZ = phi0 + dphi;
triple dz1 = P(rmax+0.20, aZ, -hz);
triple dz2 = P(rmax+0.20, aZ,  hz);
draw(dz1--dz2, dimpen, Arrows3(4));
draw(P(rmax,aZ,-hz)--dz1, guidepen);
draw(P(rmax,aZ, hz)--dz2, guidepen);
label(Lbl("$2h_z$", dimtext), midpoint(dz1--dz2), W);

// phi_0
draw(arc3(0.60*rmin,-hz,0,phi0), dimpen, Arrow3(3));
draw((0,0,-hz)--P(rmin+0.50,0,-hz), guidepen, Arrow3(3));
draw((0,0,-hz)--P(rmin,phi0,-hz), guidepen);
label(Lbl("$x$"), P(rmin+0.50,0,-hz), N);
label(Lbl("$\phi_0$", dimtext), P(0.8*rmin,0.50*phi0,-hz), S);

// Delta phi
draw(arc3(0.40*rmin,-hz,phi0,phi0+dphi), dimpen, Arrow3(3));
draw((0,0,-hz)--P(rmin,phi0+dphi,-hz), guidepen);
label(Lbl("$\Delta\phi$", dimtext), P(0.4*rmin,0.9*(phi0+dphi),-hz), W);

