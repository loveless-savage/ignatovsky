global k fnum w0 z0 f;
%Ep=sqrt(1e18/2.146e18); % sqrt of intensity
lambda = 1;%2*pi; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
fnum = 1; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
w0 = 2*lambda*fnum/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
f = 10*z0; % focal length of parabolic mirror: should be further than z0
%tau = 2*pi*12; % pulse duration in radians = 40e-15 s

zplane = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

% OAP angle
oap = 0;
% azimuthal angle of OAP cut relative to polarization
oaphi = 0;

%% set up grids for observation plane
N = 41;
xmin = -1.25*pi*w0*sqrt(1+zplane^2/z0^2);
xmax = 1.25*pi*w0*sqrt(1+zplane^2/z0^2);
dx = (xmax-xmin)/(N-1);
xrange = xmin:dx:xmax;
ymin = xmin;
ymax = xmax;
dy = (ymax-ymin)/(N-1);
yrange = ymin:dy:ymax;
[x,y] = meshgrid(xrange,yrange);
z = x*0+zplane;

%% for each point on observation plane, integrate fields on source plane
%[Ex,Ey,Ez,Bx,By,Bz] = IgnatovskyIntegral(x,y,z,t,oap,oaphi);
%% compare w/ on-axis
[Exp,Eyp,Ezp] = IgnatovskyIntegral(x, y, z, t, oap, oaphi);

%% show result w/ diagnostic plots
%test
%FieldCrossRender(x, y, z, Ex, Ey, Ez, 1);
%fig = gcf; fig.Name = "CylinderIntegral";
%FieldCrossRender(x, y, z,Exs,Eys,Ezs, 2);
%FieldCrossRender(x, y, z,Exp,Eyp,Ezp, 2);
%fig = gcf; fig.Name = "EPeatross";
