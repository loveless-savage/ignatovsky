%% this script takes a cross section of the beam & compares models
classdef FieldCrossRender
properties
	fig % figure itself
	paramText = "$z = %3.2f \\lambda$"; % left corner text
	drawLegend = false; % should we draw the legend?
end
properties (SetAccess = private)
	ax2 % upper plots
	ay2
	az2
	ax1 % lower plots
	ay1
	az1
end

methods
function F = FieldCrossRender(x, y, Ex, Ey, Ez, Exp, Eyp, Ezp, options)
	arguments
		x double % observation coordinates (grids)
		y double
		%z double % slice position along the beam (scalar constant)
		Ex double % field components
		Ey double
		Ez double
		Exp double % field components
		Eyp double
		Ezp double
		% name-value arguments
		options.figX double = 6.9 %0.0,6.9,13.8
		options.figY double = 4.0
		options.figWidth  double = 10 %15 %6.7
		options.figHeight double = 6.9 %10.35 %4.6
		options.paramText string = ''
		options.legend logical = true
	end

	if isfield(options,'paramText')
		F.paramText = options.paramText;
	end
	if isfield(options,'legend')
		F.drawLegend = options.legend;
	end

	F.fig = figure('Units','Inches', ...
					'Position',[options.figX options.figY options.figWidth options.figHeight+.3]);
	F.fig.InvertHardcopy = 'off';
	F.fig.Color = 'white';

	F = F.Render(x, y, Ex, Ey, Ez, Exp, Eyp, Ezp, 0);
end

function F = Render(F, x, y, Ex, Ey, Ez, Exp, Eyp, Ezp, paramVal)
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
	text(xmin,xmax*1.6,sprintf(F.paramText,paramVal), ...
		'Interpreter','latex','FontSize',14);
	hold off

	% upper middle axes: y-component
	F.ay2=axes('position',[.38 0.49 .25 .33]);
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

	% upper right axes: z-component
	F.az2=axes('position',[.71 0.49 .25 .33]);
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

	% lower left axes: x-cross section
	F.ax1=axes('position',[.05 0.09 .25 .33]);
	Ex0complex = max(Exp,[],"all");
	phsglobal = conj(Ex0complex)/abs(Ex0complex);
	% render complex phase
	Ex0=abs(Ex0complex);
	image([xmin xmax],[ymin ymax],PhaseColor(Exp/Ex0*phsglobal,5));
	set(F.ax2,'YDir','normal'); % image() reverses y-axis coordinates
	axis square;
	axis off;
	% title w/ formatting
	xdigits = ceil(-log10(Ex0));
	title(['$E_x (\rho,\phi)/ (' num2str(round(Ex0*10^xdigits)/10^xdigits) ' E_0)$'], ...
		'Interpreter','latex')
	hold on
	text(xmin,-ymin*1.3,"Bottom = Ignatovsky", ...
		'Interpreter','latex','FontSize',14);
	hold off

	% lower middle axes: y-cross section
	F.ay1=axes('position',[.38 0.09 .25 .33]);
	% render complex phase
	Ey0 = max(abs(Eyp),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Eyp/Ey0*phsglobal,5));
	set(F.ay2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	ydigits = ceil(-log10(Ey0));
	title(['$E_y (\rho,\phi)/ (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
		'Interpreter','latex')

	% lower right axes: z-cross section
	F.az1=axes('position',[.71 0.09 .25 .33]);
	% render complex phase
	Ez0 = max(abs(Ezp),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Ezp/Ez0*phsglobal,5));
	set(F.az2,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	zdigits = ceil(-log10(Ez0));
	title(['$E_z (\rho,\phi)/ (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
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
