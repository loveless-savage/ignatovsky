function [Ex,Ey,Ez] = rot(Exo,Eyo,Ezo,oap,oaphi)
targetSize = size(Exo);

% rotation matrix: rotate by oap around the s-axis, which is the y-axis rotated by oaphi
rotmat = [ cos(oap)+(1-cos(oap))*sin(oaphi)^2, (cos(oap)-1)*cos(oaphi)*sin(oaphi), sin(oap)*cos(oaphi);
		  (cos(oap)-1)*cos(oaphi)*sin(oaphi),  cos(oap)+(1-cos(oap))*cos(oaphi)^2, sin(oap)*sin(oaphi);
				 -sin(oap)*cos(oaphi),                -sin(oap)*sin(oaphi),             cos(oap)       ];

% concatenate into a 3D array
Eblock = cat(3, Exo, Eyo, Ezo); % Shape: NxNx3
% reshape the components for matrix multiplication
Evecs = reshape(Eblock, [], 3); % Shape: (N^2)x3

% Apply the rotation matrix
Erot = (rotmat * Evecs')'; % Shape: (N^2)x3

% Reshape back to NxNx3
Ex = reshape(Erot(:,1), targetSize);
Ey = reshape(Erot(:,2), targetSize);
Ez = reshape(Erot(:,3), targetSize);
