%%%whole lv manual segmentation configuration
workingDir = pwd();

dicomDir = 'C:\workrelated\MRIData\HAO\DICOM\11081816\25450000';
resultDir = 'C:\Users\hg67u\Google Drive\paper_writing\LV_material_parameters\bSplineStrainAnalysis\sampleResults\YuJue'; 


totalSXSliceLocation = 8; %starting from basal plane
usuableSXSlice = 7;
apexSliceIndex = 8; %%%this is the apical point
SASlicePositionApex = 6; %%%the starting slice position of apical region, which means slice 6 and 7 will considered to be at apical region
totalLVOTSliceLocation = usuableSXSlice;
totalTimeInstance = 25;


timeInstanceSelected = 11;
timeInstanceSelectedSystole = 10;
timeInstanceSelectedDiastile = 1;
sampleN = 100;
SASliceDistance = 10; %%in mm, here is assumption that for one scan, the SA distance will be constant.

