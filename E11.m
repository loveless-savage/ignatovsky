%% mode 11 of the paraxial wave equation, as derived by Erikson & Singh
function [Ex,Ey,Ez]=E11(x,y,z)
global k z0 w0;

% intermediate values
Z=z0+i*z; % coherence length w/ z phase
psi=exp(-k/2*(x.^2+y.^2)./Z); % cross-sectional gaussian envelope
scaleH=psi.*(sqrt(8)*z0./Z).^3 / w0^2; % scalar field amplitude (higher order)
scaleL=psi.*(sqrt(8)*z0./Z).^2 * sqrt(2); % scalar field amplitude (lower order)

% vector elements
Ex=scaleH.*x.*y;
Ey=scaleH.*(x.*y).^2/2./Z.^2 - scaleL.*(x.^2+y.^2)/2./Z.^2;
Ez=scaleH *-i.*(x.^2).*y./Z  - scaleL *-i.*(x+y)./Z;
%Bx=1*Ey;
%By=1*Ex;
%Bz=scaleH.*-i*y./Z;
