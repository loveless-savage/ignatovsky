%% show difference between Ignatovsky and MSM (sliding off focal plane along z)
oaprange   = cat(2,     0:89,   repelem(90,1,90), 90:-1:11,   repelem(10,1,90));
oaphirange = cat(2,  zeros(1,90),    0:89,    repelem(90,1,80),   90:-1:1);
linyrange  = cat(2,repelem(45,1,90),-90:-1,   repelem(45,1,170))*pi/180;
%oaprange =   [0 10 30 60 90 90 90 90 90 90 90 60 30 10 10 10 10 10 10];
%oaphirange = [0  0  0  0  0 15 30 45 60 75 90 90 90 90 75 60 45 30 15];
%linyrange=pi/12*[3 3 3 3  6 -5 -4 -3 -2 -1  0  3  3  3  3  3  3  3  3];
zoffset = 1*z0;

x = zeros([N N length(oaprange)]);
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
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
	oaphi=deg2rad(oaphirange(n));
	[x(:,:,n),y(:,:,n),z(:,:,n),xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	[Ex(:,:,n),Ey(:,:,n),Ez(:,:,n)] = rot(Exo,Eyo,Ezo,oap,oaphi);
	[Exp(:,:,n),Eyp(:,:,n),Ezp(:,:,n)] = MSM(x(:,:,n),y(:,:,n),z(:,:,n),oap,oaphi);
	[Exs(:,:,n),Eys(:,:,n),Ezs(:,:,n)] = Singh(x(:,:,n),y(:,:,n),z(:,:,n));
end
params = {'paramText','$z=%.2fz_0$\\\\$\\theta=%d^\\circ,\\ \\phi=%d^\\circ$',...
		  'drawLegend',true,'relativePhase',true,...'figWidth',14,'invisible',true};
		  'figX',0,'figY',0};
save('data/vo_tour_z1.mat');

FieldCrossMovie(x,y,Ex,Ey,Ez,'Ignatovsky',Exp,Eyp,Ezp,'MSM',Exs,Eys,Ezs,'Singh',...
	paramVals=[(0*oaprange+zoffset);oaprange;oaphirange],lineangy=linyrange,...
	renderParams=params, live=true, movieName="vo_tour_z1");
