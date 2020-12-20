function minDis = TwoLineSectionDistance(px,py,xa,ya)

if px(1) <= px(2)
    pxii = px(1):0.01:px(2);
else
    pxii = px(1):-0.01:px(2);
end

pyii = interp1(px,py,pxii);

if xa(1) <=  xa(2)
    xaii = xa(1):0.01:xa(2);
else
    xaii = xa(1):-0.01:xa(2);
end
    
yaii = interp1(xa,ya,xaii);

minDis = 110000000;
for i = 1 : length(pxii)
    disx = xaii - pxii(i);
    disy = yaii - pyii(i);
    dis = (disx.^2 + disy.^2).^0.5;
    minDisT = min(dis);
    if minDis > minDisT(1)
        minDis = minDisT(1);
    end
    
end
    
    
    