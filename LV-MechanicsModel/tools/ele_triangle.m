function eleShape = ele_triangle(L1, L2, xcoor, ycoor)

%%%element funciton for triangle mesh, page 329 (An introduction to the finite element method)
% node1 = [0 0]; 
% node2 = [5 -1];
% node3 = [4 5];
% node4 = [1 4];
L3 = 1-L1-L2;

phi1 = 1-L1-L2;
phi2 = L1;
phi3 = L2;

x = xcoor;
y = ycoor;


gamma3 =   x(2) - x(1);
beta3 =  -(y(2)-y(1));
gamma2 = -(x(3) - x(1));
beta2 = y(3) - y(1);

J = [gamma3 -beta3; ...
    -gamma2  beta2];
Jinv = inv(J);
Jdet = det(J);

dphi1dx = -(beta2 + beta3)/Jdet;
dphi1dy = -(gamma2 + gamma3)/Jdet;
dphi2dx = beta2/Jdet;
dphi2dy = gamma2/Jdet;
dphi3dx = beta3/Jdet;
dphi3dy = gamma3/Jdet;


eleShape.phi(1) = phi1;
eleShape.phi(2) = phi2;
eleShape.phi(3) = phi3;
eleShape.J = J;
eleShape.Jinv = Jinv;
eleShape.Jdet = Jdet;
eleShape.dphi=[dphi1dx dphi1dy;dphi2dx dphi2dy;dphi3dx dphi3dy];
eleShape.dphidx = [dphi1dx dphi2dx dphi3dx];
eleShape.dphidy = [dphi1dy dphi2dy dphi3dy];
eleShape.qp_x = sum([phi1 phi2 phi3].*x);
eleShape.qp_y = sum([phi1 phi2 phi3].*y);




