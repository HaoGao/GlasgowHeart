function   SXSlice = loadAllDicomSAOrLAFromOneDir(dicomDir)

%%first save patient_config
workingDir = pwd();
% dicomDir = sprintf('%s//%s', patient_config.dir, patient_config.SAMidImgDir);

fileList = scanFilesInDir(dicomDir);
BloadImageData = 1;
SXSlice = cineImageExtract(fileList, dicomDir, BloadImageData); 

