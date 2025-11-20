%% show result w/ diagnostic plots
function F = FieldCrossMovie(x, y, z, Exr, Eyr, Ezr, oaphirange, movieName)
F = FieldCrossRender(x, y, z, Exr(:,:,1),Eyr(:,:,1),Ezr(:,:,1), ...
	"$\\phi = %3.2f^\\circ$");
F.fig.Name = "theta=30,phi=0 [1]";

if nargin<8 % interactive: use arrow keys to switch between frames
	F.fig.UserData = 1;
	F.fig.KeyReleaseFcn = {@slide,oaphirange,F,x,y,z,Exr,Eyr,Ezr};

else % non-interactive: print series to video file
	mkdir("figures/"+movieName)
	for n = 1:length(oaphirange)
		fprintf("n=%d\n",n);
		F.Render(x, y, z, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),oaphirange(n));
		saveas(F.fig,"figures/"+movieName+"/"+num2str(n,"%02d")+".tif");
	end
end

function slide(src,event,oaphirange,F,x,y,z,Exr,Eyr,Ezr)
	n = src.UserData;
	switch event.Key
		case {'leftarrow','uparrow','k'}
			if n>1
				n = n-1;
			else
				return;
			end
		case {'rightarrow','downarrow','j'}
			if n<length(oaphirange)
				n = n+1;
			else
				return;
			end
		otherwise
			return;
	end
	fprintf("n=%d\n",n);
	F.Render(x, y, z, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),oaphirange(n));
	F.fig.Name = "theta=30,phi="+string(oaphirange(n))+" ["+string(n)+"]";
	src.UserData = n;
end
end

