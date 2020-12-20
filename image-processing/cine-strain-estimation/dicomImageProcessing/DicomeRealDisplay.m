function DicomeRealDisplay(h, imData)


figure(h);hold on;
surf(imData.imReal.X', imData.imReal.Y', imData.imReal.Z', double(imData.imImage), 'EdgeColor', 'none'); hold on;

colormap gray;
xlabel('X');ylabel('Y');zlabel('Z');
axis equal;