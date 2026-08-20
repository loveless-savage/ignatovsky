%% show difference between Ignatovsky and MSM (sliding off focal plane along z)
oap = deg2rad(90);
wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
oaphi = 0;
zrange = [0 1 4 9];
x = zeros([N N length(zrange)]);
y = x;
z = x;
Ex = x;
Ey = x;
Ez = x;
Exp = x;
Eyp = x;
Ezp = x;
Exs = x;
Eys = x;
Ezs = x;
for n=1:length(zrange)
	zoffset=zrange(n);
	[x(:,:,n),y(:,:,n),z(:,:,n),xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = MSM(x(:,:,n),y(:,:,n),z(:,:,n),oap,oaphi);
	[Exs(:,:,n),Eys(:,:,n),Ezs(:,:,n)] = Singh(x(:,:,n),y(:,:,n),z(:,:,n));
	n
end
params = {'paramText','$z=%d\\lambda$',...
		  'drawHeader',true,'drawLineout',true,'drawLegend',true,'relativePhase',true,'figX',0.5};
FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',Exp,Eyp,Ezp,'MSM',Exs,Eys,Ezs,'Singh',...
	paramVals=zrange, renderParams=params, live=true, movieName="vo_zslide_strip");
