function mirror3D(fnum, oap, azi, fig)
	if nargin>3
		clf(fig);
	else
		figure('Position',[200 500 800 800]);
	end
	sf = get(gcf).Position(3)/800; % get scale factor
	axes('Position',[-0.05 0.02 1 1]);
	% mirror surface
	f = 1;
	wbeam = f*secd(oap/2)^2/2/fnum;
	D = 2*f*(1+1.05/2/fnum);
	[r,p] = meshgrid(0:D/200:D,0:0.03:6.3);
	xsurf = r.*cos(p); ysurf = r.*sin(p);
	zsurf = r.^2/4/f - f;
	surf(xsurf,ysurf,zsurf-0.02,'EdgeColor','none','FaceColor','white')
	% camera + lighting
	mycampos = [-4 2 6];
	campos(mycampos)
	camup([0 1 0])
	axis equal
	axis off
	light(Position=[0 60 50])
	material('dull')
	hold on

	% mirror rim
	xrim = repmat(xsurf(:,end),1,2);
	yrim = repmat(ysurf(:,end),1,2);
	zrim = 0*xrim + zsurf(1,end); zrim(:,2) = 0.5*zsurf(1,end);
	surf(xrim,yrim,zrim,'EdgeColor',[0.1 0.2 0.9],'LineWidth',1*sf,'FaceColor','white');

	% traces on mirror surface
	xtraces = zeros(211,6); ytraces = xtraces; ztraces = xtraces;
	xtraces(:,1) = 2*f*cos(0:0.03:6.3); ytraces(:,1) = 2*f*sin(0:0.03:6.3);
	ztraces(:,1) = 0;
	xtraces(:,2) = 2*f*tan(pi/8)*cos(0:0.03:6.3); ytraces(:,2) = 2*f*tan(pi/8)*sin(0:0.03:6.3);
	ztraces(:,2) = f*tan(pi/8)^2 - f;
	rhomeridian = 2*f*(-1:1/105:1);
	xtraces(:,3) = rhomeridian; ytraces(:,4) = rhomeridian;
	xtraces(:,5) = sqrt(0.5)*rhomeridian; ytraces(:,5) = xtraces(:,5);
	xtraces(:,6) = xtraces(:,5); ytraces(:,6) = -xtraces(:,5);
	ztraces(:,3:6) = repmat((rhomeridian.').^2/4/f-f, 1, 4);
	ztraces = ztraces - 0.01;
	plot3(xtraces,ytraces,ztraces,'Color',[0.1 0.2 0.9],'LineWidth',2*sf);
	% trace labels
	text(-0.7,-0.8,-0.5,"$45^\circ$",'Interpreter','Latex','FontSize',20*sf,'Color',[0.1 0.2 0.9]);
	text(-0.5,-2.1, 0.2,"$90^\circ$",'Interpreter','Latex','FontSize',20*sf,'Color',[0.1 0.2 0.9]);

	% incoming collimated laser cylinder
	r0 = 2*f*tand(oap/2);
	x0 = r0*cosd(azi); y0 = r0*sind(azi);
	z0 = r0^2/4/f - f;
	[zincident,pincident] = meshgrid([0 2*f/fnum], 0:0.06:6.3);
	xincident = x0 + wbeam*cos(pincident); yincident = y0 + wbeam*sin(pincident);
	zincident(:,1) = (xincident(:,1).^2 + yincident(:,1).^2)/4/f - f;
	surf(xincident,yincident,zincident,'EdgeColor','none','FaceColor','magenta','FaceAlpha',0.2)
	% green rim highlighting reflection site
	plot3(xincident(:,1),yincident(:,1),zincident(:,1),'-c','LineWidth',3*sf);
	% green dot showing where center of incident beam strikes mirror;
	% it must be projected forward so it doesn't get hidden by the beam cone
	hologram0 = [x0 y0 z0-0.05] + mycampos/mycampos(3)*(2*f/fnum-z0);
	scatter3(hologram0(1),hologram0(2),hologram0(3),30*sf,'cyan','filled');
	% reflected, focusing beam cone
	xcone = xincident; ycone = yincident; zcone = zincident;
	xcone(:,2) = 0;    ycone(:,2) = 0;    zcone(:,2) = 0;
	surf(xcone,ycone,zcone,'EdgeColor','none','FaceColor','magenta','FaceAlpha',0.7)
	material('dull')

	% angle labels
	oaplbl = sprintf("$\\theta=%2d^\\circ$",oap);
	azilbl = sprintf("$\\phi=%2d^\\circ$",azi);
	text(-2.8,2.8,{oaplbl,azilbl},'Interpreter','Latex','FontSize',24*sf)
