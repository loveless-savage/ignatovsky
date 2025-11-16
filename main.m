global k wbeam f fnum;
lambda = 0.8; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 1; % width of incident beam
f = 3; % focal length of parabolic mirror: should be further than z0

oap = deg2rad(30); % OAP angle
oaphi = deg2rad(45); % azimuthal angle of OAP cut relative to polarization

zplane = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
fnum = 0.5*f/wbeam; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
%tau = 2*pi*12; % pulse duration in radians = 40e-15 s

%% set up grids for observation plane
N = 31;
xmin = -pi*w0*sqrt(1+zplane^2/z0^2);
xmax = pi*w0*sqrt(1+zplane^2/z0^2);
dx = (xmax-xmin)/(N-1);
xrange = xmin:dx:xmax;
ymin = xmin;
ymax = xmax;
dy = (ymax-ymin)/(N-1);
yrange = ymin:dy:ymax;
[x,y] = meshgrid(xrange,yrange);
z = x*0+zplane;

%% for each point on observation plane, integrate fields on source plane
[xo, yo, zo]  = rot(x,y,z,-oap,oaphi);
[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
[Exp,Eyp,Ezp] = rot(Exo,Eyo,Ezo,oap,oaphi);

%% show result w/ diagnostic plots
FieldCrossRender(x,y,z,Exp,Eyp,Ezp,2.5,0.9,"$\\theta = 30^\\circ$")
