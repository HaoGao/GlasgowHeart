function outXYZ = readGuidePoints(middleFileDir, outterGuidePointsFileName)

workingDir = pwd();
cd(middleFileDir);
fid = fopen(outterGuidePointsFileName,'r');
cd(workingDir);

tline = fgetl(fid);
NoOfSlice = sscanf(tline, '%d');


SliceIndex = 1;
GlobalPointIndex = 0;
while SliceIndex <=NoOfSlice
     
      tline = fgetl(fid);
      NoOfPoints = sscanf(tline, '%d');
      for pIndex = 1 : NoOfPoints
          tline = fgetl(fid);
          x=sscanf(tline, '%f\t%f\t%f');
          GlobalPointIndex = GlobalPointIndex + 1;
          outXYZ(1,GlobalPointIndex) = x(1);
          outXYZ(2,GlobalPointIndex) = x(2);
          outXYZ(3,GlobalPointIndex) = x(3); 
      end
       SliceIndex = SliceIndex + 1;
end


%%%read one point for apex
tline = fgetl(fid);
NoOfPoints = sscanf(tline, '%d');
    for pIndex = 1 : NoOfPoints
        tline = fgetl(fid);
        x=sscanf(tline, '%f%f%f');
        GlobalPointIndex = GlobalPointIndex + 1;
        outXYZ(1,GlobalPointIndex) = x(1);
        outXYZ(2,GlobalPointIndex) = x(2);
        outXYZ(3,GlobalPointIndex) = x(3);
    end

fclose(fid);


