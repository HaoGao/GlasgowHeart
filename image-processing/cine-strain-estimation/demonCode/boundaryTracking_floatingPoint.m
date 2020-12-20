%%%%boudary tracking with linear interpolation
function endoTN = boundaryTracking_floatingPoint(endoT, Tx, Ty)


for pIndex = 1 : size(endoT,1)
    x = floor(endoT(pIndex,1));
    y = floor(endoT(pIndex,2));
    
   
    i = y;
    j = x;
    
    i1 = i+1;
    j1 = j+1;
    
    
    
%     dx = -Ty(i,j);
%     dy = -Tx(i,j);
    
    [X,Y] = meshgrid(0:1:1);
    Zx = [-Ty(i,j) -Ty(i+1,j);
          -Ty(i,j+1) -Ty(i+1,j+1)];
    dx = interp2(X,Y,Zx,y-i,x-j);
    
    
%     [X,Y] = meshgrid(0:1:1);
    Zy = [-Tx(i,j) -Tx(i+1,j);
          -Tx(i,j+1) -Tx(i+1,j+1)];
    dy = interp2(X,Y,Zy,y-i,x-j);
    
    endoTN(pIndex,1) = endoT(pIndex,1)+dx;
    endoTN(pIndex,2) = endoT(pIndex,2)+dy;
    
end