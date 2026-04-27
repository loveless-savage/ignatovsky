global k wbeam z0 w0 f fnum;
lambda = 1.0; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 50; % width of incident beam
f = 200; % focal length of parabolic mirror: should be further than z0

oap = deg2rad(30); % OAP angle
oaphi = deg2rad(0); % azimuthal angle of OAP cut relative to polarization

zoffset = 0;%-f; % displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
fnum = 0.5*f/wbeam; % asymptotic cone angle of beam -- < 3 is a pretty wide focus
%tau = 2*pi*12; % pulse duration in radians = 40e-15 s

%% set up grids for observation + mirror planes
N = 257;
[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
%[xi,yi,Env] = mirror(N,oap,oaphi);
%[pex,pey,pez] = pvec(xi,yi);
%pex = pex.*Env;
%pey = pey.*Env;
%pez = pez.*Env;
%FieldCrossRender(x,y,z,pex,pey,pez,0,3.9,"Mirror polarization vector")

%% for each point on observation plane, integrate fields on source plane
zrange = [0 5 10 30 70 120];
Ex = zeros([size(x) length(zrange)]);
Ey = Ex;
Ez = Ex;
Exp = Ex;
Eyp = Ex;
Ezp = Ex;
for n=1:length(zrange)
	%oaphi=deg2rad(oaphirange(n));
	zoffset=zrange(n);
	[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	%xo = xo *sec(oap/2)^2; % TODO: get this scaling in the render ticks
	%yo = yo *sec(oap/2)^2;
	%zo = zo *sec(oap/2)^2;
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = Soap(x,y,z,oap,-oaphi);
	n
end
myName = "vo_zsweep_strip";
params = {'paramText','$z=%d\\lambda$',...
			'drawHeader',false,'drawLineout',false};
FieldCrossMovie(x,y,z,Exp,Eyp,Ezp,zrange, ...
	renderParams=params, live=true, movieName=myName);
%FieldCrossRender(x,y,Ex(:,:,1),Ey(:,:,1),Ez(:,:,1),...
	%paramText='MSM ($\\theta=90^\\circ$)',drawLineout=false,figHeight=10.78125,figWidth=15.625);
