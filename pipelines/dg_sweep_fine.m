%% show difference between Ignatovsky and MSM (azimuthal orbit)
oaprange = [0 1 2 3 4 5 6 7 8 10 12 14 16 18 20 22 24 27 30 33 36 39 42 45 50 55 60 65 70 75 80 85 90];
oaphi = deg2rad(0);
Ex = zeros([size(x) length(oaprange)]);
Ey = Ex;
Ez = Ex;
Exp = Ex;
Eyp = Ex;
Ezp = Ex;
ExC = zeros(length(oaprange),1);
ExpC = ExC;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
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
	ExC(n) = max(Ex(:,:,n),[],"all");
	ExpC(n) = max(Exp(:,:,n),[],"all");
	n
end
Exd=Ex-Exp;
Eyd=Ey-Eyp;
Ezd=Ez-Ezp;
params = {'paramText','Ignatovsky-MSM ($\\theta=%d^\\circ$)',...
		  'drawHeader',true,'drawLineout',true,'drawLegend',false};
FieldCrossMovie(x,y,z,Exd,Eyd,Ezd,oaprange,...
	renderParams=params, live=false, movieName="dg_sweep_fine");
