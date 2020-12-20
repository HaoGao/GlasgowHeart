function [outXYZ,  outXYZApex]= readGuidPointsInSlices(middleFileDir, outterGuidePointsFileName)

%%organize the guid points in slices

workingDir = pwd();
cd(middleFileDir);
fid = fopen(outterGuidePointsFileName,'r');
cd(workingDir);

tline = fgetl(fid);
NoOfSlice = sscanf(tline, '%d');

xcoor = [];
ycoor = [];
zcoor = [];
for i = 1 : NoOfSlice 
    outXYZ(i).xcoor = xcoor;
    outXYZ(i).ycoor = ycoor;
    outXYZ(i).zcoor = zcoor;
end

SliceIndex = 1;
% GlobalPointIndex = 0;
while SliceIndex <=NoOfSlice
     
      tline = fgetl(fid);
      NoOfPoints = sscanf(tline, '%d');
      xcoor = zeros(1, NoOfPoints);
      ycoor = zeros(1, NoOfPoints);
      zcoor = zeros(1, NoOfPoints);
      
      for pIndex = 1 : NoOfPoints
          tline = fgetl(fid);
          x=sscanf(tline, '%f\t%f\t%f');
          %GlobalPointIndex = GlobalPointIndex + 1;
          xcoor(pIndex) = x(1);
          ycoor(pIndex) = x(2);
          zcoor(pIndex) = x(3); 
      end
      
      outXYZ(SliceIndex).xcoor = xcoor;
      outXYZ(SliceIndex).ycoor = ycoor;
      outXYZ(SliceIndex).zcoor = zcoor;
      
      SliceIndex = SliceIndex + 1;
end
%%%read one point for apex
tline = fgetl(fid);
% NoOfPoints = sscanf(tline, '%d');
tline = fgetl(fid);
x=sscanf(tline, '%f%f%f');

outXYZApex.apex = x;

fclose(fid);
