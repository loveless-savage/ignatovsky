%% build a grid of coordinates for a camera sensor, given an offset from the laser focus
function [x,y,z,xo,yo,zo] = camera(N,zoffset,oap,oaphi)
global z0 w0;

% x parameters
xmin = -1.5*pi*w0*sqrt(1+zoffset^2/z0^2);
xmax = 1.5*pi*w0*sqrt(1+zoffset^2/z0^2);
dx = (xmax-xmin)/(N-1);
xrange = xmin:dx:xmax;
% y parameters
ymin = xmin;
ymax = xmax;
dy = (ymax-ymin)/(N-1);
yrange = ymin:dy:ymax;
% unrotated coordinates
[x,y] = meshgrid(xrange,yrange);
z = x*0+zoffset;
% also return rotated coordinates
if nargin>2
	[xo,yo,zo] = rot(x,y,z,oap,oaphi);
end
