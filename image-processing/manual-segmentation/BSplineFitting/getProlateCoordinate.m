function [Pro]=getProlateCoordinate(XYZ, a0)

N = size(XYZ,2);

for i = 1 : N
    x = XYZ(1,i)/a0;
    y = XYZ(2,i)/a0;
    z = XYZ(3,i)/a0;
    
    [u, v, w] =  inverseproCoordinate(x, y, z);
    Pro(1,i) = u;
    Pro(2,i) = v;
    Pro(3,i) = w;
end

