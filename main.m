global lambda fnum w0 z0 f tau;
%Ep=sqrt(1e18/2.146e18); % sqrt of intensity
lambda = 1;%2*pi; % wavelength = 0.8e-6 m
fnum = 1; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
w0 = 2*lambda*fnum/pi;%2*pi*3; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
f = 10*z0; % focal length of parabolic mirror: should be further than z0
tau = 2*pi*12; % pulse duration in radians = 40e-15 s

z = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

%% set up grids for observation plane
N = 41;
xmin = -2.5*sqrt(1+z^2/z0^2);
xmax = 2.5*sqrt(1+z^2/z0^2);
dx = (xmax-xmin)/(N-1);
xrange = xmin:dx:xmax;
ymin = xmin;
ymax = xmax;
dy = (ymax-ymin)/(N-1);
yrange = ymin:dy:ymax;
[x,y] = meshgrid(xrange,yrange);

%% for each point on observation plane, integrate fields on source plane
%[Ex,Ey,Ez,Bx,By,Bz] = IgnatovskyIntegral(x,y,z,t);
%% compare w/ Singh model
%[Exs,Eys,Ezs,Bxs,Bys,Bzs] = IgnatovskyIntegral(x,y,z,t);
%% Dr Peatross code for comparison
addpath("CrossRender")
rho = sqrt(x.^2 + y.^2);
phi = atan2(y,x);
thetaMax = acos((fnum-1)/(fnum+1));
[Exp,Eyp,Ezp] = arrayfun(@(r,p) EPeatross(z,r,p,fnum,thetaMax),rho,phi);

%% show result w/ diagnostic plots
test
%FieldCrossRender(x, y, z, Ex, Ey, Ez, 1);
%fig = gcf; fig.Name = "CylinderIntegral";
%FieldCrossRender(x, y, z,Exs,Eys,Ezs, 2);
%FieldCrossRender(x, y, z,Exp,Eyp,Ezp, 2);
%fig = gcf; fig.Name = "EPeatross";
