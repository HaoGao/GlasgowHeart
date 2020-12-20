function writeGuidePointsForFitting(outXYZ, outPro, resultDir, outterGuide4FittingFileName)

workingDir = pwd();
cd(resultDir);
fid = fopen(outterGuide4FittingFileName, 'w');
cd(workingDir);

N = size(outXYZ,2);

fprintf(fid,'%d \t total number of guide points \r\n', N );

for i = 1 : N
    fprintf(fid, '%4d  %16.8f  %16.8f  %16.8f  %16.8f  %16.8f  %16.8f\r\n', i, ...
                                                 outXYZ(1,i), outXYZ(2,i), outXYZ(3,i), ...
                                                 outPro(1,i)*180/pi,  outPro(2,i)*180/pi,  outPro(3,i));
end

fclose(fid);