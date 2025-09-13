close all;
[Ex,Ey,Ez] = CylinderIntegral(x, y, z, t);
%[Ex,Ey,Ez] = arrayfun(@(r,p) CylinderIntegral(z,r,p,fnum,thetaMax),rho,phi);

%% show result w/ diagnostic plots
FieldCrossRender(x, y, z, Ex, Ey, Ez, 1);
fig = gcf; fig.Name = "CylinderIntegral";
FieldCrossRender(x, y, z,Exp,Eyp,Ezp, 2);
fig = gcf; fig.Name = "EPeatross";
Exr = Ex-Exp;
fig = figure(Name="CylinderIntegral - EPeatross");
surf(x,y,Exr);
