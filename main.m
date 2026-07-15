global k wbeam z0 w0 fnum f;
lambda = 1; % wavelength = 0.8e-6 m
k = 2*pi/lambda; % wave number
wbeam = 50; % width of incident beam
fnum = 2; % asymptotic cone angle of beam -- < 3 is a pretty wide focus

oap = deg2rad(0); % OAP angle
oaphi = deg2rad(0); % azimuthal angle of OAP cut relative to polarization
zoffset = 0;% displacement from focal plane
t = 0; % time since peak of pulse hits

% derived beam parameters
f = 2*wbeam*fnum; % focal length of parabolic mirror: should be further than z0
w0 = lambda*f/wbeam/pi; % beam waist = 3.2e-6 m
z0 = pi/lambda*w0^2; % rayleigh range = 40.2e-6 m
% convert from effective focal length to parent focal length
f = f*cos(oap/2)^2;

%% set up grids for observation + mirror planes
N = 65;
[x,y,z,xo,yo,zo] = camera(N,zoffset,-oap,oaphi);

%% call relevant pipeline
addpath pipelines
pvec_framecomp_noenv
