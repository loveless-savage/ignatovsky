%% this script takes a cross section of the beam & compares models
classdef FieldCrossRender
properties
	fig % figure itself
	paramText = "$z = %3.2f \\lambda$"; % left corner text
	drawLineout = true; % deactivates dashed line on upper plots + 2D lower row
	drawHeader = true;
	drawLegend = false;
end
properties (SetAccess = private)
	ax2 % upper plots
	ay2
	az2
	ax1 % lower plots
	ay1
	az1
	% components of figHeight are:
	% 1. total figure height in Inches
	% 2. normalized vertical alignment of main image row
	% 3. normalized vertical alignment of lower image row
	% 4. normalized image height
	% 5. normalized vertical alignment of header colorbar
	% 6. normalized colorbar height
	figHeight = [7.2 0.49 0.09 0.33 0.89 0.05];
end

methods
function F = FieldCrossRender(x, y, Ex, Ey, Ez, options)
	arguments
		x double % observation coordinates (grids)
		y double
		%z double % slice position along the beam (scalar constant)
		Ex double % field components
		Ey double
		Ez double
		% name-value arguments
		options.figX double = 6.9 %0.0,6.9,13.8
		options.figY double = 4.0
		options.figWidth  double = 10 %15 %6.7
		options.figHeight double = 6.9 %10.35 %4.6
		options.paramText string = ''
		options.drawLineout logical = true
		options.drawHeader logical = true
		options.drawLegend logical = false
	end

	F.figHeight(1) = options.figHeight+0.3;

	if isfield(options,'paramText')
		F.paramText = options.paramText;
	end
	if isfield(options,'drawLineout') && options.drawLineout==0
		F.drawLineout = options.drawLineout;
		% adjust figure height
		F.figHeight(1) = F.figHeight(1) - 3.2/6.9*options.figHeight;
		% these numbers apply to no lineout, but header still on
		F.figHeight(2) = 0.078;
		F.figHeight(4) = 0.6;
		F.figHeight(5) = 0.8;
		F.figHeight(6) = 0.09;
	end
	if isfield(options,'drawHeader') && options.drawHeader==0
		F.drawHeader = options.drawHeader;
		% adjust figure height
		F.figHeight(1) = F.figHeight(1) - 0.8/6.9*options.figHeight;
		if F.drawLineout==0 % both lineout and header turned off
			F.figHeight(2) = 0.1;
			F.figHeight(4) = 0.74;
		else % lineout but no header
			F.figHeight(2) = 0.55;
			F.figHeight(3) = 0.1;
			F.figHeight(4) = 0.37;
		end
	end
	if F.drawLineout==1 && F.drawHeader==1 && isfield(options,'drawLegend')
		F.drawLegend = options.drawLegend;
	end

	F.fig = figure('Units','Inches','Position', ...
			[options.figX options.figY options.figWidth F.figHeight(1)]);
	F.fig.InvertHardcopy = 'off';
	F.fig.Color = 'white';

	F = F.Render(x, y, Ex, Ey, Ez, 0);
end

function F = Render(F, x, y, Ex, Ey, Ez, paramVal)
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

	% upper left axes: x-component
	F.ax2=axes('position',[.05 F.figHeight(2) .25 F.figHeight(4)]);
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
	if F.drawHeader==1
		text(xmin,xmax*1.6,sprintf(F.paramText,paramVal), ...
			'Interpreter','latex','FontSize',14);
	else
		annotation('textbox',[0.048 0.37 0.1 0.1],'String',sprintf(F.paramText,paramVal),...
			'Interpreter','latex','FontSize',16,'EdgeColor','none','Rotation',90);
	end
	% cross-section line
	if F.drawLineout==1
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	end
	hold off

	% upper middle axes: y-component
	F.ay2=axes('position',[.38 F.figHeight(2) .25 F.figHeight(4)]);
	% render complex phase
	Ey0 = max(abs(Ey),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Ey/Ey0*phsglobal,5));
	set(F.ay2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	ydigits = ceil(-log10(Ey0));
	title(['$E_y (\rho,\phi)/ (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
		'Interpreter','latex')
	% cross-section line (diagonal on this one)
	if F.drawLineout==1
		hold on
		plot3([-sqrt(xmin^2/2),sqrt(xmax^2/2)],[-sqrt(xmin^2/2),sqrt(xmax^2/2)],[2,2], ...
			'w--','LineWidth',1);
		hold off
	end

	% upper right axes: z-component
	F.az2=axes('position',[.71 F.figHeight(2) .25 F.figHeight(4)]);
	% render complex phase
	Ez0 = max(abs(Ez),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Ez/Ez0*phsglobal,5));
	set(F.az2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	zdigits = ceil(-log10(Ez0));
	title(['$E_z (\rho,\phi)/ (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
		'Interpreter','latex')
	% cross-section line
	if F.drawLineout==1
		hold on
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
		hold off
	end

	if F.drawLineout==1
		F = F.lineout(x,y,Ex,Ey,Ez,xrange,yrange,Ex0,Ey0,Ez0);
	end

	% top colorbar
	if F.drawHeader==1
		acb=axes('position',[.38 F.figHeight(5) .25 F.figHeight(6)]);
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
end

function F = lineout(F,x,y,Ex,Ey,Ez,xrange,yrange,Ex0,Ey0,Ez0)
	% interpolate string of points from each matrix to get cross sections
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);
	Exf = interp2(x,y,Ex,xrange,0*yrange); % FIXME: xo,yo
	Eyf = interp2(x,y,Ey,sqrt(0.5)*xrange,sqrt(0.5)*yrange);
	Ezf = interp2(x,y,Ez,xrange,0*yrange);

	% lower left axes: x-cross section
	F.ax1=axes('position',[.05 F.figHeight(3) .25 F.figHeight(4)]);
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
	xdigits = ceil(-log10(Ex0));
	title(['$\left| E_x(\rho,\phi=0) \right| / (' ...
		num2str(round(Ex0*10^xdigits)/10^xdigits) ...
		' E_0)$'], 'Interpreter','latex')
	% include a legend box in the upper-right corner of the figure
	if F.drawLegend==1
		la=legend('Ignatovsky','Location','southwest');
		set(la, 'Position',[0.75 0.9 .1 .05],'FontSize',8); % repositioned!
	end

	% lower middle axes: y-cross section
	F.ay1=axes('position',[.38 F.figHeight(3) .25 F.figHeight(4)]);
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
	ydigits = ceil(-log10(Ey0));
	title(['$\left| E_y(\rho,\phi=\pi/4) \right| / (' ...
		num2str(round(Ey0*10^ydigits)/10^ydigits) ...
		' E_0)$'], 'Interpreter','latex')

	% lower right axes: z-cross section
	F.az1=axes('position',[.71 F.figHeight(3) .25 F.figHeight(4)]);
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
	zdigits = ceil(-log10(Ez0));
	title(['$\left| E_z(\rho,\phi=0) \right| / (' ...
		num2str(round(Ez0*10^zdigits)/10^zdigits) ...
		' E_0)$'], 'Interpreter','latex')
end
end % methods
end % classdef
