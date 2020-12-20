function theta = degreeCalculationPointBased(p,centerPoint)

dx = p(1)-centerPoint(1);
dy = p(2)-centerPoint(2);

if dx>0 && dy == 0
    theta = 0;
elseif dx> 0 && dy>0
    theta = atan(dy/dx);
elseif dx==0 && dy>0
    theta = pi/2;
elseif dx<0 && dy>0
    theta = pi - atan(abs(dy/dx));
elseif dx<0 && dy ==0
    theta = pi;
elseif dx<0 && dy<0
    theta = pi + atan(abs(dy/dx));
elseif dx==0 && dy<0
    theta = 1.5*pi;
elseif dx> 0 && dy<0
    theta = 2*pi-atan(abs(dy/dx));
else
    theta = 0;
end