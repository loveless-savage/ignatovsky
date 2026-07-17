function mirror3D(f, fnum, oap, azi, fig)
	if nargin>4
		clf(fig);
	else
		figure('Position',[200 500 840 840]);
	end
	% mirror surface
	wbeam = f*sec(oap/2)^2/2/fnum;
	D = 2*f*(1+1.05/2/fnum);
	[r,p] = meshgrid(0:D/200:D,0:0.03:6.3);
	xsurf = r.*cos(p); ysurf = r.*sin(p);
	zsurf = r.^2/4/f - f;
	surf(xsurf,ysurf,zsurf,'EdgeColor','none','FaceColor','white')
	% camera + lighting
	campos([-4 2 6])
	camup([0 1 0])
	axis equal
	axis off
	light(Position=[0 60 50])
	material('dull')
	hold on

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
	ztraces = ztraces + 0.01;
	plot3(xtraces,ytraces,ztraces,'Color',[0.1 0.2 0.9],'LineWidth',2);
	% TODO: mirror rim

	% incoming collimated laser cylinder
	r0 = 2*f*tan(oap/2);
	x0 = r0*cos(azi); y0 = r0*sin(azi);
	z0 = r0^2/4/f - f;
	[zincident,pincident] = meshgrid([0 2*f/fnum], 0:0.06:6.3);
	xincident = x0 + wbeam*cos(pincident); yincident = y0 + wbeam*sin(pincident);
	zincident(:,1) = (xincident(:,1).^2 + yincident(:,1).^2)/4/f - f;
	surf(xincident,yincident,zincident,'EdgeColor','none','FaceColor','magenta','FaceAlpha',0.2)
	% reflected, focusing beam cone
	xcone = xincident; ycone = yincident; zcone = zincident;
	xcone(:,2) = 0;    ycone(:,2) = 0;    zcone(:,2) = 0;
	surf(xcone,ycone,zcone,'EdgeColor','none','FaceColor','magenta','FaceAlpha',0.7)
	material('dull')
	%plot3([x0 x0 0],[y0 y0 0],[2*f/fnum z0 0],'Color',[0.8 0 0.8],'LineWidth',2);
	% TODO: do we like a line showing contact circle?
	% TODO: dot at center of reflection

	% TODO: labels -- theta,phi,oap on mirror
