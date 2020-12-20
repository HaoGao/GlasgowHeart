function eleTriPara = ele_triangle_parameter(node1, node2, node3)
%%%page 205

x1 = node1(1);
x2 = node2(1);
x3 = node3(1);

y1 = node1(2);
y2 = node2(2);
y3 = node3(2);

A = ((x2*y3-x3*y2)+(x3*y1-x1*y3) + (x1*y2 - x2*y1))/2;

alpha(1) = x2*y3 - x3*y2;
alpha(2) = x3*y1 - x1*y3;
alpha(3) = x1*y2 - x2*y1;

beta(1) = y2-y3;
beta(2) = y3-y1;
beta(3) = y1-y2;

gamma(1) = x3-x2;
gamma(2) = x1-x3;
gamma(3) = x2-x1;


xA = mean([x1 x2 x3]);
yA = mean([y1 y2 y3]);
I00 = A;
I10 = A*xA;
I01 = A*yA;
I11 = A/12*(x1*y1 + x2*y2 + x3*y3 + 9*xA*yA);
I20 = A/12*(x1*x1 + x2*x2 + x3*x3 + 9*xA*xA);
I02 = A/12*(y1*y1 + y2*y2 + y3*y3 + 9*yA*yA);


eleTriPara.A = A;
eleTriPara.alpha = alpha;
eleTriPara.gamma = gamma;
eleTriPara.beta = beta;
eleTriPara.I00 = I00;
eleTriPara.I10 = I10;
eleTriPara.I01 = I01;
eleTriPara.I11 = I11;
eleTriPara.I20 = I20;
eleTriPara.I02 = I02;



