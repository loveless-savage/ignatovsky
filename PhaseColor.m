%% complex colormap to show phase information
function C = PhaseColor(x,n)
% break complex values into abs/arg
r=abs(x);
p=angle(x);
% rgb functions
R = ((1 + cos(p + 4*pi/3)) / 2 .* r).^.6;
G = ((1 + cos(p)) / 2 .* r).^.6;
B = ((1 + cos(p + 2*pi/3)) / 2 .* r.^0.8).^.6;
% interpolate on the order of 2^n
C(:,:,1) = interp2(R,n);
C(:,:,2) = interp2(G,n);
C(:,:,3) = interp2(B,n);