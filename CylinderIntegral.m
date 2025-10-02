%% temporary guy
function [Ex, Ey, Ez] = CylinderIntegral(x, y, z, t)
global k lambda fnum w0 z0 f tau;
% TODO: pulse

%% mirror constants
% beam width at mirror
wmirror = 0.5*f/fnum;
% mirror radius: a little wider than the beam to capture rim of Gaussian
D = 1.6*wmirror;
% integration resolution
N = 65;
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
rho2 = xi.^2 + yi.^2;
% mirror depth
zi = rho2/4/f - f;

%% initial conditions on mirror
% normalization constant for mirror-related unit vectors
znorm = 1 + rho2/4/f^2;
% propagation direction off of all points on the mirror
kx = -xi/f./znorm;
ky = -yi/f./znorm;
kz = 2./znorm-1;
% E and B field polarizations
pex = (1-(xi.^2-yi.^2)/4/f^2)./znorm;
pey = -xi.*yi/2/f^2./znorm;
pez = xi/f./znorm;
pbx = pey;
pby = (1+(xi.^2-yi.^2)/4/f^2)./znorm;
pbz = yi/f./znorm;
% incident beam profile: Gaussian is a good default
Env = exp(-rho2/wmirror^2);
% mask matrix
mask = (rho2<D^2);
kx(~mask)=0; pex(~mask)=0; pbx(~mask)=0;
ky(~mask)=0; pey(~mask)=0; pby(~mask)=0;
kz(~mask)=0; pez(~mask)=0; pbz(~mask)=0;
Env(~mask)=0;

% the envelope in this code has been defined
% Env(p') = exp(p'^2/w^2)
% where w = f/fnum/2 is the width of the mirror

% k = 2*pi

%% cylindrical integral variables
rho = sqrt(x.^2 + y.^2);
phi = atan2(y,x);
thetaMax = acos((fnum-1)/(fnum+1));
theta = 0:thetaMax/N:thetaMax;
chi=(1-cos(theta))./(1+cos(theta));
fac=exp(-(4*fnum)^2*chi+1i*k*z*cos(theta));

%% integrate over all points within the mask
Ex = 0*x;
Ey = Ex;
Ez = Ex;
%Bx = Ex;
%By = Ex;
%Bz = Ex;

for m=1:numel(x)
	arg=k*rho(m)*sin(theta);
	
    Ex_intg = sin(theta).*fac.*( besselj(0,arg) + chi.*cos(2*phi(m)).*besselj(2,arg) ) ...
		* thetaMax/N;
    Ey_intg = sin(theta).*fac.*(chi.*sin(2*phi(m)).*besselj(2,arg)) ...
		* thetaMax/N;
    Ez_intg = -2i*sin(theta).*fac.*cos(phi(m)).*sqrt(chi).*besselj(1,arg) ...
		* thetaMax/N;
	
    Ex(m)=1i*k*f*sum(Ex_intg,"all");
    Ey(m)=1i*k*f*sum(Ey_intg,"all");
    Ez(m)=1i*k*f*sum(Ez_intg,"all");

end
