global k wbeam z0 w0 f fnum;
lambda = 0.8; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 100; % width of incident beam
f = 300; % focal length of parabolic mirror: should be further than z0

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
N = 65;
xmin = -1.5*pi*w0*sqrt(1+zplane^2/z0^2);
xmax = 1.5*pi*w0*sqrt(1+zplane^2/z0^2);
dx = (xmax-xmin)/(N-1);
xrange = xmin:dx:xmax;
ymin = xmin;
ymax = xmax;
dy = (ymax-ymin)/(N-1);
yrange = ymin:dy:ymax;
[x,y] = meshgrid(xrange,yrange);
z = x*0+zplane;

%% mirror + beam setup
% mirror-space cartesian coordinates
%[xi,yi,Env] = mirror(N,oap,oaphi);
%[pex,pey,pez] = pvec(xi,yi);
%pex = pex.*Env;
%pey = pey.*Env;
%pez = pez.*Env;

%% examine Singh modes
[Ex00,Ey00,Ez00] = E00(x,y,z);
[Ex10,Ey10,Ez10] = E10(x,y,z);
[Ex01,Ey01,Ez01] = E01(x,y,z);
[Ex11,Ey11,Ez11] = E11(x,y,z);
%FieldCrossRender(x,y,z,Ex00,Ey00,Ez00,0,4.5,"$E_{00}$")
%FieldCrossRender(x,y,z,Ex10,Ey10,Ez10,10,4.5,"$E_{10}$")
%FieldCrossRender(x,y,z,Ex01,Ey01,Ez01,0,0.0,"$E_{01}$")
%FieldCrossRender(x,y,z,Ex11,Ey11,Ez11,10,0.0,"$E_{11}$")
tmix=0:pi/12:(pi*2-pi/12);
Exmix=zeros([size(Ex10) length(tmix)]);
Eymix=Exmix;
Ezmix=Exmix;
for n=1:length(tmix)
	Exmix(:,:,n) = cos(tmix(n))*Ex10 + sin(tmix(n))*Ex01;
	Eymix(:,:,n) = cos(tmix(n))*Ey10 + sin(tmix(n))*Ey01;
	Ezmix(:,:,n) = cos(tmix(n))*Ez10 + sin(tmix(n))*Ez01;
end
FieldCrossMovie(x,y,z,Exmix,Eymix,Ezmix,180/pi*tmix,"mode_mix");

%% get a frame of reference
%[xo, yo, zo]  = rot(x,y,z,-oap,oaphi);
%[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
%[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi);
%FieldCrossRender(x,y,z,Ex,Ey,Ez,0,3.9,"$Ignatovsky (\\theta=30^\\circ,\\phi=90^\\circ)$")

%% for each point on observation plane, integrate fields on source plane
%oaphirange = 0:15:360;
%Ex = zeros([size(x) length(oaphirange)]);
%Ey = Ex;
%Ez = Ex;
%for n=1:length(oaphirange)
	%oaphi=deg2rad(oaphirange(n));
	%[xo, yo, zo]  = rot(x,y,z,-oap,oaphi);
	%[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	%[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	%Ex(:,:,n) = Ex(:,:,n) - Ex0;
	%Ey(:,:,n) = Ey(:,:,n) - Ey0;
	%Ez(:,:,n) = Ez(:,:,n) - Ez0;
	%n
%end
%FieldCrossMovie(x,y,z,Ex,Ey,Ez,oaphirange,"orbit_theta30");
