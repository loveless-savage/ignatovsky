%% circular gaussian pulse, integrating off a full parabolic mirror.
function [Ex,Ey,Ez,Bx,By,Bz]=IgnatovskyIntegral(x,y,z,t)
global lambda fnum w0 z0 f tau;
% TODO: pulse

%% mirror constants
% beam width at mirror
wmirror = 0.5*f/fnum;
% mirror radius: a little wider than the beam to capture rim of Gaussian
D = 1.6*wmirror;
% integration resolution
N = 16;
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

%% integrate over all points within the mask
Ex = 0*x;
Ey = Ex;
Ez = Ex;
Bx = Ex;
By = Ex;
Bz = Ex;

for m=1:numel(x)
    % E-field scalar portion
    E_intg = Env(mask) ./ znorm(mask) ...
        .* exp(2i*pi*(kx(mask).*(x(m)-xi(mask)) ... % FIXME: k=2pi
                 + ky(mask).*(y(m)-yi(mask)) ...
                 + kz(mask).*( z - zi(mask)))) ...
        .* -1i*exp(1i*(z-t))/(2*pi*f) .* (xmax-xmin)*(ymax-ymin)/N^2;
    % vector portions
    Ex(m) = sum(E_intg.*pex(mask),"all");
    Ey(m) = sum(E_intg.*pey(mask),"all");
    Ez(m) = sum(E_intg.*pez(mask),"all");
    % B-field scalar portion
    %B_intg = -1i*exp(1i*(z-t))/(2*pi*f*c) * Env ./ znorm...
    %    .*exp(1i*(kx*x+ky*y+kz*z)) * (xmax-xmin)*(ymax-ymin)/N^2;
    % FIXME: because c=1, B_intg = E_intg
end

%Ex = kx;
%Ey = ky;
%Ez = kz;
%Bx = pbx;
%By = pby;
%Bz = pbz;

% vector elements
%Ex=real(field);
%Ey=real(xi.*yi./(2*Z.^2).*field);
%Ez=real(-i*xi./Z.*field);
%Bx=1*Ey;
%By=1*Ex;
%Bz=1*real(-i*yi./Z.*field);

