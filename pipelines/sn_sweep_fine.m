%% show difference between Ignatovsky and MSM (sliding off focal plane along z)
oap = 0;
wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
oaphi = 0;
zrange_pre = (0:0.1:1)*atan(10);
zrange = tan(zrange_pre)*z0;
x = zeros([N N length(zrange)]);
y = x;
z = x;
Ex = x;
Ey = x;
Ez = x;
Exs = x;
Eys = x;
Ezs = x;
for n=1:length(zrange)
	zoffset=zrange(n);
	[x(:,:,n),y(:,:,n),z(:,:,n),xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exs(:,:,n),Eys(:,:,n),Ezs(:,:,n)] = Singh(x(:,:,n),y(:,:,n),z(:,:,n));
	n
end
params = {'paramText','$z=%.2f z_0$',...
		  'drawLegend',true,'relativePhase',true,'figWidth',14,'invisible',true};
FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',Exs,Eys,Ezs,'Singh',...
	paramVals=zrange/z0, renderParams=params, live=false, movieName="sn_sweep_fine");
