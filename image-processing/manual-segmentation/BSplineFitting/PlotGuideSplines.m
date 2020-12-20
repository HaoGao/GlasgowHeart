function PlotGuideSplines(resultDir, fid,outterGuidePointsFileName, innerGuidePointsFileName)

workingDir = pwd();

cd(resultDir);
fid_outer = fopen(outterGuidePointsFileName, 'r');
fid_inner = fopen(innerGuidePointsFileName, 'r');
cd(workingDir);


%%%for outerGuidePointsGeneration
tline = fgetl(fid_outer);
NoOfSlice = sscanf(tline, '%d');


SliceIndex = 1;
GlobalPointIndex = 0;
while SliceIndex <=NoOfSlice
     
      tline = fgetl(fid_outer);
      NoOfPoints = sscanf(tline, '%d');
      XYZ = [];
      for pIndex = 1 : NoOfPoints
          tline = fgetl(fid_outer);
          x=sscanf(tline, '%f\t%f\t%f');
          GlobalPointIndex = GlobalPointIndex + 1;
%           outXYZ(1,GlobalPointIndex) = x(1);
%           outXYZ(2,GlobalPointIndex) = x(2);
%           outXYZ(3,GlobalPointIndex) = x(3); 
          XYZ(1, pIndex) = x(1);
          XYZ(2, pIndex) = x(2);
          XYZ(3, pIndex) = x(3);
      end
      XYZ(1,NoOfPoints+1) = XYZ(1,1);
      XYZ(2,NoOfPoints+1) = XYZ(2,1);
      XYZ(3,NoOfPoints+1) = XYZ(3,1);
      
      %%%output splines
      fprintf(fid, 'ZONE T="Outer Slice-%d", N= %d, E=%d , F=FEPOINT, ET=LINESEG\n', SliceIndex, NoOfPoints+1, NoOfPoints);
      for pIndex = 1 : NoOfPoints+1
          fprintf(fid,'%f    %f     %f     0.0     0.0     0.0\n', XYZ(1,pIndex), XYZ(2, pIndex), XYZ(3, pIndex));
      end
      for pIndex = 1 : NoOfPoints
          fprintf(fid, '%d    %d\n', pIndex, pIndex+1);
      end
          
      SliceIndex = SliceIndex + 1;
end



%%%for innerGuidePointsGeneration
tline = fgetl(fid_inner);
NoOfSlice = sscanf(tline, '%d');


SliceIndex = 1;
GlobalPointIndex = 0;
while SliceIndex <=NoOfSlice
     
      tline = fgetl(fid_inner);
      NoOfPoints = sscanf(tline, '%d');
      XYZ = [];
      for pIndex = 1 : NoOfPoints
          tline = fgetl(fid_inner);
          x=sscanf(tline, '%f\t%f\t%f');
          GlobalPointIndex = GlobalPointIndex + 1;
%           outXYZ(1,GlobalPointIndex) = x(1);
%           outXYZ(2,GlobalPointIndex) = x(2);
%           outXYZ(3,GlobalPointIndex) = x(3); 
          XYZ(1, pIndex) = x(1);
          XYZ(2, pIndex) = x(2);
          XYZ(3, pIndex) = x(3);
      end
      XYZ(1,NoOfPoints+1) = XYZ(1,1);
      XYZ(2,NoOfPoints+1) = XYZ(2,1);
      XYZ(3,NoOfPoints+1) = XYZ(3,1);
      
      %%%output splines
      fprintf(fid, 'ZONE T="Inner Slice-%d", N= %d, E=%d , F=FEPOINT, ET=LINESEG\n', SliceIndex, NoOfPoints+1, NoOfPoints);
      for pIndex = 1 : NoOfPoints+1
          fprintf(fid,'%f    %f     %f     0.0     0.0     0.0\n', XYZ(1,pIndex), XYZ(2, pIndex), XYZ(3, pIndex));
      end
      for pIndex = 1 : NoOfPoints
          fprintf(fid, '%d    %d\n', pIndex, pIndex+1);
      end
          
      SliceIndex = SliceIndex + 1;
end


fclose(fid_inner);
fclose(fid_outer);