global k wbeam f fnum;
lambda = 0.8; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 100; % width of incident beam
f = 300; % focal length of parabolic mirror: should be further than z0

oap = deg2rad(30); % OAP angle
%oaphi = deg2rad(45); % azimuthal angle of OAP cut relative to polarization

zplane = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
fnum = 0.5*f/wbeam; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
%tau = 2*pi*12; % pulse duration in radians = 40e-15 s

%% set up grids for observation plane
N = 65;
xmin = pi*w0*sqrt(1+zplane^2/z0^2);
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
oaphirange = 0:15:360;
Ex = zeros([size(x) length(oaphirange)]);
Ey = Ex;
Ez = Ex;
for n=1:length(oaphirange)
	oaphi=deg2rad(oaphirange(n));
	[xo, yo, zo]  = rot(x,y,z,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	n
end

%% show result w/ diagnostic plots
%FieldCrossRender(x,y,z,Ex,Ey,Ez,2.5,0.9,"$\\theta = 30^\\circ$")
FieldCrossMovie(x,y,z,Ex,Ey,Ez,oaphirange,"orbit_theta30");
