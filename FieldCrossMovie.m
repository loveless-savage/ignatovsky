%% show result w/ diagnostic plots
function F = FieldCrossMovie(x, y, z, Exr, Eyr, Ezr, paramVals, options) %movieName)
arguments
	x double % observation coordinates (grids)
	y double
	z double
	Exr double % field components
	Eyr double
	Ezr double
	paramVals double % independent variable varying between frames
	% name-value arguments
	options.renderParams cell = {'legend',false};
	options.live logical = false % use arrow keys to interact?
	options.windowName string
	options.movieName string % TODO: default?
end

F = FieldCrossRender(x, y, Exr(:,:,1),Eyr(:,:,1),Ezr(:,:,1), options.renderParams{:});
if isfield(options,'windowName')
	F.fig.Name = sprintf(options.windowName+" [%d]",paramVals(n),1);
end

% interactive: use arrow keys to switch between frames
if isfield(options,'live') && options.live
	F.fig.UserData = 1;
	F.fig.KeyReleaseFcn = {@slide,paramVals,F,x,y,z,Exr,Eyr,Ezr};
% non-interactive: print series to video file
else
	mkdir("figures/"+options.movieName)
	for n = 1:length(paramVals)
		fprintf("n=%d\n",n);
		F.Render(x, y, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),paramVals(n));
		saveas(F.fig,"figures/"+options.movieName+"/"+num2str(n,"%02d")+".tif");
	end
end

function slide(src,event,paramVals,F,x,y,z,Exr,Eyr,Ezr)
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
	F.Render(x, y, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),paramVals(n));
	F.fig.Name = "theta=30,phi="+string(paramVals(n))+" ["+string(n)+"]"; % TODO
	src.UserData = n;
end
end

