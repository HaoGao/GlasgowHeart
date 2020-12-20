function readGuidePoints_preProcessing_GlobalAlpha0(outterGuidePointsFileName, innerGuidePointsFileName,...
                outterGuide4FittingFileName,innerGuide4FittingFileName, ...
                prolateParametersFileName, ...
                resultDir,resultDirRoot,patientName)
            
workingDir = pwd();

middleFileDir = resultDir;
outXYZ = readGuidePoints(middleFileDir, outterGuidePointsFileName);
intXYZ = readGuidePoints(middleFileDir, innerGuidePointsFileName);
[alpha0, w2] = estimateEpiProlate(outXYZ);
outPro = getProlateCoordinate(outXYZ, alpha0);
intPro = getProlateCoordinate(intXYZ, alpha0);
writeGuidePointsForFitting(outXYZ, outPro, resultDir, outterGuide4FittingFileName);
writeGuidePointsForFitting(intXYZ, intPro, resultDir, innerGuide4FittingFileName);

%%%average wEpi
sdw2 = std(outPro(3,:));
w1 = mean(intPro(3,:));
sdw1 = std(intPro(3,:));

cd(resultDir);
fileName = sprintf('%s_%s',prolateParametersFileName, patientName);
fid = fopen(fileName,'w');
cd(workingDir);
fprintf(fid, '%f\t\t alpha0\r\n', alpha0);
fprintf(fid, '%f\t\t w1 for endocardial surface\r\n', w1);
fprintf(fid, '%f\t\t w1 for epicardial surface\r\n', w2);
fprintf(fid, '%f\t\tupper bound of u coordinate (in degree)\r\n',max([max(outPro(1,:)) max(intPro(1,:))])*180/pi );
fprintf(fid, '%f\t\tlower bound of u coordinate (in degree)\r\n',min([min(outPro(1,1:end-1)) min(intPro(1,1:end-1))])*180/pi );
fprintf(fid, '%f\t\t sdw1/w1 for endocardial surface\r\n', sdw1/w1);
fprintf(fid, '%f\t\t sdw2/w2 for epicardial surface\r\n', sdw2/w2);
fclose(fid);


cd(resultDirRoot);
fileName = sprintf('%s_prolatePara',patientName);
ProlatePara.alpha0 = alpha0;
ProlatePara.w1 = w1;
ProlatePara.w2 = w2;
ProlatePara.uMax = max([max(outPro(1,:)) max(intPro(1,:))])*180/pi;
ProlatePara.uMin = min([min(outPro(1,1:end-1)) min(intPro(1,1:end-1))])*180/pi;
ProlatePara.sdw1_w1 = sdw1/w1;
ProlatePara.sdw2_w2 = sdw2/w2;
save(fileName, 'ProlatePara');
cd(workingDir);





