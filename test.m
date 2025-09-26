%close all;
[Ex,Ey,Ez] = IgnatovskyIntegral(x, y, z, t);

%% show result w/ diagnostic plots
FieldCrossRender(x, y, z, Ex, Ey, Ez, 1);
fig = gcf; fig.Name = "IgnatovskyIntegral";
FieldCrossRender(x, y, z,Exp,Eyp,Ezp, 2);
fig = gcf; fig.Name = "CylinderIntegral";
Exr = abs(Ex-Exp);
centErr = max(Exr,[],"all")/max(abs(Exp),[],"all");
fprintf("center error = %d\n",centErr);
%fig = figure(Name="difference: (CylinderIntegral - EPeatross)");
%surf(x,y,Exr);
%zlim([0 centErr*2]);
