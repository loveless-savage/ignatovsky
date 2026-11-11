%wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
%zrange = 0:5;
%zvals = zrange;

for n=1:length(zrange)
	%zoffset=deg2rad(zrange(n));
	%[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);
	%[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
	%[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi);
	zvals(n) = Ez(33,41,n)*max(Ex(:,:,1),[],"all")/max(abs(Ex(:,:,n)),[],'all');
	[~,~,Ezp(:,:,n)]=MSM(x(:,:,n),y(:,:,n),z(:,:,n),oap,oaphi);
	zvalsp(n)= Ezp(33,41,n)*max(Exp(:,:,1),[],"all")/max(abs(Exp(:,:,n)),[],'all');
	n
end
plot(zrange/z0,abs(zvals));
hold on;
plot(zrange/z0,abs(zvalsp));
