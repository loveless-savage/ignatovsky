%% this script takes a cross section of the beam & compares models
classdef FieldCrossRender
properties
	fig
	%% overall figure layout
	figX = 6.9;%0.0,6.9,13.8
	figY = 4.0;
	figWidth = 15;%6.7;
	figHeight = 10.35;%4.6;
	% upper plots
	ax2
	ay2
	az2
	% lower plots
	ax1
	ay1
	az1
	% slicing parameter label
	paramText = "$z = %3.2f \\lambda$";
end
methods
function F = FieldCrossRender(x, y, z, Ex, Ey, Ez, figX, figY, paramText)
	% required variables:
	% [x, y]         <-- observation coordinates (grids)
	% z              <-- slice position along the beam (scalar constant)
	% [Ex, Ey, Ez]   <-- results of Ignatovsky Integration
	% [Bx, By, Bz]   <-- TODO
	% @PhaseColor    <-- colormap

	% where to place figure on the screen
	if nargin>7
		F.figX = figX;
		F.figY = figY;
	end
	if nargin==7
		F.paramText = figX;
	end
	if nargin==9
		F.paramText = paramText;
	end
	F.fig = figure('Units','Inches','Position',[F.figX F.figY F.figWidth F.figHeight+.3]);
	F.fig.InvertHardcopy = 'off';
	F.fig.Color = 'white';

	F = F.Render(x, y, z, Ex, Ey, Ez, 0);
end

function F = Render(F, x, y, z, Ex, Ey, Ez, paramVal)
	clf(F.fig);
	%% boundary information about observation plane from given meshgrids
	% value ranges
	xrange = x(1,:);
	yrange = y(:,1)';
	% min/max values
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);

	% apply global phase offset based on max value of Ex
	Ex0complex = max(Ex,[],"all");
	phsglobal = conj(Ex0complex)/abs(Ex0complex);

	% interpolate string of points from each matrix to get cross sections
	Exf = interp2(x,y,Ex,xrange,0*yrange); % FIXME: xo,yo
	Eyf = interp2(x,y,Ey,sqrt(0.5)*xrange,sqrt(0.5)*yrange);
	Ezf = interp2(x,y,Ez,xrange,0*yrange);

	% upper left axes: x-component
	F.ax2=axes('position',[.05 0.49 .25 .33]);
	% render complex phase
	Ex0=abs(Ex0complex);
	image([xmin xmax],[ymin ymax],PhaseColor(Ex/Ex0*phsglobal,5));
	set(F.ax2,'YDir','normal'); % image() reverses y-axis coordinates
	axis square;
	axis off;
	% title w/ formatting
	xdigits = ceil(-log10(Ex0));
	title(['$E_x (\rho,\phi)/ (' num2str(round(Ex0*10^xdigits)/10^xdigits) ' E_0)$'], ...
		'Interpreter','latex')
	hold on

	% included with the upper left plot is the label reporting our slicing parameter
	% (z-plane, slicing angle, etc)
	if nargin>7
		text(xmin,xmax*1.6,sprintf(F.paramText,paramVal), ...
			'Interpreter','latex','FontSize',14);
	end
	% cross-section line
	plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	hold off

	% upper middle axes: y-component
	F.ay2=axes('position',[.38 0.49 .25 .33]);
	% render complex phase
	Ey0 = abs(max(Ey,[],"all"));
	image([xmin xmax],[ymin ymax],PhaseColor(Ey/Ey0*phsglobal,5));
	set(F.ay2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	ydigits = ceil(-log10(Ey0));
	title(['$E_y (\rho,\phi)/ (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
		'Interpreter','latex')
	hold on
	% cross-section line (diagonal on this one)
	plot3([-sqrt(xmin^2/2),sqrt(xmax^2/2)],[-sqrt(xmin^2/2),sqrt(xmax^2/2)],[2,2],'w--','LineWidth',1);
	hold off

	% upper right axes: z-component
	F.az2=axes('position',[.71 0.49 .25 .33]);
	% render complex phase
	Ez0 = abs(max(Ez,[],"all"));
	image([xmin xmax],[ymin ymax],PhaseColor(Ez/Ez0*phsglobal,5));
	set(F.az2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	zdigits = ceil(-log10(Ez0));
	title(['$E_z (\rho,\phi)/ (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
		'Interpreter','latex')
	hold on
	% cross-section line
	plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	hold off

	% lower left axes: x-cross section
	F.ax1=axes('position',[.05 0.09 .25 .33]);
	plot(xrange,abs(Exf)/Ex0,'Color',[49,54,143]/255,'LineWidth',1.5);
	set(F.ax1,'YDir','normal');
	% label axes
	xlabel('$\rho / \lambda$','Interpreter','latex');
	F.ax1.XTick = [xmin 0 xmax] * 0.8;
	F.ax1.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ax1.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	title(['$\left| E_x(\rho,\phi=0) \right| / (' num2str(round(Ex0*10^xdigits)/10^xdigits) ' E_0)$'], ...
		'Interpreter','latex')
	% include a legend box in the upper-right corner of the figure
	la=legend('Ignatovsky','Location','southwest');
	set(la, 'Position',[0.75 0.9 .1 .05],'FontSize',8); % repositioned!

	% lower middle axes: y-cross section
	F.ay1=axes('position',[.38 0.09 .25 .33]);
	plot(xrange,abs(Eyf)/Ey0,'Color',[49,54,143]/255,'LineWidth',1.5);
	set(F.ay1,'YDir','normal');
	% label axes
	xlabel('$\rho / \lambda$','Interpreter','latex');
	F.ay1.XTick = [xmin 0 xmax] * 0.8;
	F.ay1.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ay1.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	title(['$\left| E_y(\rho,\phi=\pi/4) \right| / (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
		'Interpreter','latex')

	% lower right axes: z-cross section
	F.az1=axes('position',[.71 0.09 .25 .33]);
	plot(xrange,abs(Ezf)/Ez0,'Color',[49,54,143]/255,'LineWidth',1.5);
	set(F.az1,'YDir','normal');
	% label axes
	xlabel('$\rho / \lambda$','Interpreter','latex');
	F.az1.XTick = [xmin 0 xmax] * 0.8;
	F.az1.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.az1.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	title(['$\left| E_z(\rho,\phi=0) \right| / (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
		'Interpreter','latex')

	% top colorbar
	acb=axes('position',[.38 .89 .25 .05]);
	% render spectrum of phase colors
	phase = 0:pi/50:2*pi;
	amplitude = 0:0.02:1;
	[P,A] = meshgrid(phase,amplitude);
	image([0 2*pi],[0 1],PhaseColor(A.*exp(1i*P),5));
	set(acb,'YDir','normal','XAxisLocation','top','FontSize',8)
	% label axes
	xlabel('phase');
	ylabel('amp.');
	% add range labels to axes
	acb.XTick = [0 pi 2*pi];
	acb.XTickLabel = {'0','\pi','2\pi'};
	acb.YTick = [-1 0 1];
	% reposition x-axis label
	xlabh = get(acb,'XLabel');
	set(xlabh,'Position',get(xlabh,'Position') - [0 .2 0]);
end
end % methods
end % classdef
