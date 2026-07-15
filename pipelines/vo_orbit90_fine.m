%% show difference between Ignatovsky and MSM (azimuthal orbit)
oap = deg2rad(90);
oaphirange = 0:15:345;
f = f*cos(oap/2)^2; % convert from effective focal length to parent focal length
Ex = zeros([size(x) length(oaphirange)]);
Ey = Ex;
Ez = Ex;
Exp = Ex;
Eyp = Ex;
Ezp = Ex;
for n=1:length(oaphirange)
	oaphi=deg2rad(oaphirange(n));
	f = f*cos(oap/2)^2; % convert from effective focal length to parent focal length
	[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	Ez(:,:,n)=Ez(:,:,n)/max(Ex(:,:,n),[],"all");
	Ey(:,:,n)=Ey(:,:,n)/max(Ex(:,:,n),[],"all");
	Ex(:,:,n)=Ex(:,:,n)/max(Ex(:,:,n),[],"all");
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = Soap(x,y,z,oap,oaphi);
	Ezp(:,:,n)=Ezp(:,:,n)/max(Exp(:,:,n),[],"all");
	Eyp(:,:,n)=Eyp(:,:,n)/max(Exp(:,:,n),[],"all");
	Exp(:,:,n)=Exp(:,:,n)/max(Exp(:,:,n),[],"all");
	n
end
params = {'paramText','MSM ($\\theta=90^\\circ,\\,\\phi=%d^\\circ$)',...
		  'drawHeader',true,'drawLineout',true,'drawLegend',false};
FieldCrossMovie(x,y,z,Exp,Eyp,Ezp,oaphirange,altE={Ex,Ey,Ez},...
	renderParams=params, live=false, movieName="vo_orbit90_fine");
