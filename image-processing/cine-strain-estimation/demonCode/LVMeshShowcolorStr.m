function LVMeshShowcolorStr(LVPoints,LVMesh,h)

figure(h);hold on;

for i = 1 : size(LVMesh,1)
    p1 = LVPoints(LVMesh(i,1),:);
    p2 = LVPoints(LVMesh(i,2),:);
    p3 = LVPoints(LVMesh(i,3),:);
    p4 = LVPoints(LVMesh(i,4),:);
    cor = LVMesh(i,5);
    
    
    if cor == 1
        corstr = 'b';
    elseif cor == 2
        corstr = 'k';
    elseif cor == 3
        corstr = 'y';
    elseif cor == 4
        corstr = 'r';
    elseif cor == 5
        corstr = 'g';
    elseif cor == 6
        corstr = 'r';
    end
    
    
    line([p1(1) p2(1)], [p1(2) p2(2)], 'Color', corstr);
    line([p2(1) p3(1)], [p2(2) p3(2)], 'Color', corstr);
    line([p3(1) p4(1)], [p3(2) p4(2)], 'Color', corstr);
    line([p4(1) p1(1)], [p4(2) p1(2)], 'Color', corstr);
    
end