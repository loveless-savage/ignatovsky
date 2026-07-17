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
ExC = zeros(length(oaphirange),1);
ExpC = ExC;
for n=1:length(oaphirange)
	oaphi=deg2rad(oaphirange(n));
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
	ExC(n) = max(Ex(:,:,n),[],"all");
	ExpC(n) = max(Exp(:,:,n),[],"all");
	n
end
Exd=Ex-Exp;
Eyd=Ey-Eyp;
Ezd=Ez-Ezp;
params = {'paramText','Ignatovsky-MSM ($\\phi=%d^\\circ$)',...
			'drawHeader',true,'drawLineout',true,'drawLegend',false};
FieldCrossMovie(x,y,Exd,Eyd,Ezd,oaphirange,...
	renderParams=params, live=false, movieName="dg_orbit90_fine");
