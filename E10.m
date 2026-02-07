%% mode 10 of the paraxial wave equation, as derived by Erikson & Singh
function [Ex,Ey,Ez]=E10(x,y,z)
global k z0 w0;

% intermediate values
Z=z0+i*z; % coherence length w/ z phase
psi=exp(-k/2*(x.^2+y.^2)./Z); % cross-sectional gaussian envelope
scaleH=psi.*(sqrt(8)*z0./Z).^2 / w0; % scalar field amplitude (higher order)
scaleL=psi.*(sqrt(8)*z0./Z) * sqrt(2)*w0; % scalar field amplitude (lower order)

% vector elements
Ex=scaleH.*x;
Ey=scaleH.*(x.^2).*y/2./Z.^2 - scaleL.*y/2./Z.^2;
Ez=scaleH *-i.*(x.^2)./Z     - scaleL *-i./Z;
%Bx=1*Ey;
%By=1*Ex;
%Bz=scaleH.*-i*y./Z;
