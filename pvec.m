%% polarization vector at the surface of the mirror
function [pex,pey,pez,pbx,pby,pbz] = pvec(xi,yi)
global f;

% radius of parabola
rho2 = xi.^2 + yi.^2;
% mirror depth
%zi = rho2/4/f - f;
% normalization constant for mirror-related unit vectors
znorm = 1 + rho2/4/f^2;
% E and B field polarizations
pex = (1-(xi.^2-yi.^2)/4/f^2)./znorm;
pey = -xi.*yi/2/f^2./znorm;
pez = xi/f./znorm;
pbx = pey;
pby = (1+(xi.^2-yi.^2)/4/f^2)./znorm;
pbz = yi/f./znorm;
