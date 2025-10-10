close all;
oap = deg2rad(15);
oaprange = deg2rad(0:0.5:15);

Exr = zeros([size(x) length(oaprange)]);
Eyr = Exr;
Ezr = Exr;

for n = 1:length(oaprange)
	[xo, yo, zo]  = rot(x,y,z,-oaprange(n),oaphi);
	[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
	[Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n)] = rot(Exo,Eyo,Ezo,oaprange(n),oaphi);
end

%% show result w/ diagnostic plots
F = FieldCrossRender(x, y, zplane,Exr(:,:,1),Eyr(:,:,1),Ezr(:,:,1), 7.5,4.0);%9.0,8.0);
F.fig.Name = "theta=15,plane=0";
for n = 2:length(oaprange)
	pause(0.2);
	F.Render(x, y, zplane,Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n));
	F.fig.Name = "theta=15,plane="+string(rad2deg(oaprange(n)));
end
