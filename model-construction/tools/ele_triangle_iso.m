function eleShape = ele_triangle_iso(L1, L2, xcoor, ycoor)

%%%element funciton for triangle mesh, page 329 (An introduction to the finite element method)
L3 = 1-L1-L2;

phi1 = 1-L1-L2;
phi2 = L1;
phi3 = L2;
phi = [phi1 phi2 phi3];

x = xcoor;
y = ycoor;

dphi_dksideta = [-1 -1; ...
                1 0; ...
				 0 1];
dphi_dksi = [-1 1 0];
dphi_deta = [-1 0 1];

dx_dksi = sum(x.*dphi_dksi);
dx_deta = sum(x.*dphi_deta);
dy_dksi = sum(y.*dphi_dksi);
dy_deta = sum(y.*dphi_deta);
             
% J = dphi_dksideta'*[x; y]';
JT = [x;y]*dphi_dksideta;



%%%no need to change for the following code in dimension is 2. 

J = JT';

% J = [dx_dksi, dy_dksi; ...
%      dx_deta, dy_deta];
Jinv = inv(J); 				 
Jdet = det(J);

dphi = Jinv*dphi_dksideta';
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
eleShape.dphidx = dphi(1,:);
eleShape.dphidy = dphi(2,:);
eleShape.qp_x = sum(phi.*x);
eleShape.qp_y = sum(phi.*y);




