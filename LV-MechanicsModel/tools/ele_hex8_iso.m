function eleShape = ele_hex8_iso(ksi,eta,zeta, xcoor, ycoor, zcoor)

%%%element funciton for quadrilateral mesh, page 318 (An introduction to the finite element method)
% node1 = [0 0]; 
% node2 = [5 -1];
% node3 = [4 5];
% node4 = [1 4];
phi(1) = 1/8*(1-ksi)*(1-eta)*(1-zeta);
phi(2) = 1/8*(1+ksi)*(1-eta)*(1-zeta);
phi(3) = 1/8*(1+ksi)*(1+eta)*(1-zeta);
phi(4) = 1/8*(1-ksi)*(1+eta)*(1-zeta);
phi(5) = 1/8*(1-ksi)*(1-eta)*(1+zeta);
phi(6) = 1/8*(1+ksi)*(1-eta)*(1+zeta);
phi(7) = 1/8*(1+ksi)*(1+eta)*(1+zeta);
phi(8) = 1/8*(1-ksi)*(1+eta)*(1+zeta);

x = xcoor;
y = ycoor;
z = zcoor;

dphi1_dksi = -1/8*(1-eta)*(1-zeta);
dphi1_deta = -1/8*(1-ksi)*(1-zeta);
dphi1_dzeta= -1/8*(1-ksi)*(1-eta);

dphi2_dksi = 1/8*(1)*(1-eta)*(1-zeta);
dphi2_deta = 1/8*(1+ksi)*(-1)*(1-zeta);
dphi2_dzeta= 1/8*(1+ksi)*(1-eta)*(-1);

dphi3_dksi = 1/8*(1)*(1+eta)*(1-zeta);
dphi3_deta = 1/8*(1+ksi)*(1)*(1-zeta);
dphi3_dzeta= 1/8*(1+ksi)*(1+eta)*(-1);

dphi4_dksi = 1/8*(-1)*(1+eta)*(1-zeta);
dphi4_deta = 1/8*(1-ksi)*(1)*(1-zeta);
dphi4_dzeta= 1/8*(1-ksi)*(1+eta)*(-1);

dphi5_dksi = 1/8*(-1)*(1-eta)*(1+zeta);
dphi5_deta = 1/8*(1-ksi)*(-1)*(1+zeta);
dphi5_dzeta= 1/8*(1-ksi)*(1-eta)*(1);

dphi6_dksi = 1/8*(1)*(1-eta)*(1+zeta);
dphi6_deta = 1/8*(1+ksi)*(-1)*(1+zeta);
dphi6_dzeta= 1/8*(1+ksi)*(1-eta)*(1);

dphi7_dksi = 1/8*(1)*(1+eta)*(1+zeta);
dphi7_deta = 1/8*(1+ksi)*(1)*(1+zeta);
dphi7_dzeta= 1/8*(1+ksi)*(1+eta)*(1);

dphi8_dksi = 1/8*(-1)*(1+eta)*(1+zeta);
dphi8_deta = 1/8*(1-ksi)*(1)*(1+zeta);
dphi8_dzeta= 1/8*(1-ksi)*(1+eta)*(1);

dphi_dksideta = [dphi1_dksi dphi1_deta dphi1_dzeta; ...
                 dphi2_dksi dphi2_deta dphi2_dzeta; ...
				 dphi3_dksi dphi3_deta dphi3_dzeta; ...
                 dphi4_dksi dphi4_deta dphi4_dzeta; ...
                 dphi5_dksi dphi5_deta dphi5_dzeta; ...
                 dphi6_dksi dphi6_deta dphi6_dzeta; ...
                 dphi7_dksi dphi7_deta dphi7_dzeta; ...
                 dphi8_dksi dphi8_deta dphi8_dzeta; ...
                 ];
             
% J = dphi_dksideta'*[x; y]';
JT = [x;y;z]*dphi_dksideta;



%%%no need to change for the following code in dimension either 2D or 3D. 
J = JT';

% J = [dx_dksi, dy_dksi; ...
%      dx_deta, dy_deta];
Jinv = inv(J); 				 
Jdet = det(J);

dphi = Jinv*dphi_dksideta';

eleShape.phi = phi;
eleShape.J = J;
eleShape.Jinv = Jinv;
eleShape.Jdet = Jdet;
eleShape.dphi=dphi;
eleShape.dphidx = dphi(1,:);
eleShape.dphidy = dphi(2,:);
eleShape.dphidz = dphi(3,:);
eleShape.qp_x = sum(phi.*x);
eleShape.qp_y = sum(phi.*y);
eleShape.qp_z = sum(phi.*z);











