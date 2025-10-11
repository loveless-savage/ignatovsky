global k wbeam f fnum;
%Ep=sqrt(1e18/2.146e18); % sqrt of intensity
lambda = 1;%2*pi; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 1; % width of incident beam
f = 3; % focal length of parabolic mirror: should be further than z0

oap = 0; % OAP angle
oaphi = 0; % azimuthal angle of OAP cut relative to polarization

zplane = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
fnum = 0.5*f/wbeam; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
%tau = 2*pi*12; % pulse duration in radians = 40e-15 s

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
oap = deg2rad(15);
oaprange = deg2rad(0:0.5:15);

Exr = zeros([size(x) length(oaprange)]);
Eyr = Exr;
Ezr = Exr;

for n = 1:length(oaprange)
	[xo, yo, zo]  = rot(x,y,z,-oaprange(n),oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	[Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n)] = rot(Exo,Eyo,Ezo,oaprange(n),oaphi);
end
%% compare w/ on-axis
%[Exp,Eyp,Ezp] = IgnatovskyIntegral(x, y, z, t, oap, oaphi);

%% show result w/ diagnostic plots
test
%FieldCrossRender(x, y, z, Ex, Ey, Ez, 1);
%fig = gcf; fig.Name = "CylinderIntegral";
%FieldCrossRender(x, y, z,Exs,Eys,Ezs, 2);
%FieldCrossRender(x, y, z,Exp,Eyp,Ezp, 2);
%fig = gcf; fig.Name = "EPeatross";
