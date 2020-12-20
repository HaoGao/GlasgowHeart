function RectPlot(LVPoints,LVMesh,cirStrain,I1Crop,h)

figure(h);
% imshow(I1Crop,[]); hold on;
I1Size = size(I1Crop);

%%%assign the strain as the color map for each point
for i = 1 : size(LVMesh,1)
    pIndex1 = LVMesh(i,1);
    pIndex2 = LVMesh(i,2);
    
    Cdata(pIndex1,1)=cirStrain(i);
    Cdata(pIndex2,1)=cirStrain(i);
end

patch('Faces',LVMesh,'Vertices',LVPoints,...
          'FaceColor','interp', 'FaceVertexCData',Cdata, 'LineStyle', '-');
    
colormap('jet')
% caxis([-0.3 0.1]);
colorbar;
axis ij;
axis equal;
axis([1 I1Size(2) 1 I1Size(1)]);