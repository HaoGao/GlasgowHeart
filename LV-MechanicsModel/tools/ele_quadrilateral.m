function eleShape = ele_quadrilateral(ksi,eta, node1, node2, node3, node4)

%%%element funciton for quadrilateral mesh, page 318 (An introduction to the finite element method)
% node1 = [0 0]; 
% node2 = [5 -1];
% node3 = [4 5];
% node4 = [1 4];


phi1 = 1/4*(1-ksi)*(1-eta);
phi2 = 1/4*(1+ksi)*(1-eta);
phi3 = 1/4*(1+ksi)*(1+eta);
phi4 = 1/4*(1-ksi)*(1+eta);

x = [node1(1) node2(1) node3(1) node4(1)];
y = [node1(2) node2(2) node3(2) node4(2)];

dxdksi = 1/4*(-x(1)*(1-eta) + x(2)*(1-eta) + x(3)*(1+eta) - x(4)*(1+eta));
dxdeta = 1/4*(-x(1)*(1-ksi) - x(2)*(1+ksi) + x(3)*(1+ksi) + x(4)*(1-ksi));
dydksi = 1/4*(-y(1)*(1-eta) + y(2)*(1-eta) + y(3)*(1+eta) - y(4)*(1+eta));
dydeta = 1/4*(-y(1)*(1-ksi) - y(2)*(1+ksi) + y(3)*(1+ksi) + y(4)*(1-ksi));

J = [dxdksi dydksi; dxdeta dydeta];
Jinv = inv(J);
Jdet = det(J);


%%% get the global derivative
dphi1dksi = -1/4*(1-eta);
dphi1deta = -1/4*(1-ksi);
dphi2dksi = 1/4*(1-eta);
dphi2deta = -1/4*(1+ksi);
dphi3dksi = 1/4*(1+eta);
dphi3deta = 1/4*(1+ksi);
dphi4dksi = -1/4*(1+eta);
dphi4deta = 1/4*(1-ksi);


dphi1dx = Jinv(1,1)*dphi1dksi+Jinv(1,2)*dphi1deta;
dphi1dy = Jinv(2,1)*dphi1dksi+Jinv(2,2)*dphi1deta;

dphi2dx = Jinv(1,1)*dphi2dksi+Jinv(1,2)*dphi2deta;
dphi2dy = Jinv(2,1)*dphi2dksi+Jinv(2,2)*dphi2deta;

dphi3dx = Jinv(1,1)*dphi3dksi+Jinv(1,2)*dphi3deta;
dphi3dy = Jinv(2,1)*dphi3dksi+Jinv(2,2)*dphi3deta;

dphi4dx = Jinv(1,1)*dphi4dksi+Jinv(1,2)*dphi4deta;
dphi4dy = Jinv(2,1)*dphi4dksi+Jinv(2,2)*dphi4deta;

qp_x = sum([phi1 phi2 phi3 phi4].*x);
qp_y = sum([phi1 phi2 phi3 phi4].*y);


eleShape.phi(1) = phi1;
eleShape.phi(2) = phi2;
eleShape.phi(3) = phi3;
eleShape.phi(4) = phi4;
eleShape.J = J;
eleShape.Jinv = Jinv;
eleShape.Jdet = Jdet;
eleShape.dphi=[dphi1dx dphi1dy;dphi2dx dphi2dy;dphi3dx dphi3dy;dphi4dx dphi4dy];
eleShape.dphidx = [dphi1dx dphi2dx dphi3dx dphi4dx];
eleShape.dphidy = [dphi1dy dphi2dy dphi3dy dphi4dy];
eleShape.qp_x = qp_x;
eleShape.qp_y = qp_y;





