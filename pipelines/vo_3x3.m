%% compare MSM and Ignatovsky model results in a 3x3 grid with lineouts
oap = deg2rad(90);
oaphi = deg2rad(0);
%zoffset = 14.32;
wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);

[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,oap,oaphi);
[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi);
[Exp,Eyp,Ezp] = Soap(x,y,z,oap,oaphi);
[Exs,Eys,Ezs] = Singh(x,y,z);

FieldCrossRender(x,y,Ex,Ey,Ez,'Ignatovsky',x,y,Exp,Eyp,Ezp,'MSM',x,y,Exs,Eys,Ezs,'Singh',...
	paramText='$\\theta=90^\\circ,\\ \\phi=0^\\circ$',drawLegend=true,figX=0.5);
