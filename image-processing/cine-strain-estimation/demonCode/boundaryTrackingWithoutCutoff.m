%%%%boudary tracking
function endoTN = boundaryTrackingWithoutCutoff(endoT, Tx, Ty)


for pIndex = 1 : size(endoT,1)
    x = floor(endoT(pIndex,1));
    y = floor(endoT(pIndex,2));
    
    i = y;  di = endoT(pIndex,2) - y; di = 2*di -1;
    j = x;  dj = endoT(pIndex,1) - x; dj = 2*dj -1 ;
    
    i1 = i+1;
    j1 = j+1;
    
    dxij = -Ty(i,j);
    dyij = -Tx(i,j);
    
    dxi1j = -Ty(i1,j);
    dyi1j = -Tx(i1,j);
    
    dxij1 = -Ty(i,j1);
    dyij1 = -Tx(i,j1);
    
    dxi1j1 = -Ty(i1,j1);
    dyi1j1 = -Tx(i1,j1);
    
    
   %%%using linear interpolation
   fij  =   1/4.0*(1+di)*(1+dj);
   fi1j =   1/4.0*(1-di)*(1+dj);
   fi1j1 =  1/4.0*(1-di)*(1-dj);
   fij1  =  1/4.0*(1+di)*(1-dj);
    
%     dx = -Ty(i,j);
%     dy = -Tx(i,j);

    dx = dxij*fij + dxi1j*fi1j + fi1j1*dxi1j1 + fij1*dxij1;
    dy = dyij*fij + dyi1j*fi1j + fi1j1*dyi1j1 + fij1*dyij1;


    
    endoTN(pIndex,1) = endoT(pIndex,1)+dx;
    endoTN(pIndex,2) = endoT(pIndex,2)+dy;
    
end