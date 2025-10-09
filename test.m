close all;
oap = deg2rad(15);

% off-axis, viewing plane unaltered
[Exo,Eyo,Ezo] = IgnatovskyIntegral(x,y,z,t,oap,oaphi);
[Exq,Eyq,Ezq] = rot(Exo,Eyo,Ezo,oap,oaphi);

% off-axis, viewing plane rotated orthogonal to beam
[xo,yo,zo] = rot(x,y,z,-oap,oaphi);
[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
[Exr,Eyr,Ezr] = rot(Exo,Eyo,Ezo,oap,oaphi);

% off-axis, viewing plane rotated halfway between
[xo,yo,zo] = rot(x,y,z,-oap/2,oaphi);
[Exo,Eyo,Ezo] = IgnatovskyIntegral(xo,yo,zo,t,oap,oaphi);
[Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap/2,oaphi);

%% show result w/ diagnostic plots
FieldCrossRender(x, y, zplane,Exp,Eyp,Ezp, 2);
fig = gcf; fig.Name = "theta=0";
FieldCrossRender(x, y, zplane, Exq,Eyq,Ezq, 1);
fig = gcf; fig.Name = "theta=15,plane=0";
FieldCrossRender(x, y, zplane, Ex, Ey, Ez, 2);
fig = gcf; fig.Name = "theta=15,plane=7.5";
FieldCrossRender(x, y, zplane, Exr,Eyr,Ezr, 3);
fig = gcf; fig.Name = "theta=15,plane=15";
%Exr = abs(Exp)-abs(Ex);
%centErr = max(Exr,[],"all")/max(abs(Exp),[],"all");
%fprintf("center error = %d\n",centErr);
