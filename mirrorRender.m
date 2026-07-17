oaprange   = [ 0  5 10 30 45 60 80 85 90 90 90 90 90 90 90 90 ...
			  90 85 75 50 25 15 10 10 10 10 10 10 10 10 10  7  3];
oaphirange = [ 0  0  0  0  0  0  0  0  0  5 15 30 45 60 75 85 ...
			  90 90 90 90 90 90 90 85 75 60 45 30 15  5  0  0  0];

figure('Position',[200 500 840 840]);

for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	oaphi=deg2rad(oaphirange(n));
	mirror3D(1,1.5,oap,oaphi,gcf);
	pause(1);
	%imwrite(getframe(gcf).cdata(100:750,150:800,:),"figures/dish/"+num2str(n,"%02d")+".tif");
	n
end

