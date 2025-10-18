%% show result w/ diagnostic plots
function F = FieldCrossMovie(x, y, z, Exr, Eyr, Ezr, oaprange, movieName)
F = FieldCrossRender(x, y, z, Exr(:,:,1),Eyr(:,:,1),Ezr(:,:,1), ...
	7.5,4.0, "$\\theta = %3.2f^\\circ$");%9.0,8.0);
F.fig.Name = "theta=15,plane=0 [1]";

if nargin<8 % interactive: use arrow keys to switch between frames
	F.fig.UserData = 1;
	F.fig.KeyReleaseFcn = {@slide,oaprange,F,x,y,z,Exr,Eyr,Ezr};

else % non-interactive: print series to video file
	mkdir("figures/"+movieName)
	for n = 1:length(oaprange)
		fprintf("n=%d\n",n);
		F.Render(x, y, z, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),oaprange(n));
		saveas(F.fig,"figures/"+movieName+"/"+num2str(n,"%02d")+".tif");
	end
end

function slide(src,event,oaprange,F,x,y,z,Exr,Eyr,Ezr)
	n = src.UserData;
	switch event.Key
		case {'leftarrow','uparrow','k'}
			if n>1
				n = n-1;
			else
				return;
			end
		case {'rightarrow','downarrow','j'}
			if n<length(oaprange)
				n = n+1;
			else
				return;
			end
		otherwise
			return;
	end
	fprintf("n=%d\n",n);
	F.Render(x, y, z, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),oaprange(n));
	F.fig.Name = "theta=15,plane="+string(oaprange(n))+" ["+string(n)+"]";
	src.UserData = n;
end
end

