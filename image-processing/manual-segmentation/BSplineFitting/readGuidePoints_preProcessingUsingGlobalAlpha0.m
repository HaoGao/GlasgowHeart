function readGuidePoints_preProcessingUsingGlobalAlpha0(outterGuidePointsFileName, innerGuidePointsFileName,...
                outterGuide4FittingFileName,innerGuide4FittingFileName, ...
                prolateParametersFileName, alpha0, resultDir)
            
workingDir = pwd();

middleFileDir = resultDir;
outXYZ = readGuidePoints(middleFileDir, outterGuidePointsFileName);
intXYZ = readGuidePoints(middleFileDir, innerGuidePointsFileName);
w2 = estimateEpiProlateUsingGlobalAlpha0(outXYZ, alpha0);
outPro = getProlateCoordinate(outXYZ, alpha0);
intPro = getProlateCoordinate(intXYZ, alpha0);
writeGuidePointsForFitting(outXYZ, outPro, resultDir, outterGuide4FittingFileName);
writeGuidePointsForFitting(intXYZ, intPro, resultDir, innerGuide4FittingFileName);

%%%average wEpi
sdw2 = std(outPro(3,:));
w1 = mean(intPro(3,:));
sdw1 = std(intPro(3,:));

cd(resultDir);
fid = fopen(prolateParametersFileName,'w');
cd(workingDir);
fprintf(fid, '%f\t\t alpha0\r\n', alpha0);
fprintf(fid, '%f\t\t w1 for endocardial surface\r\n', w1);
fprintf(fid, '%f\t\t w1 for epicardial surface\r\n', w2);
fprintf(fid, '%f\t\tupper bound of u coordinate (in degree)\r\n',max([max(outPro(1,:)) max(intPro(1,:))])*180/pi );
fprintf(fid, '%f\t\tlower bound of u coordinate (in degree)\r\n',min([min(outPro(1,1:end-1)) min(intPro(1,1:end-1))])*180/pi );
fprintf(fid, '%f\t\t sdw1/w1 for endocardial surface\r\n', sdw1/w1);
fprintf(fid, '%f\t\t sdw2/w2 for epicardial surface\r\n', sdw2/w2);
fclose(fid);


