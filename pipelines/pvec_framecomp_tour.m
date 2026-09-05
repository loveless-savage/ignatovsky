oaprange   = cat(2,     0:89,   repelem(90,1,90), 90:-1:11,   repelem(10,1,90));
oaphirange = cat(2,  zeros(1,90),    0:89,    repelem(90,1,80),   90:-1:1);

[xi0,yi0] = mirror(N,0,0,3*f);
Env = exp(-((xi0.^2+yi0.^2)/9/f^2).^32); % circular mask with soft edge
[pex,pey,pez] = pvec(xi0,yi0,Env);
xi = zeros([size(xi0) length(oaprange)]);
yi = xi;
pmx = zeros([size(pex) length(oaprange)]);
pmy = pmx;
pmz = pmx;
pox = pmx;
poy = pmx;
poz = pmx;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	oaphi=deg2rad(oaphirange(n));
	wbeam = f/2/fnum*sec(oap/2)^2; % convert from effective focal length to parent focal length
	[xi(:,:,n),yi(:,:,n),Env] = mirror(N,oap,oaphi);
	[pmx(:,:,n),pmy(:,:,n),pmz(:,:,n)] = pvec(xi(:,:,n),yi(:,:,n),Env);
	[pox(:,:,n),poy(:,:,n),poz(:,:,n)] = rot(pmx(:,:,n),pmy(:,:,n),pmz(:,:,n),oap,oaphi);
	n
end
params={'figX',0,'figY',3.9,'drawLineout',false,'mirrorRimfscale',1.5,'figWidth',14,'invisible',true,...
	'paramText',"$\\theta=%d^\\circ,\\,\\phi=%d^\\circ$"};
	%'paramText',"$\\theta=%d^\\circ,\\,\\phi=%d^\\circ$");
FieldCrossMovie(xi,yi,pex,pey,pez,'Full mirror',pmx,pmy,pmz,'Mirror frame',pox,poy,poz,'Beam frame',...
	paramVals=[oaprange;oaphirange],movieName="pvec_framecomp_tour",live=false,renderParams=params)
