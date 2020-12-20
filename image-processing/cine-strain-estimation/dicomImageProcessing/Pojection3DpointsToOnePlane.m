function pTProject= Pojection3DpointsToOnePlane(pT, pTSA, imInfoSA)
normalV = NormalOfMRISlice(imInfoSA);
% figure(h1);
% plot3(pTSA(1,:), pTSA(2,:), pTSA(3,:),'Color', 'b');
% plot3([pTSA(1,1) pTSA(1,1)+10*normalV(1)], [pTSA(2,1) pTSA(2,1)+10*normalV(2)], [pTSA(3,1) pTSA(3,1)+10*normalV(3)], 'Color', 'r');
%  

%%%project 
xp=normalV(1);yp=normalV(2);zp=normalV(3);
x0=pTSA(1,1);y0=pTSA(2,1);z0=pTSA(3,1);
x1=pT(1,1);y1=pT(2,1);z1=pT(3,1);
x2=pT(1,2);y2=pT(2,2);z2=pT(3,2);
dt = (xp*x0-xp*x1+yp*y0-yp*y1+zp*z0-zp*z1)/(xp^2+yp^2+zp^2);
dt1= (xp*x0-xp*x2+yp*y0-yp*y2+zp*z0-zp*z2)/(xp^2+yp^2+zp^2);
pTProject(1,1)=x1+xp*dt;
pTProject(2,1)=y1+yp*dt;
pTProject(3,1)=z1+zp*dt;
pTProject(1,2)=x2+xp*dt1;
pTProject(2,2)=y2+yp*dt1;
pTProject(3,2)=z2+zp*dt1;