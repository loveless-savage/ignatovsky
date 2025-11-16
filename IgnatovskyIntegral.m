%% circular gaussian pulse, integrating off a full parabolic mirror.
function [Ex,Ey,Ez,Bx,By,Bz]=IgnatovskyIntegral(x,y,z,t,oap,oaphi)
global k wbeam f;

%% mirror + beam setup
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

%% initial conditions on mirror
% radius of parabola
rho2 = xi.^2 + yi.^2;
% mirror depth
zi = rho2/4/f - f;
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

%% integrate over all points within the mask
Ex = 0*x;
Ey = Ex;
Ez = Ex;
Bx = Ex;
By = Ex;
Bz = Ex;
% mask matrix to reduce integration steps
mask = (Env>1e-4);
kx(~mask)=0; pex(~mask)=0; pbx(~mask)=0;
ky(~mask)=0; pey(~mask)=0; pby(~mask)=0;
kz(~mask)=0; pez(~mask)=0; pbz(~mask)=0;
Env(~mask)=0;

for m=1:numel(x)
    % E-field scalar portion
    E_intg = Env(mask) ./ znorm(mask) ...
        .* exp(1i*k*(kx(mask).*x(m) ...
                   + ky(mask).*y(m) ...
                   + kz(mask).*z(m))) ...
        .* -1i.*exp(1i*(k*z(m)-t))*k/(2*pi*f) ...
		.* (xmax-xmin)*(ymax-ymin)/N^2;
    % vector portions
    Ex(m) = sum(E_intg.*pex(mask),"all");
    Ey(m) = sum(E_intg.*pey(mask),"all");
    Ez(m) = sum(E_intg.*pez(mask),"all");
    % B-field scalar portion
    %B_intg = -1i*exp(1i*(z(m)-t))/(2*pi*f*c) * Env ./ znorm...
    %    .*exp(1i*(kx*x+ky*y+kz*z)) * (xmax-xmin)*(ymax-ymin)/N^2;
    % FIXME: because c=1, B_intg = E_intg
end

