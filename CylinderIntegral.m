function [Ex, Ey, Ez] = CylinderIntegral(x, y, z, t)
global lambda fnum w0 z0 f tau;
% TODO: pulse

%% mirror constants
% beam width at mirror
wmirror = 0.5*f/fnum;
% mirror radius: a little wider than the beam to capture rim of Gaussian
D = 1.6*wmirror;
% integration resolution
N = 31;
% integration boundaries
[xmin,xmax]=deal(-D,D);
[ymin,ymax]=deal(-D,D);
% step sizes
xrange = xmin:(xmax-xmin)/N:xmax;
yrange = ymin:(ymax-ymin)/N:ymax;
% FIXME: rename / refactor as dx,dy?
% mirror-space cartesian coordinates
[xi,yi] = meshgrid(xrange,yrange);
% radius on mirror
%rho2 = xi.^2 + yi.^2;
% mirror depth
%zi = rho2/4/f - f;

% the envelope in this code has been defined
% Env(p') = exp(p'^2/w^2)
% where w = f/fnum/2 is the width of the mirror

% k = 2*pi

%% cylindrical integral variables
rho = sqrt(x.^2 + y.^2);
phi = atan2(y,x);
thetaMax = acos((fnum-1)/(fnum+1));
theta = 0:thetaMax/N:thetaMax;
t=(1-cos(theta))./(1+cos(theta));
fac=exp(-(4*fnum)^2*t+2i*pi*z*cos(theta));

%% integrate over all points within the mask
Ex = 0*x;
Ey = Ex;
Ez = Ex;
%Bx = Ex;
%By = Ex;
%Bz = Ex;

for m=1:numel(x)
	arg=2*pi*rho(m)*sin(theta);
	
    Ex_intg = sin(theta).*fac.*( besselj(0,arg) + t.*cos(2*phi(m)).*besselj(2,arg) ) ...
		* thetaMax/N;
    Ey_intg = sin(theta).*fac.*(t.*sin(2*phi(m)).*besselj(2,arg)) ...
		* thetaMax/N;
    Ez_intg = -2i*sin(theta).*fac.*cos(phi(m)).*sqrt(t).*besselj(1,arg) ...
		* thetaMax/N;
	
    Ex(m)=sum(Ex_intg,"all");
    Ey(m)=sum(Ey_intg,"all");
    Ez(m)=sum(Ez_intg,"all");

end
