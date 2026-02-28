%% mode 00 of the paraxial wave equation, as derived by Erikson & Singh
function [Ex,Ey,Ez]=Soap(x,y,z,oap,oaphi)
global k z0 w0;

% intermediate values
Z=z0+i*z; % coherence length w/ z phase
psi=exp(-k/2*(x.^2+y.^2)./Z); % cross-sectional gaussian envelope
scale=psi.*(sqrt(8)*z0./Z); % scalar field amplitude

% vector elements
Ex=scale;
Ey=scale.*(x.*y/2./Z.^2 + i*tan(oap/2).*(cos(oaphi).*y-sin(oaphi).*x)./Z);
Ez=scale*-i.*x./Z;
%Bx=1*Ey;
%By=1*Ex;
%Bz=scale.*-i*y./Z;
