function SolidWorksInputForClosedSplineGeneration(fid,p, closed, lined, firstB)
%%points must be in the format as [p1;p2;p3]
if closed && lined
    p = [p, p(:,1)];
end


N = size(p,2);

fprintf(fid, '\n');
fprintf(fid, 'Part.SketchManager.Insert3DSketch True\n');

if ~lined
        if firstB
        fprintf(fid,'Dim skPoint As Object\n');
    end
    for i = 1 : N
        fprintf(fid, 'Set skPoint = Part.SketchManager.CreatePoint(%f, %f, %f)\n', p(1,i)*0.001,p(2,i)*0.001,p(3,i)*0.001);
    end
    fprintf(fid, 'Part.ClearSelection2 True\n');
else
    if firstB
        fprintf(fid,'Dim pointArray As Variant\n');
        fprintf(fid, 'Dim points() As Double\n');
    end
    
   fprintf(fid, 'ReDim points(0 To %d) As Double\n', N*3-1);
   
    for i = 1 : N
        ii = (i-1)*3;
        fprintf(fid, 'points(%d) = %f\n',ii,p(1,i)*0.001);
        fprintf(fid, 'points(%d) = %f\n',ii+1, p(2,i)*0.001);
        fprintf(fid, 'points(%d) = %f\n', ii+2, p(3,i)*0.001);
    end
    fprintf(fid, 'pointArray = points\n');
%     fprintf(fid, 'Dim skSegment As Object\n');
    fprintf(fid, 'Set skSegment = Part.SketchManager.CreateSpline((pointArray))\n');
    fprintf(fid, 'Part.ClearSelection2 True\n');
end


fprintf(fid, 'Part.SketchManager.InsertSketch True\n');