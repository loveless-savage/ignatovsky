%% show difference between Ignatovsky and MSM (off-axis sweep)
oaprange = [0 10 30 90];
oaphi = deg2rad(0);
Ex = zeros([size(x) length(oaprange)]);
Ey = Ex;
Ez = Ex;
Exp = Ex;
Eyp = Ex;
Ezp = Ex;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
	[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = Soap(x,y,z,oap,oaphi);
	n
end
[Exs,Eys,Ezs] = Singh(x,y,z);
params = {'paramText','MSM ($\\theta=%d^\\circ$)',...
		  'drawHeader',true,'drawLineout',true,'drawLegend',true,'figX',0.5};
FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',x,y,Exp,Eyp,Ezp,'MSM',x,y,Exs,Eys,Ezs,'Singh',...
	paramVals=oaprange, renderParams=params, live=true, movieName="vo_sweep_strip");
