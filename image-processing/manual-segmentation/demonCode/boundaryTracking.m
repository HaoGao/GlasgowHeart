%%%%boudary tracking
function endoTN = boundaryTracking(endoT, Tx, Ty)


for pIndex = 1 : size(endoT,1)
    x = floor(endoT(pIndex,1));
    y = floor(endoT(pIndex,2));
    
    i = y;
    j = x;
    
    dx = -Ty(i,j);
    dy = -Tx(i,j);
    
    endoTN(pIndex,1) = endoT(pIndex,1)+dx;
    endoTN(pIndex,2) = endoT(pIndex,2)+dy;
    
end