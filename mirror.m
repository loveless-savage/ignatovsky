function [xi,yi,Env,dA] = mirror(oap,oaphi)
global k wbeam f;

% mirror radius: a little wider than the beam to capture rim of Gaussian
D = 4.0*wbeam;
% off-axis center of beam
x0 = 2*f*tan(oap/2)*cos(oaphi);
y0 = 2*f*tan(oap/2)*sin(oaphi);
% integration resolution
N = 65;
% integration boundaries
[xmin,xmax]=deal(x0-D,x0+D);
[ymin,ymax]=deal(y0-D,y0+D);
% step sizes
xrange = xmin:(xmax-xmin)/(N-1):xmax;
yrange = ymin:(ymax-ymin)/(N-1):ymax;
% FIXME: rename / refactor as dx,dy?
% mirror-space cartesian coordinates
[xi,yi] = meshgrid(xrange,yrange);
% incident beam profile
Env = exp(-((xi-x0).^2+(yi-y0).^2)/wbeam^2);
% Riemann sum needs a differential multiplier
dA = (xmax-xmin)*(ymax-ymin)/N^2;
