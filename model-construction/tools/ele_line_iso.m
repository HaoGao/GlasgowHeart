function eleShape = ele_line_iso(ksi, xcoor)

phi(1) = 0.5*(1-ksi);
phi(2) = 0.5*(1+ksi);

x = xcoor;
y = ycoor;
z = zcoor;

dphi_dksi = [-1/2 1/2];

dx_dksi = sum(x.*dphi_dksi);
dy_dksi = sum(y.*dphi_dksi);
dz_dksi = sum(z.*dphi_dksi);
             
% J = dphi_dksideta'*[x; y]';
JT = [x;y]*dphi_dksi;



%%%no need to change for the following code in dimension is 2. 

J = JT';

% J = [dx_dksi, dy_dksi; ...
%      dx_deta, dy_deta];
Jinv = inv(J); 				 
Jdet = det(J);

dphi = Jinv*dphi_dksi';
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