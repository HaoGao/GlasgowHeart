function FF = calculate_gradient(xcoor, ycoor, zcoor,Ux, Uy, Uz, f, s, n)

elementType = 'Hex8';
gaussianOrder = 2; 

I = [1 0 0; 0 1 0; 0 0  1];

gaussianCoefs = GaussIntegrationPoints(elementType,gaussianOrder);
ksi = gaussianCoefs.ksi ;  
eta = gaussianCoefs.eta ;
zeta = gaussianCoefs.zeta;
weights = gaussianCoefs.weights ;

R = [f(1) f(2) f(3); 
         s(1) s(2) s(3);
         n(1) n(2) n(3)];

for qp = 1 : length(weights)
%     eleShape = ele_quadrilateral(ksi(qp),eta(qp), node1, node2, node3, node4);
    eleShape = ele_hex8_iso(ksi(qp),eta(qp),zeta(qp), xcoor, ycoor, zcoor);
    phi = eleShape.phi;
    dphidx = eleShape.dphidx;
    dphidy = eleShape.dphidy;
    dphidz = eleShape.dphidz;
    Jdet = eleShape.Jdet;
    
    FFT = zeros([3 3]);
    for i = 1 : length(phi)
       FFT(1,1) = FFT(1,1) + Ux(i)*dphidx(i);
       FFT(1,2) = FFT(1,2) + Ux(i)*dphidy(i);
       FFT(1,3) = FFT(1,3) + Ux(i)*dphidz(i);
       
       FFT(2,1) = FFT(2,1) + Uy(i)*dphidx(i);
       FFT(2,2) = FFT(2,2) + Uy(i)*dphidy(i);
       FFT(2,3) = FFT(2,3) + Uy(i)*dphidz(i);
       
       FFT(3,1) = FFT(3,1) + Uz(i)*dphidx(i);
       FFT(3,2) = FFT(3,2) + Uz(i)*dphidy(i);
       FFT(3,3) = FFT(3,3) + Uz(i)*dphidz(i);
    end
    FFT = FFT + I;
    C = FFT'*FFT;
    E = 1/2*(C-I);
    FF(qp,1).F = FFT;
    FF(qp,1).Efsn = R*E*R';
    
end


