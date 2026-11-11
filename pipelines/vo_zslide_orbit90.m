%% show difference between Ignatovsky and MSM (sitting off focal plane along z as we orbit)
oaprange = [90 90 90 90];
oaphirange = [0 15 30 45];
%oaprange   = cat(2,     0:89,   repelem(90,1,90), 90:-1:11,   repelem(10,1,90));
%oaphirange = cat(2,  zeros(1,90),    0:89,    repelem(90,1,80),   90:-1:1);
zoffset = 0;
x = zeros([N N length(oaphirange)]);
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
for n=1:length(oaphirange)
	oap = deg2rad(oaprange(n));
	wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
	oaphi=deg2rad(oaphirange(n));
	[x(:,:,n),y(:,:,n),z(:,:,n),xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = MSM(x(:,:,n),y(:,:,n),z(:,:,n),oap,oaphi);
	[Exs(:,:,n),Eys(:,:,n),Ezs(:,:,n)] = Singh(x(:,:,n),y(:,:,n),z(:,:,n));
	n
end
params = {'paramText','$\\theta=%d^\\circ,\\ \\phi=%d^\\circ$',...
		  'drawLegend',true,'relativePhase',true};%,'figWidth',14,'invisible',true};
FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',Exp,Eyp,Ezp,'MSM',Exs,Eys,Ezs,'Singh',...
	paramVals=[oaprange;oaphirange], renderParams=params, live=true, movieName="vo_zslide_orbit90");
