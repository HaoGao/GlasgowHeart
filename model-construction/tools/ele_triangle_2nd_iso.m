function eleShape = ele_triangle_2nd_iso(r, s, xcoor, ycoor)

%%%element funciton for triangle mesh, page 329 (An introduction to the finite element method)
%%%also reference to Libmesh Source code: fe_l2_lagrange_shape_2D.C
t = 1-r-s;

% phi = shape;
phi(1) = 2*t*t - t;
phi(2) = 2*r*r - r;
phi(3) = 2*s*s - s;
phi(4) = 4*t*r;
phi(5) = 4*r*s;
phi(6) = 4*s*t;



x = xcoor;
y = ycoor;
% 
% dshape_dksideta = [4.0*r-1 ,  0; ...
%                  0       ,  4.0*s-1; ...
% 				-4.0*t+1 , -4.0*t+1; ...
%                 4.0*s    ,  4.0*t; ...
%                 -4.0*s   ,  4.0*t-4.0*s; ...
%               4.0*t-4.0*r, -4.0*r];
          
dphi_dksideta(1,:) = [-4*t+1 -4*t+1]; 
dphi_dksideta(2,:) = [4*r-1 0]; 
dphi_dksideta(3,:) = [0 4*s-1]; 
dphi_dksideta(4,:) = [4*(t-r) -4*r]; 
dphi_dksideta(5,:) = [4*s 4*r]; 
dphi_dksideta(6,:) = [-4*s 4*(t-s)]; 

dphi_dksideta_2nd(1,:) = [4 4];
dphi_dksideta_2nd(2,:) = [4 0];
dphi_dksideta_2nd(3,:) = [0 4];
dphi_dksideta_2nd(4,:) = [-8 0];
dphi_dksideta_2nd(5,:) = [0 0];
dphi_dksideta_2nd(6,:) = [0 -8];

% dphi_dksideta = dshape_dksideta;

JT = [x;y]*dphi_dksideta;
% dphi_dksi = [-1 1 0];
% dphi_deta = [-1 0 1];
% 
% dx_dksi = sum(x.*dphi_dksi);
% dx_deta = sum(x.*dphi_deta);
% dy_dksi = sum(y.*dphi_dksi);
% dy_deta = sum(y.*dphi_deta);
             
% J = dphi_dksideta'*[x; y]';
% JT = [x;y]*dphi_dksideta;



%%%no need to change for the following code in dimension is 2. 

J = JT';

% J = [dx_dksi, dy_dksi; ...
%      dx_deta, dy_deta];
Jinv = inv(J); 				 
Jdet = det(J);

dphi = Jinv*dphi_dksideta';
dphi2nd= Jinv*dphi_dksideta_2nd';
% dphi1dx = dphi(1,1);
% dphi1dy = dphi(2,1);
% dphi2dx = dphi(1,2);
% dphi2dy = dphi(2,2);
% dphi3dx = dphi(1,3);
% dphi3dy = dphi(2,3);  


% eleShape.phi(1) = phi1;
% eleShape.phi(2) = phi2;
% eleShape.phi(3) = phi3;
eleShape.phi = phi;
eleShape.J = J;
eleShape.Jinv = Jinv;
eleShape.Jdet = Jdet;
eleShape.dphi=dphi;
eleShape.dphi2nd = dphi2nd;
eleShape.dphidx = dphi(1,:);
eleShape.dphidy = dphi(2,:);
eleShape.dphidx2nd = dphi2nd(1,:);
eleShape.dphidy2nd = dphi2nd(2,:);
eleShape.qp_x = sum(phi.*x);
eleShape.qp_y = sum(phi.*y);




