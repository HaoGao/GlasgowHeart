function [xyzGuide, uGuide, vGuide, pGuide, weightGP, Npoints] = readGuidePoints_uvw(resultDir, fileName)

Pi=pi;

workingDir = pwd();
cd(resultDir);
fid = fopen(fileName, 'r');
cd(workingDir);

tline = fgetl(fid);
Npoints = sscanf(tline, '%d');

for i = 1 : Npoints
    tline = fgetl(fid);
    st = sscanf(tline,'%d %f %f %f %f %f %f');
    uGuide(i) = st(5)*Pi/180;
    vGuide(i) = st(6)*Pi/180;
    pGuide(i) = st(7);
    weightGP(i) = st(7);
    xyzGuide(1,i) = st(2);
    xyzGuide(2,i) = st(3);
    xyzGuide(3,i) = st(4);
    xyzGuide(4,i) = st(5);
    xyzGuide(5,i) = st(6);
    xyzGuide(6,i) = st(7);
end
weightGP(Npoints) = 10*weightGP(Npoints);

