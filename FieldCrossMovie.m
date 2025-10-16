%% show result w/ diagnostic plots
F = FieldCrossRender(x, y, z, Exr(:,:,1),Eyr(:,:,1),Ezr(:,:,1), ...
	7.5,4.0, "$\\theta = %3.2f^\\circ$");%9.0,8.0);
F.fig.Name = "theta=15,plane=0";
F.fig.UserData = 1;
F.fig.KeyReleaseFcn = {@slide,n,oaprange,F,x,y,z,Exr,Eyr,Ezr};

function slide(src,event,n,oaprange,F,x,y,z,Exr,Eyr,Ezr)
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
	F.Render(x, y, z, Exr(:,:,n),Eyr(:,:,n),Ezr(:,:,n),rad2deg(oaprange(n)));
	F.fig.Name = "theta=15,plane="+string(rad2deg(oaprange(n)))+" ["+string(n)+"]";
	src.UserData = n;
end
