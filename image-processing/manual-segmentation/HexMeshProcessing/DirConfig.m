%%result dir
abaqusInputDir = 'C:\Users\sharp\Desktop\work\GlasgowHeart\image-processing\manual-segmentation\Results\DA69ER03\end_diastole\fibreGeneration';

dataResult = '.\Results_fiber_60_45'; 

workingDir = pwd();
cd(abaqusInputDir);
if ~exist(dataResult, 'dir')
    mkdir(dataResult);
end
cd(dataResult);
dataResult = pwd();
cd(workingDir);
