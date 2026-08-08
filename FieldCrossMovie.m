%% show result w/ diagnostic plots
function F = FieldCrossMovie(x, y, Exr, Eyr, Ezr, rowLabel, options)
arguments
	x double % observation coordinates (grids)
	y double
end
arguments (Repeating)
	Exr double % field components
	Eyr double
	Ezr double
	rowLabel string % name of field
end
	arguments
	% name-value arguments
	options.paramVals double % independent variable varying between frames
	options.renderParams cell = {'drawLegend',false };
	options.live logical = false % use arrow keys to interact?
	options.windowName string
	options.movieName string
end

% extract one layer from a 3D array
function eout = varlengthslice(e,n)
	if isnumeric(e) && size(e,3)>1
		eout = e(:,:,n);
	else
		eout = e;
	end
end
% extract one layer from each 3D array in a repeating-argument list
Eslice = @(E,n) cellfun(@(e) varlengthslice(e,n), E,'UniformOutput',false);
% extract one layer from a list of repeating-argument lists
Elistslice = @(E,n) cellfun(@(e) Eslice(e,n), E,'UniformOutput',false);

% extract first entry from each repeating argument list
inParams = vertcat(Exr,Eyr,Ezr,rowLabel);
repeatingParams = Eslice(inParams,1);
% initialize FieldCrossRender with first entries
F = FieldCrossRender(varlengthslice(x,1),varlengthslice(y,1),...
	repeatingParams{:}, options.renderParams{:});

if isfield(options,'windowName')
	F.fig.Name = sprintf(options.windowName+" [%d]",paramVals(n),1);
end
if isfield(options,'paramVals')
	paramVals = options.paramVals;
else
	paramVals = zeros(length(x{1}));
end

% interactive: use arrow keys to switch between frames
if isfield(options,'live') && options.live
	F.fig.UserData = 1;
	F.fig.KeyReleaseFcn = {@slide,paramVals,F,x,y,Exr,Eyr,Ezr,rowLabel};
% non-interactive: print series to video file
else
	mkdir("figures/"+options.movieName)
	for n = 1:length(paramVals)
		fprintf("n=%d\n",n);
		repeatingParams = Elistslice({Exr,Eyr,Ezr,rowLabel},n);
		F.Render(varlengthslice(x,n),varlengthslice(y,n),...
			repeatingParams{:},paramVals(:,n));
		saveas(F.fig,"figures/"+options.movieName+"/"+num2str(n,"%03d")+".tif");
	end
end

function slide(src,event,paramVals,F,x,y,Exr,Eyr,Ezr,rowLabel)
	n = src.UserData;
	switch event.Key
		case {'leftarrow','uparrow','k'}
			if n>1
				n = n-1;
			else
				return;
			end
		case {'rightarrow','downarrow','j'}
			if n<length(paramVals)
				n = n+1;
			else
				return;
			end
		otherwise
			return;
	end
	fprintf("n=%d\n",n);
	repeatingParams = Elistslice({Exr,Eyr,Ezr,rowLabel},n);
	F.Render(varlengthslice(x,n),varlengthslice(y,n),...
		repeatingParams{:},paramVals(:,n));
	F.fig.Name = "theta="+string(paramVals(n))+" ["+string(n)+"]";
	src.UserData = n;
end
end

