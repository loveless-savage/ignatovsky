global k wbeam z0 w0 fnum f;
lambda = 1; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 50; % width of incident beam
fnum = 2; % asymptotic cone angle of beam -- < 3 is a pretty wide focus

oap = deg2rad(30); % OAP angle
oaphi = deg2rad(45); % azimuthal angle of OAP cut relative to polarization
zoffset = 0;% displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
f = 2*wbeam*fnum; % focal length of parabolic mirror: should be further than z0
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
% convert from effective focal length to parent focal length
f = f*cos(oap/2)^2;

%% set up grids for observation + mirror planes
N = 65;
%[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
oaprange   = [0  5 10 30 45 60 80 85 90 90 90 90 90 90 90 90 90];
oaphirange = [0  0  0  0  0  0  0  0  0  5 15 30 45 60 75 85 90];
[xi,yi,Env] = mirror(N,oap,oaphi);
[pex,pey,pez] = pvec(xi,yi);
pex = zeros([size(pex) length(oaprange)]);
pey = pex;
pez = pex;
pox = pex;
poy = pex;
poz = pex;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	oaphi=deg2rad(oaphirange(n));
	[xi,yi,Env] = mirror(N,oap,oaphi);
	zi=(xi.^2+yi.^2)/4/f-f;
	[pex(:,:,n),pey(:,:,n),pez(:,:,n)] = pvec(xi,yi,Env);
	[pox(:,:,n),poy(:,:,n),poz(:,:,n)]=rot(pex(:,:,n),pey(:,:,n),pez(:,:,n),oap,oaphi);
end
[xi,yi] = mirror(N,0,0);
params={'figX',0,'figY',3.9,'drawLineout',false,...
	'paramText',"$p_{mirror}\\ (\\theta=%d^\\circ,\\,\\phi=%d^\\circ)$",'paramText2',"$p_{beam}$"};
FieldCrossMovie(xi,yi,pex,pey,pez,[oaprange;oaphirange],altE={pox,poy,poz},...
	movieName="pvec_framecomp",live=false,renderParams=params)
%FieldCrossRender(x,y,pex,pey,pez,figX=0,figY=3.9,paramText="$p_{mirror}$",altE={pox,poy,poz},drawLineout=false)

%% compare MSM and Ignatovsky model results, accommodating for focal width scaling
%[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
%[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi);
%[Exp,Eyp,Ezp] = Soap(x,y,z,oap,oaphi);
%FieldCrossRender(x,y,Exp,Eyp,Ezp,altE={Ex,Ey,Ez},...
%	paramText='MSM ($\\theta=10^\\circ,\\ z=10\\lambda$)',...
%	drawLegend=true,figHeight=10.78125,figWidth=15.625);
%FieldYCompRender(x,y,ExC,Ey,ExpC,Eyp);

%% for each point on observation plane, integrate fields on source plane
%oaprange = [0 1 2 3 4 5 6 7 8 10 12 14 16 18 20 22 24 27 30 33 36 39 42 45 50 55 60 65 70 75 80 85 90];
%oaphirange = 0:15:345;
%Ex = zeros([size(x) length(oaphirange)]);
%Ey = Ex;
%Ez = Ex;
%Exp = Ex;
%Eyp = Ex;
%Ezp = Ex;
%ExC = zeros(length(oaphirange),1);
%ExpC = ExC;
%for n=1:length(oaphirange)
%	%oap=deg2rad(oaprange(n));
%	oaphi=deg2rad(oaphirange(n));
%	[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
%	%f=200*cos(oap/2)^2;
%	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
%	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
%	Ez(:,:,n)=Ez(:,:,n)/max(Ex(:,:,n),[],"all");
%	Ey(:,:,n)=Ey(:,:,n)/max(Ex(:,:,n),[],"all");
%	Ex(:,:,n)=Ex(:,:,n)/max(Ex(:,:,n),[],"all");
%	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = Soap(x,y,z,oap,oaphi);
%	Ezp(:,:,n)=Ezp(:,:,n)/max(Exp(:,:,n),[],"all");
%	Eyp(:,:,n)=Eyp(:,:,n)/max(Exp(:,:,n),[],"all");
%	Exp(:,:,n)=Exp(:,:,n)/max(Exp(:,:,n),[],"all");
%	ExC(n) = max(Ex(:,:,n),[],"all");
%	ExpC(n) = max(Exp(:,:,n),[],"all");
%	n
%end
%Exd=Ex-Exp;
%Eyd=Ey-Eyp;
%Ezd=Ez-Ezp;
%params = {'paramText','Ignatovsky-MSM ($\\phi=%d^\\circ$)',...\\theta=%d^\\circ,\\,\\phi=0^\\circ$)',...
%			'drawHeader',true,'drawLineout',true,'drawLegend',false};
%FieldCrossMovie(x,y,z,Exd,Eyd,Ezd,oaphirange,...altE={Ex,Ey,Ez},...
%	renderParams=params, live=false, movieName="dg_orbit90_fine");
%FieldCrossRender(x,y,Ex(:,:,1),Ey(:,:,1),Ez(:,:,1),...
%	figHeight=10.78125,figWidth=15.625,drawLegend=true,...
%	paramText='Ignatovsky ($\\phi=0^\\circ$)');

%x = x*sec(oap/2)^2;
%y = y*sec(oap/2)^2;
%FieldCrossRender(x,y,Exp,Eyp,Ezp,altE={Ex,Ey,Ez},...
%	figHeight=10.78125,figWidth=15.625,drawLegend=true,...
%	paramText='MSM ($\\theta=30^\\circ,\\ z=10\\lambda$)');

%% watch Ez scale
%eymag=reshape(abs(Ey(28,33,:)),length(oaprange),1)./reshape(abs(Ex(33,33,:)),length(oaprange),1);
%plot(oaprange,eymag);
%title("Ey/Ex (peak values)");
%grid on;
%xlabel("$\theta$ (degrees)",Interpreter="latex");
%hold on;
%plot(oaprange,sin(oaprange*pi/180)*eymag(end));
%legend("Ey/Ex","$\\cos^2(\\theta/2)$",Interpreter="latex");
%ezmag=reshape(abs(Ez(33,28,:)),length(oaprange),1)./reshape(abs(Ex(33,33,:)),length(oaprange),1);
%figure;
%plot(oaprange,ezmag);
%title("Ez/Ex (peak values)");
%grid on;
%xlabel("$\theta$ (degrees)",Interpreter="latex");
%hold on;
%plot(oaprange,cos(oaprange*pi/360).^2*ezmag(1));
%legend("Ez/Ex","$\\cos^2(\\theta/2)$",Interpreter="latex");
