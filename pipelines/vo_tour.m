%% show difference between Ignatovsky and MSM (off-axis sweep)
oaprange   = cat(2,     0:89,   repelem(90,1,90), 90:-1:11,   repelem(10,1,90));
oaphirange = cat(2,  zeros(1,90),    0:89,    repelem(90,1,80),   90:-1:1);

Ex = zeros([size(x) length(oaprange)]);
Ey = Ex;
Ez = Ex;
Exp = Ex;
Eyp = Ex;
Ezp = Ex;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
	oaphi=deg2rad(oaphirange(n));
	[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = MSM(x,y,z,oap,oaphi);
	n
end
[Exs,Eys,Ezs] = Singh(x,y,z);
params = {'paramText','$\\theta=%d^\\circ,\\,\\phi=%d^\\circ$',...
		  'drawLegend',true,'figWidth',14,'invisible',true};
FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',Exp,Eyp,Ezp,'MSM',Exs,Eys,Ezs,'Singh',...
	paramVals=[oaprange;oaphirange],renderParams=params, live=false, movieName="vo_tour");
