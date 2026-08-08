%% build a grid of coordinates for a camera sensor, given an offset from the laser focus
function [x,y,z,xo,yo,zo] = camera(N,zoffset,oap,oaphi)
global z0 w0;

% size of focal region
wCam = 1.5*pi*w0*sqrt(1+zoffset^2/z0^2);
% build grid with boundaries at x,y = +/-wCam
dx = 2*wCam/(N-1);
xrange = -wCam:dx:wCam;
% unrotated coordinates
[x,y] = meshgrid(xrange,xrange);
z = x*0+zoffset;
% also return rotated coordinates
if nargin>2
	[xo,yo,zo] = rot(x,y,z,oap,oaphi);
end
