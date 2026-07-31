%% this script takes a cross section of the beam & compares models
classdef FieldCrossRender
properties
	fig % figure itself
	paramText = "$z = %3.2f \\lambda$"; % left corner text
	paramText2 = ""; % right corner text (suppressed by legend box)
	drawLineout = true; % whether to include 2D lower row
	drawAlt = false; % whether to show an additional phase plot using altE
	altE = {}; % for comparing more than 1 field
	isB = false; % change label formatting when rendering E and B
	drawHeader = true;
	drawLegend = false;
end
properties (SetAccess = private)
	axm % main plots
	aym
	azm
	axl % lineout plots
	ayl
	azl
	axa % alt plots
	aya
	aza
	figWidth = 10
	% components of figHeight are:
	% 1. total figure height in Inches
	% 2. normalized vertical alignment of main image row
	% 3. normalized vertical alignment of lineout image row
	% 4. normalized vertical alignment of altE image row
	% 5. normalized image height
	% 6. normalized vertical alignment of header colorbar
	% 7. normalized colorbar height
	figHeight = [7.2 0.49 0.09 0.09 0.33 0.89 0.05];
	sf = 1 % scaling factor, comparing to width 10"
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
		options.figWidth double = 10
		options.paramText string = ''
		options.paramText2 string = ''
		options.drawLineout logical = true
		options.drawAlt logical = false
		options.altE cell = {}
		options.isB logical = false
		options.drawHeader logical = true
		options.drawLegend logical = false
	end

	if isfield(options,'figWidth')
		F.figWidth = options.figWidth;
		F.sf = F.figWidth/10;
	end
	F.figHeight(1) = 7.2*F.sf;

	if isfield(options,'paramText')
		F.paramText = options.paramText;
	end
	if isfield(options,'paramText2')
		F.paramText2 = options.paramText2;
	end
	if isfield(options,'drawLineout')
		F.drawLineout = options.drawLineout;
	end
	if isfield(options,'drawAlt')
		F.drawAlt = options.drawAlt;
	end
	if isfield(options,'altE')
		F.altE = options.altE;
	end
	if isfield(options,'isB')
		F.isB = options.isB;
	end
	if isfield(options,'drawHeader')
		F.drawHeader = options.drawHeader;
	end
	if F.drawLineout==1 && F.drawHeader==1 && isfield(options,'drawLegend')
		F.drawLegend = options.drawLegend;
	end

	% figure heights for 2 plot rows (default) but no header
	if options.drawHeader==0
		F.figHeight(1) = 6.4*F.sf;
		F.figHeight(2) = 0.55;
		F.figHeight(3) = 0.1;
		F.figHeight(4) = 0.1;
		F.figHeight(5) = 0.37;
	end
	% figure heights for 1 plot row
	if F.drawLineout==0 && F.drawAlt==0
		if F.drawHeader==0 % no header
			F.figHeight(1) = 3.2*F.sf;
			F.figHeight(2) = 0.1;
			F.figHeight(5) = 0.74;
		else % header
			F.figHeight(1) = 4.0*F.sf;
			F.figHeight(2) = 0.078;
			F.figHeight(5) = 0.6;
			F.figHeight(6) = 0.8;
			F.figHeight(7) = 0.09;
		end
	% figure heights for 3 plot rows
	elseif F.drawAlt==1 && (F.drawLineout==1 || length(F.altE)>3)
		if F.drawHeader==0 % no header
			F.figHeight(1) = 9.6*F.sf;
			F.figHeight(2) = 0.4;
			F.figHeight(3) = 0.1;
			F.figHeight(4) = 0.7;
			F.figHeight(5) = 0.247;
		else % header
			F.figHeight(1) = 10.4*F.sf;
			F.figHeight(2) = 0.37;
			F.figHeight(3) = 0.09;
			F.figHeight(4) = 0.64;
			F.figHeight(5) = 0.23;
			F.figHeight(6) = 0.924;
			F.figHeight(7) = 0.034;
		end
	end

	F.fig = figure('Units','Inches','Position', ...
			[options.figX options.figY options.figWidth F.figHeight(1)]);
	F.fig.InvertHardcopy = 'off';
	F.fig.Color = 'white';

	F = F.Render(x, y, Ex, Ey, Ez, 0);
end

function F = Render(F, x, y, Ex, Ey, Ez, paramVal, oap, oaphi)
	% scale label text with figure size
	set(0,'DefaultAxesFontSize',16);
	fontsize(scale=F.sf);
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
	Ex0 = abs(Ex0complex);
	phsglobal = conj(Ex0complex)/abs(Ex0complex);

	% upper left axes: x-component
	F.axm=axes('position',[.05 F.figHeight(2) .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Ex/Ex0*phsglobal,5));
	set(F.axm,'YDir','normal'); % image() reverses y-axis coordinates
	axis square;
	axis off;
	% title w/ formatting
	xdigits = ceil(-log10(Ex0));
	title('$E_x / E_0$','Interpreter','latex')
	hold on

	% included with the upper left plot is the label reporting our slicing parameter
	% (z-plane, slicing angle, etc)
	if F.drawHeader==1
		annotation('textbox',[.05 F.figHeight(6) .1 F.figHeight(7)],...
			'String',sprintf(F.paramText,paramVal),...
			'Interpreter','latex','FontSize',20,'EdgeColor','none');
	else
		annotation('textbox',[0.048 0.37 0.1 0.1],...
			'String',sprintf(F.paramText,paramVal),...
			'Interpreter','latex','FontSize',20,...
			'EdgeColor','none','Rotation',90);
	end
	% cross-section line
	if F.drawLineout==1
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	end
	hold off

	% upper middle axes: y-component
	F.aym=axes('position',[.38 F.figHeight(2) .25 F.figHeight(5)]);
	% render complex phase
	Ey0 = max(abs(Ey),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Ey/Ey0*phsglobal,5));
	set(F.aym,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	ydigits = ceil(-log10(Ey0/Ex0));
	title(['$E_y / (' num2str(round(Ey0/Ex0*10^ydigits)/10^ydigits) ' E_0)$'], ...
		'Interpreter','latex')
	% cross-section line (diagonal on this one)
	hold on
	if F.drawLineout==1
		plot3([-sqrt(xmin^2/2),sqrt(xmax^2/2)],[-sqrt(xmin^2/2),sqrt(xmax^2/2)],[2,2], ...
			'w--','LineWidth',1);
	end
	hold off

	% upper right axes: z-component
	F.azm=axes('position',[.71 F.figHeight(2) .25 F.figHeight(5)]);
	% render complex phase
	Ez0 = max(abs(Ez),[],"all");
	image([xmin xmax],[ymin ymax],PhaseColor(Ez/Ez0*phsglobal,5));
	set(F.azm,'YDir','normal');
	axis square;
	axis off;
	% formatted title
	zdigits = ceil(-log10(Ez0/Ex0));
	title(['$E_z / (' num2str(round(Ez0/Ex0*10^zdigits)/10^zdigits) ' E_0)$'], ...
		'Interpreter','latex')
	% add secondary label in top right if no lower plots
	if F.drawLegend==0 && (F.drawLineout==1 || length(F.altE)==0) && strcmp(F.paramText2,"")==0
		text(xmax,xmax*1.6,F.paramText2,...
			'Interpreter','latex','FontSize',1.5*F.figWidth,'HorizontalAlignment','right');
	end
	% cross-section line
	hold on
	if F.drawLineout==1
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	end
	hold off

	if F.drawLineout==1
		F = F.lineout(x,y,Ex,Ey,Ez,xrange,yrange);
	end
	if F.drawAlt==1
		F = F.altPlots(x,y,...
			cell2mat(F.altE(1)),cell2mat(F.altE(2)),cell2mat(F.altE(3)),...
			xrange,yrange);
	end
	% TODO: lineout=false,alt=true,altE>3 --> draw bottom row

	% top colorbar
	if F.drawHeader==1
		F = F.colorbar();
	end
end

function F = lineout(F,x,y,Ex,Ey,Ez,xrange,yrange)
	% interpolate string of points from each matrix to get cross sections
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);
	Exf = interp2(x,y,Ex,xrange,0*yrange); % FIXME: xo,yo
	Eyf = interp2(x,y,Ey,sqrt(0.5)*xrange,sqrt(0.5)*yrange);
	Ezf = interp2(x,y,Ez,xrange,0*yrange);
	% normalization factors
	Ex0 = max(abs(Ex),[],"all");
	Ey0 = max(abs(Ey),[],"all");
	Ez0 = max(abs(Ez),[],"all");

	% second lineout for comparison?
	if length(F.altE)>0
		Exa = cell2mat(F.altE(1));
		Eya = cell2mat(F.altE(2));
		Eza = cell2mat(F.altE(3));
		Exaf = interp2(x,y,Exa,xrange,0*yrange);
		Eyaf = interp2(x,y,Eya,sqrt(0.5)*xrange,sqrt(0.5)*yrange);
		Ezaf = interp2(x,y,Eza,xrange,0*yrange);
		Exa0 = max(abs(Exa),[],"all");
		Eya0 = max(abs(Eya),[],"all");
		Eza0 = max(abs(Eza),[],"all");
	end
	% include singh model lineout
	if length(F.altE)>3
		Exs = cell2mat(F.altE(4));
		Eys = cell2mat(F.altE(5));
		Ezs = cell2mat(F.altE(6));
		Exsf = interp2(x,y,Exs,xrange,0*yrange);
		Eysf = interp2(x,y,Eys,sqrt(0.5)*xrange,sqrt(0.5)*yrange);
		Ezsf = interp2(x,y,Ezs,xrange,0*yrange);
		Exs0 = max(abs(Exs),[],"all");
		Eys0 = max(abs(Eys),[],"all");
		Ezs0 = max(abs(Ezs),[],"all");
	end

	% left axes: x-cross section
	F.axl=axes('position',[.05 F.figHeight(3) .25 F.figHeight(5)]);
	hold on
	if length(F.altE)>3
		plot(xrange,abs(Exsf)/Exs0,'--','Color',[49,54,143]/255,'LineWidth',1.0);
	end
	if length(F.altE)>0
		plot(xrange,abs(Exaf)/Exa0,'Color',[200,0,0]/255,'LineWidth',1.5);
	end
	plot(xrange,abs(Exf)/Ex0,'Color',[49,54,143]/255,'LineWidth',1.5);
	hold off
	set(F.axl,'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	F.axl.XTick = [xmin 0 xmax] * 0.8;
	F.axl.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.axl.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	%xdigits = ceil(-log10(Ex0));
	title('$\left| E_x \right| / E_0$', 'Interpreter','latex');
	% include a legend box in the upper-right corner of the figure
	if F.drawLegend==1
		legendList={'MSM'};
		if length(F.altE)>0
			legendList=[{'Ignatovsky'} legendList];
		end
		if length(F.altE)>3
			legendList=[{'Singh'} legendList];
		end
		la=legend(legendList,'Location','southwest','Direction','reverse');
		set(la, 'Position',[0.79 F.figHeight(6) .1 .05]);
	end

	% middle axes: y-cross section
	F.ayl=axes('position',[.38 F.figHeight(3) .25 F.figHeight(5)]);
	hold on
	if length(F.altE)>3
		plot(xrange,abs(Eysf)/Eys0,'--','Color',[49,54,143]/255,'LineWidth',1.0);
	end
	if length(F.altE)>0
		plot(xrange,abs(Eyaf)/Eya0,'Color',[200,0,0]/255,'LineWidth',1.5);
	end
	plot(xrange,abs(Eyf)/Ey0,'Color',[49,54,143]/255,'LineWidth',1.5);
	hold off
	set(F.ayl,'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	F.ayl.XTick = [xmin 0 xmax] * 0.8;
	F.ayl.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ayl.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	ydigits = ceil(-log10(Ey0/Ex0));
	title(['$\left| E_y \right| / (' ...
		num2str(round(Ey0/Ex0*10^ydigits)/10^ydigits) ...
		' E_0)$'], 'Interpreter','latex')

	% right axes: z-cross section
	F.azl=axes('position',[.71 F.figHeight(3) .25 F.figHeight(5)]);
	hold on
	if length(F.altE)>3
		plot(xrange,abs(Ezsf)/Ezs0,'--','Color',[49,54,143]/255,'LineWidth',1.0);
	end
	if length(F.altE)>0
		plot(xrange,abs(Ezaf)/Eza0,'Color',[200,0,0]/255,'LineWidth',1.5);
	end
	plot(xrange,abs(Ezf)/Ez0,'Color',[49,54,143]/255,'LineWidth',1.5);
	hold off
	set(F.azl,'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	F.azl.XTick = [xmin 0 xmax] * 0.8;
	F.azl.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.azl.YTick = [0 1];
	xlim([xmin xmax]);
	ylim([0 1.05]);
	axis square;
	% formatted title
	zdigits = ceil(-log10(Ez0/Ex0));
	title(['$\left| E_z \right| / (' ...
		num2str(round(Ez0/Ex0*10^zdigits)/10^zdigits) ...
		' E_0)$'], 'Interpreter','latex')
end

function F = altPlots(F, x, y, Exp, Eyp, Ezp, xrange, yrange)
	% min/max values
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);
	% if plotting the B field, we want to normalize relative to B_y
	if F.isB
		E0complex = max(Eyp,[],"all");
		phsglobal = conj(E0complex)/abs(E0complex);
		Ex0 = max(abs(Exp),[],"all");
		Ey0 = abs(E0complex);
		Ez0 = max(abs(Ezp),[],"all");
		xdigits = ceil(-log10(Ex0/Ey0));
		zdigits = ceil(-log10(Ez0/Ey0));
	else
		E0complex = max(Exp,[],"all");
		phsglobal = conj(E0complex)/abs(E0complex);
		Ex0 = abs(E0complex);
		Ey0 = max(abs(Eyp),[],"all");
		Ez0 = max(abs(Ezp),[],"all");
		ydigits = ceil(-log10(Ey0/Ex0));
		zdigits = ceil(-log10(Ez0/Ex0));
	end
	% left axes: x-cross section
	F.axa=axes('position',[.05 F.figHeight(4) .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Exp/Ex0*phsglobal,5));
	set(F.axa,'YDir','normal'); % image() reverses y-axis coordinates
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.axa.XTick = [xmin 0 xmax] * 0.8;
	F.axa.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.axa.YTick = [ymin 0 ymax] * 0.8;
	F.axa.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	axis square;
	axis off;
	% title w/ formatting
	if F.isB
		title(['$c B_x / (' num2str(round(Ex0*10^xdigits)/10^xdigits) ' B_0)$'], ...
			'Interpreter','latex')
	else
		title(['$E_x / E_0$'], ...
			'Interpreter','latex')
		hold on
		text(xmin,-ymin*1.3,F.paramText2, ...
			'Interpreter','latex','FontSize',14);
		hold off
	end

	% middle axes: y-cross section
	F.aya=axes('position',[.38 F.figHeight(4) .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Eyp/Ey0*phsglobal,5));
	set(F.aya,'YDir','normal');
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.aya.XTick = [xmin 0 xmax] * 0.8;
	F.aya.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.aya.YTick = [ymin 0 ymax] * 0.8;
	F.aya.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	axis square;
	axis off;
	% formatted title
	if F.isB
		title(['$c B_y / B_0$'], ...
			'Interpreter','latex')
	else
		title(['$E_y / (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
			'Interpreter','latex')
	end

	% right axes: z-cross section
	F.aza=axes('position',[.71 F.figHeight(4) .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Ezp/Ez0*phsglobal,5));
	set(F.aza,'YDir','normal');
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.aza.XTick = [xmin 0 xmax] * 0.8;
	F.aza.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.aza.YTick = [ymin 0 ymax] * 0.8;
	F.aza.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	axis square;
	axis off;
	% formatted title
	if F.isB
		title(['$c B_z / (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' B_0)$'], ...
			'Interpreter','latex')
	else
		title(['$E_z / (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
			'Interpreter','latex')
	end
end

function F = colorbar(F)
	acb=axes('position',[.38 F.figHeight(6) .25 F.figHeight(7)]);
	% render spectrum of phase colors
	phase = 0:pi/50:2*pi;
	amplitude = 0:0.02:1;
	[P,A] = meshgrid(phase,amplitude);
	image([0 2*pi],[0 1],PhaseColor(A.*exp(1i*P),5));
	set(acb,'YDir','normal','XAxisLocation','top');
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

