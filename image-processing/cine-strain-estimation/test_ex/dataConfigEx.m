projectResultDir = 'E:\HaoGao\Temp\GlasgowHeart-main\GlasgowHeart-main\image-processing\cine-strain-estimation\test_ex\results';
sampleN = 50; 


%%%patient image data
patientIndex = 1;
patientConfigs(patientIndex,1).name = 'HV_ex';
%1.5T, SP A102.5
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'E:\HaoGao\Temp\GlasgowHeart-main\GlasgowHeart-main\image-processing\cine-strain-estimation\test_ex\sampleData'; %patient folder
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'cine_SA_002'; % image folder
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
patientConfigs(patientIndex,1).slicePosition(1,1).position = 'SA_Mid';
