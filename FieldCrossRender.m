%% this script takes a cross section of the beam & compares models
classdef FieldCrossRender
% FieldCrossRender TODO: help text
properties
	fig % figure itself
	paramText = "$z = %3.2f \\lambda$"; % left corner text
	drawLineout = true; % whether to include 2D lower row
	drawAll = true; % only draw the primary phase plot when false
	isB = false; % change label formatting when rendering E and B
	drawHeader = true;
	drawLegend = false;
end
properties (SetAccess = private)
	ax = {} % plots
	ay = {}
	az = {}
	figWidth = 10
	% components of figHeight are:
	% 1. total figure height in Inches
	% 2. normalized vertical alignment of first (top) image row
	% 3. normalized vertical alignment of second image row
	% 4. normalized vertical alignment of third image row (or lineout plots)
	% 5. normalized image height
	% 6. normalized vertical alignment of header colorbar
	% 7. normalized colorbar height
	figHeight = [7.2 0.49 0.09 0.09 0.33 0.89 0.05];
	sf = 1 % scaling factor, comparing to width 10"
end

methods
function F = FieldCrossRender(x, y, Ex, Ey, Ez, rowLabel, options)
	arguments (Repeating)
		x double % observation coordinates (grids)
		y double
		Ex double % field components
		Ey double
		Ez double
		rowLabel string % name of field
	end
	arguments
		% name-value arguments
		options.figX double = 6.9 %0.0,6.9,13.8
		options.figY double = 4.0
		options.figWidth double = 10
		options.paramText string = ''
		options.drawLineout logical = true
		options.drawAll logical = true
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
	if isfield(options,'drawLineout')
		F.drawLineout = options.drawLineout;
	end
	if isfield(options,'drawAll')
		F.drawAll = options.drawAll;
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

	numRows = max(length(x)*F.drawAll,1);
	switch (numRows+F.drawLineout)
		% figure heights for 1 plot row
		case 1
			if F.drawHeader==0 % no header
				F.figHeight(1:5) = [3.2*F.sf 0.1   0.1   0.1   0.74];
			else % header
				F.figHeight(1:7) = [4.0*F.sf 0.078 0.078 0.078 0.6  0.8   0.09];
			end
		% figure heights for 2 plot rows
		case 2
			if options.drawHeader==0
				F.figHeight(1:5) = [6.4*F.sf 0.55  0.1   0.1   0.37];
			else % header
				F.figHeight(1:7) = [7.2*F.sf 0.49  0.09  0.09  0.33 0.89  0.05];
			end
		% figure heights for 3 plot rows
		otherwise
			if F.drawHeader==0 % no header
				F.figHeight(1:5) = [9.6*F.sf 0.7   0.4   0.1   0.247];
			else % header
				F.figHeight(1:7) = [10.4*F.sf 0.64 0.37  0.09  0.23  0.924 0.034];
			end
	end

	F.fig = figure('Units','Inches','Position', ...
			[options.figX options.figY options.figWidth F.figHeight(1)]);
	F.fig.InvertHardcopy = 'off';
	F.fig.Color = 'white';

	F = F.Render(x, y, Ex, Ey, Ez, rowLabel, 0);
end

function F = Render(F, x, y, Ex, Ey, Ez, rowLabel, paramVal, oap, oaphi)
	% scale label text with figure size
	set(0,'DefaultAxesFontSize',16);
	fontsize(scale=F.sf);
	clf(F.fig);

	% how many phase plots should we draw?
	if F.drawAll==1
		% draw as many as 3 rows -- or 2, if also drawing a lineout
		rowRange = 1:min(length(x),3-F.drawLineout);
	else
		% if !F.drawAll, just draw 1 row
		rowRange = 1:1;
	end
	% draw phase plots
	for k=rowRange
		F = F.drawRow(k,x{k},y{k},Ex{k},Ey{k},Ez{k},rowLabel{k});
	end
	% draw lineout if requested
	if F.drawLineout==1 % draw lineout row on bottom
		xrange = x{1}(1,:);
		yrange = y{1}(:,1)';
		F = F.lineout(x,y,Ex,Ey,Ez,rowLabel,xrange,yrange);
	end

	% header
	if F.drawHeader==1
		annotation('textbox',[.05 F.figHeight(6) .25 F.figHeight(7)],...
			'String',sprintf(F.paramText,paramVal),...
			'Interpreter','latex','FontSize',20,'EdgeColor','none');
		F = F.colorbar();
	else
		annotation('textbox',[0.048 0.37 0.1 0.1],...
			'String',sprintf(F.paramText,paramVal),...
			'Interpreter','latex','FontSize',20,...
			'EdgeColor','none','Rotation',90);
	end
end

function F = drawRow(F, rowNum, x, y, Ex, Ey, Ez, label)
	rowHeight = F.figHeight(rowNum+1);

	% value ranges
	xrange = x(1,:);
	yrange = y(:,1)';
	% min/max values
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);

	% if plotting the B field, we want to normalize relative to B_y
	if F.isB && rowNum==2
		E0complex = max(Ey,[],"all");
		phsglobal = conj(E0complex)/abs(E0complex);
		Ex0 = max(abs(Ex),[],"all");
		Ey0 = abs(E0complex);
		Ez0 = max(abs(Ez),[],"all");
		xdigits = ceil(-log10(Ex0/Ey0));
		zdigits = ceil(-log10(Ez0/Ey0));
	else
		E0complex = max(Ex,[],"all");
		phsglobal = conj(E0complex)/abs(E0complex);
		% TODO: relative phase
		Ex0 = abs(E0complex);
		Ey0 = max(abs(Ey),[],"all");
		Ez0 = max(abs(Ez),[],"all");
		ydigits = ceil(-log10(Ey0/Ex0));
		zdigits = ceil(-log10(Ez0/Ex0));
	end

	% min/max values
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);

	% left axes: x-cross section
	F.ax{rowNum}=axes('position',[.08 rowHeight .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Ex/Ex0*phsglobal,5));
	set(F.ax{rowNum},'YDir','normal'); % image() reverses y-axis coordinates
	axis square;
	axis off;
	hold on
	% formatted title
	if F.isB && rowNum==2
		title(['$c B_x / (' num2str(round(Ex0*10^xdigits)/10^xdigits) ' B_0)$'], ...
			'Interpreter','latex')
	else
		title(['$E_x / E_0$'], 'Interpreter','latex')
	end
	% lineout section line
	if F.drawLineout==1
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	end
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.ax{rowNum}.XTick = [xmin 0 xmax] * 0.8;
	F.ax{rowNum}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ax{rowNum}.YTick = [ymin 0 ymax] * 0.8;
	F.ax{rowNum}.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	% TODO: not working?
	hold off

	% middle axes: y-cross section
	F.ay{rowNum}=axes('position',[.38 rowHeight .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Ey/Ey0*phsglobal,5));
	set(F.ay{rowNum},'YDir','normal');
	axis square;
	axis off;
	hold on
	% formatted title
	if F.isB && rowNum==2
		title(['$c B_y / B_0$'], 'Interpreter','latex')
	else
		title(['$E_y / (' num2str(round(Ey0*10^ydigits)/10^ydigits) ' E_0)$'], ...
			'Interpreter','latex')
	end
	% cross-section line (diagonal on this one)
	if F.drawLineout==1
		plot3([-sqrt(xmin^2/2),sqrt(xmax^2/2)],[-sqrt(xmin^2/2),sqrt(xmax^2/2)],[2,2], ...
			'w--','LineWidth',1);
	end
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.ay{rowNum}.XTick = [xmin 0 xmax] * 0.8;
	F.ay{rowNum}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ay{rowNum}.YTick = [ymin 0 ymax] * 0.8;
	F.ay{rowNum}.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	% TODO: not working?
	hold off

	% right axes: z-cross section
	F.az{rowNum}=axes('position',[.68 rowHeight .25 F.figHeight(5)]);
	% render complex phase
	image([xmin xmax],[ymin ymax],PhaseColor(Ez/Ez0*phsglobal,5));
	set(F.az{rowNum},'YDir','normal');
	axis square;
	axis off;
	hold on
	% formatted title
	if F.isB && rowNum==2
		title(['$c B_z / (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' B_0)$'], ...
			'Interpreter','latex')
	else
		title(['$E_z / (' num2str(round(Ez0*10^zdigits)/10^zdigits) ' E_0)$'], ...
			'Interpreter','latex')
	end
	% cross-section line
	if F.drawLineout==1
		plot3([xmin,xmax],[0,0],[2,2],'w--','LineWidth',1);
	end
	% label axes
	xlabel('$r / f$','Interpreter','latex');
	F.az{rowNum}.XTick = [xmin 0 xmax] * 0.8;
	F.az{rowNum}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.az{rowNum}.YTick = [ymin 0 ymax] * 0.8;
	F.az{rowNum}.YTickLabel = {sprintf('%3.1f',ymin*0.8) '0' sprintf('%3.1f',ymax*0.8)};
	% TODO: not working?
	hold off

	% side label
	annotation('textbox',[.08 rowHeight F.figHeight(5) 0.06],...
		'String',label,'Interpreter','latex','FontSize',20,...
		'EdgeColor','none','FitBoxToText',false,'Rotation',90,...
		'HorizontalAlignment','center','VerticalAlignment','middle');
end

function F = lineout(F,x,y,Ex,Ey,Ez,label,xrange,yrange)
	% interpolate string of points from each matrix to get cross sections
	xmin = min(xrange); xmax = max(xrange);
	ymin = min(yrange); ymax = max(yrange);
	for k=1:min(length(x),3)
		Exf{k} = interp2(x{k},y{k},Ex{k},xrange,0*yrange);
		Eyf{k} = interp2(x{k},y{k},Ey{k},sqrt(0.5)*xrange,sqrt(0.5)*yrange);
		Ezf{k} = interp2(x{k},y{k},Ez{k},xrange,0*yrange);
		% normalize each row relative to the x component
		Ex0 = max(abs(Ex{k}),[],"all");
		Exf{k} = abs(Exf{k})/Ex0;
		Eyf{k} = abs(Eyf{k})/Ex0;
		Ezf{k} = abs(Ezf{k})/Ex0;
	end
	% colors + styles
	clrs = {[200,0,0]/255,[49,54,143]/255,[49,54,143]/255};
	stls = {'-','-','--'};

	% left axes: x-cross section
	F.ax{end+1}=axes('position',[.08 F.figHeight(4) .25 F.figHeight(5)]);
	hold on
	for k=1:min(length(x),3)
		plot(xrange,Exf{k},stls{k},'Color',clrs{k},'LineWidth',1.5,'DisplayName',label{k});
	end
	hold off
	set(F.ax{end},'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	xlim([xmin xmax]);
	ylim(1.05*ylim);
	F.ax{end}.XTick = [xmin 0 xmax] * 0.8;
	F.ax{end}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ax{end}.YTick = [0 1];
	axis square;
	% formatted title
	%xdigits = ceil(-log10(Ex0));
	title('$\left| E_x \right| / E_0$', 'Interpreter','latex');
	% include a legend box in the upper-right corner of the figure
	if F.drawLegend==1
		la=legend('Location','southwest');
		set(la, 'Position',[0.79 F.figHeight(6) .1 .05]);
	end

	% middle axes: y-cross section
	F.ay{end+1}=axes('position',[.38 F.figHeight(4) .25 F.figHeight(5)]);
	hold on
	for k=1:min(length(x),3)
		plot(xrange,Eyf{k},stls{k},'Color',clrs{k},'LineWidth',1.5);
	end
	hold off
	set(F.ay{end},'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	xlim([xmin xmax]);
	ylim(1.05*ylim);
	F.ay{end}.XTick = [xmin 0 xmax] * 0.8;
	F.ay{end}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.ay{end}.YTick = [0 0.01 0.1];
	axis square;
	% formatted title
	%ydigits = ceil(-log10(Ey0/Ex0)); TODO: scaling
	title(['$\left| E_y \right| / ' ...
		...num2str(round(Ey0/Ex0*10^ydigits)/10^ydigits) ...
		' E_0$'], 'Interpreter','latex')

	% right axes: z-cross section
	F.az{end+1}=axes('position',[.68 F.figHeight(4) .25 F.figHeight(5)]);
	hold on
	for k=1:min(length(x),3)
		plot(xrange,Ezf{k},stls{k},'Color',clrs{k},'LineWidth',1.5);
	end
	hold off
	set(F.az{end},'YDir','normal');
	% label axes
	xlabel('$r / \lambda$','Interpreter','latex');
	xlim([xmin xmax]);
	yAutoBounds = ylim;
	ylim(1.05*yAutoBounds);
	F.az{end}.XTick = [xmin 0 xmax] * 0.8;
	F.az{end}.XTickLabel = {sprintf('%3.1f',xmin*0.8) '0' sprintf('%3.1f',xmax*0.8)};
	F.az{end}.YTick = [0 0.15];
	axis square;
	% formatted title
	%zdigits = ceil(-log10(Ez0/Ex0)); TODO: scaling
	title(['$\left| E_z \right| / ' ...
		...num2str(round(Ez0/Ex0*10^zdigits)/10^zdigits) ...
		' E_0$'], 'Interpreter','latex')
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
	set(xlabh,'Position',get(xlabh,'Position') - [0 .3 0]);
end

end % methods
end % classdef

function mirrorDecorations()
	global f fnum oap oaphi;
	wbeam = f/2/fnum*sec(oap/2)^2;
	x0 = 2*f*tand(oap/2)*cosd(oaphi);
	y0 = 2*f*tand(oap/2)*sind(oaphi);
	circleq = 0:0.01:6.28;
	circlex = wbeam*cos(circleq) + x0;
	circley = wbeam*sin(circleq) + y0;
	plot(circlex,circley,'w','LineWidth',2);
	% TODO: mirror bullseye
end
