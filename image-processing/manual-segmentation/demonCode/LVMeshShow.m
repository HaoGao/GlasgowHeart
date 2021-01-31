function LVMeshShow(LVPoints,LVMesh,h)

figure(h);hold on;

for i = 1 : size(LVMesh,1)
    p1 = LVPoints(LVMesh(i,1),:);
    p2 = LVPoints(LVMesh(i,2),:);
    p3 = LVPoints(LVMesh(i,3),:);
    p4 = LVPoints(LVMesh(i,4),:);
    
    line([p1(1) p2(1)], [p1(2) p2(2)], 'Color', 'r');
    line([p2(1) p3(1)], [p2(2) p3(2)], 'Color', 'r');
    line([p3(1) p4(1)], [p3(2) p4(2)], 'Color', 'r');
    line([p4(1) p1(1)], [p4(2) p1(2)], 'Color', 'r');
    
end

    
    