import three;

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
  camera=(7,5,4),
  up=Z,
  target=(0,0,0),
  zoom=1.0
);

// ---------------------------------
// Parameters (half-lengths)
// ---------------------------------
real hx = 2.0;
real hy = 1.4;
real hz = 1.2;

// ---------------------------------
// Presentation rotation
// ---------------------------------
transform3 Rz = rotate(-15,Z);

// ---------------------------------
// Styles
// ---------------------------------
pen edgepen  = linewidth(0.85bp) + black;
pen axispen  = linewidth(0.55bp) + rgb(0.10,0.28,0.55);
pen dimpen   = linewidth(0.75bp) + black;
pen dimtext  = black;
pen guidepen = linewidth(0.45bp) + gray(0.55);

material boxmat = material(
  diffusepen  = opacity(0.58) + rgb(0.78,0.84,0.90),
  emissivepen = gray(0.25),
  specularpen = gray(0.15)
);

// ---------------------------------
// Label helper
// ---------------------------------
Label Lbl(string s, pen p=currentpen) {
  return Label(s, p=p, Fill(white));
}

// ---------------------------------
// Vertices
// ---------------------------------
triple A = Rz*(-hx,-hy,-hz);
triple B = Rz*( hx,-hy,-hz);
triple C = Rz*( hx, hy,-hz);
triple D = Rz*(-hx, hy,-hz);

triple E = Rz*(-hx,-hy, hz);
triple F = Rz*( hx,-hy, hz);
triple G = Rz*( hx, hy, hz);
triple H = Rz*(-hx, hy, hz);

// ---------------------------------
// Faces
// ---------------------------------
draw(surface(A--B--C--D--cycle), boxmat);
draw(surface(E--F--G--H--cycle), boxmat);
draw(surface(A--B--F--E--cycle), boxmat);
draw(surface(B--C--G--F--cycle), boxmat);
draw(surface(C--D--H--G--cycle), boxmat);
draw(surface(D--A--E--H--cycle), boxmat);

// ---------------------------------
// Edges
// ---------------------------------
draw(A--B--C--D--cycle, edgepen);
draw(E--F--G--H--cycle, edgepen);
draw(A--E, edgepen);
draw(B--F, edgepen);
draw(C--G, edgepen);
draw(D--H, edgepen);

// ---------------------------------
// Axes (small, internal)
// ---------------------------------
real scale = 0.75;

triple O  = Rz*(0,0,0);
triple OX = Rz*(scale*hx,0,0);
triple OY = Rz*(0,scale*hy,0);
triple OZ = Rz*(0,0,scale*hz);

draw(O--OX, axispen, Arrow3(4));
draw(O--OY, axispen, Arrow3(4));
draw(O--OZ, axispen, Arrow3(4));

label(Lbl("$x$", axispen), OX, E);
label(Lbl("$y$", axispen), OY, NE);
label(Lbl("$z$", axispen), OZ, N);

dot(O, black);

// ---------------------------------
// Dimension lines
// ---------------------------------

// x dimension: front/right side
triple dx1 = Rz*(-hx, hy+0.50, -hz);
triple dx2 = Rz*( hx, hy+0.50, -hz);
draw(dx1--dx2, dimpen, Arrows3(4));
draw(Rz*(-hx, hy, -hz)--dx1, guidepen);
draw(Rz*( hx, hy, -hz)--dx2, guidepen);
label(Lbl("$2h_x$", dimtext), midpoint(dx1--dx2), SE);

// y dimension: front side
triple dy1 = Rz*(hx+0.50, -hy, -hz);
triple dy2 = Rz*(hx+0.50,  hy, -hz);
draw(dy1--dy2, dimpen, Arrows3(4));
draw(Rz*(hx, -hy, -hz)--dy1, guidepen);
draw(Rz*(hx,  hy, -hz)--dy2, guidepen);
label(Lbl("$2h_y$", dimtext), midpoint(dy1--dy2), W);

// z dimension
triple dz1 = Rz*(-hx, hy+0.40, -hz);
triple dz2 = Rz*(-hx, hy+0.40,  hz);
draw(dz1--dz2, dimpen, Arrows3(4));
draw(Rz*(-hx, hy, -hz)--dz1, guidepen);
draw(Rz*(-hx, hy,  hz)--dz2, guidepen);
label(Lbl("$2h_z$", dimtext), midpoint(dz1--dz2), SE);
