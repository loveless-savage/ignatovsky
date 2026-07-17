oaprange   = [ 0  5 10 30 45 60 80 85 90 90 90 90 90 90 90 90 ...
			  90 85 75 50 25 15 10 10 10 10 10 10 10 10 10  7  3];
oaphirange = [ 0  0  0  0  0  0  0  0  0  5 15 30 45 60 75 85 ...
			  90 90 90 90 90 90 90 85 75 60 45 30 15  5  0  0  0];
%oaprange   = [0  5 10 30 45 60 80 85 90 90 90 90 90 90 90 90 90];
%oaphirange = [0  0  0  0  0  0  0  0  0  5 15 30 45 60 75 85 90];
[xi,yi,Env] = mirror(N,0,0,3*f);
[pex,pey,pez] = pvec(xi,yi,Env);
pmx = zeros([size(pex) length(oaprange)]);
pmy = pmx;
pmz = pmx;
pox = pmx;
poy = pmx;
poz = pmx;
for n=1:length(oaprange)
	oap=deg2rad(oaprange(n));
	oaphi=deg2rad(oaphirange(n));
	[xi,yi,Env] = mirror(N,oap,oaphi);
	[pmx(:,:,n),pmy(:,:,n),pmz(:,:,n)] = deal(pex,pey,pez);
	[p0x,p0y,p0z] = pvec(xi,yi,Env);
	[pox(:,:,n),poy(:,:,n),poz(:,:,n)] = rot(p0x,p0y,p0z,oap,oaphi);
end
[xi,yi] = mirror(N,0,0);
params={'figX',0,'figY',3.9,'drawLineout',false,...
	'paramText',"$p_{mirror}\\ (\\theta=%d^\\circ,\\,\\phi=%d^\\circ)$",'paramText2',"$p_{beam}$"};
[xi,yi] = mirror(N,0,0,3*f);
FieldCrossMovie(xi,yi,pmx,pmy,pmz,[oaprange;oaphirange],altE={pox,poy,poz},...
	movieName="pvec_framecomp_noenv",live=false,renderParams=params)
%FieldCrossRender(x,y,pex,pey,pez,figX=0,figY=3.9,paramText="$p_{mirror}$",altE={pox,poy,poz},drawLineout=false)
