%% compare MSM and Ignatovsky model results, accommodating for focal width scaling
oap = deg2rad(30);
oaphi = deg2rad(0);
zoffset = 10;
f = f*cos(oap/2)^2; % convert from effective focal length to parent focal length
[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);

[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi);
[Exp,Eyp,Ezp] = Soap(x,y,z,oap,oaphi);

FieldCrossRender(x,y,Exp,Eyp,Ezp,altE={Ex,Ey,Ez},...
	paramText='MSM ($\\theta=30^\\circ,\\ z=10\\lambda$)',...
	drawLegend=true,figHeight=10.78125,figWidth=15.625);
