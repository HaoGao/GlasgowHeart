function eleShape = ele_quadrilateral_iso(ksi,eta, xcoor, ycoor)

%%%element funciton for quadrilateral mesh, page 318 (An introduction to the finite element method)
% node1 = [0 0]; 
% node2 = [5 -1];
% node3 = [4 5];
% node4 = [1 4];


phi(1) = 1/4*(1-ksi)*(1-eta);
phi(2) = 1/4*(1+ksi)*(1-eta);
phi(3) = 1/4*(1+ksi)*(1+eta);
phi(4) = 1/4*(1-ksi)*(1+eta);


x = xcoor;
y = ycoor;

dphi_dksideta = [-1/4*(1-eta) -1/4*(1-ksi); ...
                1/4*(1-eta) -1/4*(1+ksi); ...
				 1/4*(1+eta) 1/4*(1+ksi); ...
                 -1/4*(1+eta) 1/4*(1-ksi)];
             
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











