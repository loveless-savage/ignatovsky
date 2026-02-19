%% mode 00 of the paraxial wave equation, as derived by Erikson & Singh
function [Ex,Ey,Ez]=Soap(x,y,z,oaphi)
global k f z0 w0;

% intermediate values
Z=z0+i*z; % coherence length w/ z phase
psi=exp(-k/2*(x.^2+y.^2)./Z); % cross-sectional gaussian envelope
scale=psi.*(sqrt(8)*z0./Z); % scalar field amplitude

% vector elements
Ex=scale;
Ey=scale*i.*(-sin(oaphi).*x+cos(oaphi).*y)/f;
Ez=scale*-i.*x./f;
%Bx=1*Ey;
%By=1*Ex;
%Bz=scale.*-i*y./Z;
