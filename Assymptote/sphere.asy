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
  camera=(7.2,5.4,3.2),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ---------------------------------
// Parameters
// Geant4 / musrSim style:
// sphere rmin rmax phi0 dphi theta0 dtheta
// theta is polar angle from +z
// ---------------------------------
real rmin   = 0.65;
real rmax   = 1.75;

real phi0   = 25;
real dphi   = 215;

real theta0 = 25;
real dtheta = 115;

// ---------------------------------
// Styles
// ---------------------------------
pen edgepen   = linewidth(0.85bp) + black;
pen axispen   = linewidth(0.5bp) + rgb(0.10,0.28,0.55);
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
triple Sph(real r, real theta, real phi)
{
  pair q = r*sin(theta)*dir(phi);
  return (q.x, q.y, r*cos(theta));
}

path3 arcTheta(real r, real theta, real phiA, real phiB, int n=96)
{
  guide3 g = Sph(r,theta,phiA);
  for(int i=1; i<=n; ++i) {
    real a = phiA + (phiB-phiA)*i/n;
    g = g -- Sph(r,theta,a);
  }
  return g;
}

path3 arcPhi(real r, real phi, real thA, real thB, int n=72)
{
  guide3 g = Sph(r,thA,phi);
  for(int i=1; i<=n; ++i) {
    real t = thA + (thB-thA)*i/n;
    g = g -- Sph(r,t,phi);
  }
  return g;
}

triple mid(path3 p, real t=0.5) { return relpoint(p,t); }

// ---------------------------------
// Parametric surfaces
// pair uv with u,v in [0,1]
// ---------------------------------

// outer spherical patch
triple fOuter(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real phi   = phi0   + dphi*u;
  real theta = theta0 + dtheta*v;
  return Sph(rmax,theta,phi);
}

// inner spherical patch
triple fInner(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real phi   = phi0   + dphi*u;
  real theta = theta0 + dtheta*v;
  return Sph(rmin,theta,phi);
}

// phi = phi0 cut
triple fCutPhi0(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real r     = rmin   + (rmax-rmin)*u;
  real theta = theta0 + dtheta*v;
  return Sph(r,theta,phi0);
}

// phi = phi0 + dphi cut
triple fCutPhi1(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real r     = rmin   + (rmax-rmin)*u;
  real theta = theta0 + dtheta*v;
  return Sph(r,theta,phi0+dphi);
}

// theta = theta0 cut  (conical annular sector)
triple fCutTheta0(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real r   = rmin + (rmax-rmin)*u;
  real phi = phi0 + dphi*v;
  return Sph(r,theta0,phi);
}

// theta = theta0 + dtheta cut
triple fCutTheta1(pair uv)
{
  real u = uv.x;
  real v = uv.y;
  real r   = rmin + (rmax-rmin)*u;
  real phi = phi0 + dphi*v;
  return Sph(r,theta0+dtheta,phi);
}

// ---------------------------------
// Surfaces
// ---------------------------------
surface sOuter     = surface(fOuter,     (0,0), (1,1), 48, 24);
surface sInner     = surface(fInner,     (0,0), (1,1), 48, 24);
surface sCutPhi0   = surface(fCutPhi0,   (0,0), (1,1), 10, 18);
surface sCutPhi1   = surface(fCutPhi1,   (0,0), (1,1), 10, 18);
surface sCutTheta0 = surface(fCutTheta0, (0,0), (1,1), 10, 48);
surface sCutTheta1 = surface(fCutTheta1, (0,0), (1,1), 10, 48);

// ---------------------------------
// Draw solid faces
// ---------------------------------
draw(sOuter,     solidmat);
draw(sInner,     solidmat);
draw(sCutPhi0,   solidmat);
draw(sCutPhi1,   solidmat);
draw(sCutTheta0, solidmat);
draw(sCutTheta1, solidmat);

// ---------------------------------
// Draw clean boundary edges
// ---------------------------------

// Outer spherical boundary
draw(arcTheta(rmax,theta0,       phi0,phi0+dphi), edgepen);
draw(arcTheta(rmax,theta0+dtheta,phi0,phi0+dphi), edgepen);
draw(arcPhi(rmax,phi0,           theta0,theta0+dtheta), edgepen);
draw(arcPhi(rmax,phi0+dphi,      theta0,theta0+dtheta), edgepen);

// Inner spherical boundary
draw(arcTheta(rmin,theta0,       phi0,phi0+dphi), edgepen);
draw(arcTheta(rmin,theta0+dtheta,phi0,phi0+dphi), edgepen);
draw(arcPhi(rmin,phi0,           theta0,theta0+dtheta), edgepen);
draw(arcPhi(rmin,phi0+dphi,      theta0,theta0+dtheta), edgepen);

// Radial edges joining inner/outer boundaries
draw(Sph(rmin,theta0,       phi0)      -- Sph(rmax,theta0,       phi0),      edgepen);
draw(Sph(rmin,theta0,       phi0+dphi) -- Sph(rmax,theta0,       phi0+dphi), edgepen);
draw(Sph(rmin,theta0+dtheta,phi0)      -- Sph(rmax,theta0+dtheta,phi0),      edgepen);
draw(Sph(rmin,theta0+dtheta,phi0+dphi) -- Sph(rmax,theta0+dtheta,phi0+dphi), edgepen);

// ---------------------------------
// Axes (small, internal)
// ---------------------------------
triple O = (0,0,0);
real L = 0.55;

draw(O--(L,0,0), axispen, Arrow3(5));
draw(O--(0,L,0), axispen, Arrow3(5));
draw(O--(0,0,L), axispen, Arrow3(5));

label(Lbl("$x$"), (L,0,0), N);
label(Lbl("$y$"), (0,L,0), N);
label(Lbl("$z$"), (0,0,L), E);

// ---------------------------------
// Center line (axially symmetric family)
// ---------------------------------
draw((0,0,-rmax-0.15)--(0,0,rmax+0.30), centerpen);

// ---------------------------------
// Dimension annotations
// ---------------------------------

// r_max
real phiR1 = phi0 + 0.72*dphi;
real thR1  = theta0 + 0.62*dtheta;
triple rmaxA = O;
triple rmaxB = Sph(rmax,thR1,phiR1);
draw(rmaxA--rmaxB, dimpen, Arrows3(4));
label(Lbl("$r_{\max}$", dimtext), mid(rmaxA--rmaxB,0.52), E);

// r_min
real phiR2 = phi0 + 0.48*dphi;
real thR2  = theta0 + 0.45*dtheta;
triple rminA = O;
triple rminB = Sph(rmin,thR2,phiR2);
draw(rminA--rminB, dimpen, Arrows3(4));
label(Lbl("$r_{\min}$", dimtext), mid(rminA--rminB,0.55), SW);

// phi_0 near lower/front region
real rphi = 0.62*rmax;
draw(arcTheta(rphi,theta0+dtheta,0,phi0,36), dimpen, Arrow3(3));
draw(O--Sph(rphi,theta0+dtheta,0), guidepen);
draw(O--Sph(rphi,theta0+dtheta,phi0), guidepen);
label(Lbl("$\phi_0$", dimtext), Sph(0.73*rphi,theta0+dtheta,0.52*phi0), S);

// Delta phi
real rDphi = 0.48*rmax;
draw(arcTheta(rDphi,theta0+dtheta,phi0,phi0+dphi,64), dimpen, Arrow3(3));
label(Lbl("$\Delta\phi$", dimtext), Sph(1.02*rDphi,theta0+dtheta,phi0+0.62*dphi), S);

// theta_0 in a visible phi-cut plane
real phiT = phi0 + dphi;
real rT0  = 0.72*rmax;
draw(arcPhi(rT0,phiT,0,theta0,36), dimpen, Arrow3(3));
draw(O--Sph(rT0,0,phiT), guidepen);
draw(O--Sph(rT0,theta0,phiT), guidepen);
label(Lbl("$\theta_0$", dimtext), Sph(1.02*rT0,0.56*theta0,phiT), E);

// Delta theta
real rDT = 0.92*rmax;
draw(arcPhi(rDT,phiT,theta0,theta0+dtheta,56), dimpen, Arrow3(3));
label(Lbl("$\Delta\theta$", dimtext), Sph(1.03*rDT,theta0+0.55*dtheta,phiT), E);
