%%%project configure file for setting up the directory (patient) and scan series (SA)

%%%setting up the directories
projectResultDir = 'C:\Users\hg67u\Google Drive\paper_writing\LV_material_parameters\bSplineStrainAnalysis\sampleResults\LVModelGeneration';
sampleN = 50; 


%%%patient image data
patientIndex = 1;
patientConfigs(patientIndex,1).name = 'MR-IMR-201-24hours';
patientConfigs(patientIndex,1).TimeEndOfSystole = 15;
patientConfigs(patientIndex,1).TimeEndOfDiastole = 1;
patientConfigs(patientIndex,1).TimeEarlyOfDiastole = 16;

%%SA basal 1
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0014';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'SA-basal-1';
patientConfigs(patientIndex,1).SliceSpec(1,1).spec = 'SAcine';

%%SA basal 2
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0015';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'SA-basal-2';
patientConfigs(patientIndex,1).SliceSpec(2,1).spec = 'SAcine';

%%SA middle 1
patientConfigs(patientIndex,1).dir(3,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(3,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0016';
patientConfigs(patientIndex,1).studyName(3,1).studyName = 'SA-middle-3';
patientConfigs(patientIndex,1).SliceSpec(3,1).spec = 'SAcine';

%%SA middle 2
patientConfigs(patientIndex,1).dir(4,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(4,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0017';
patientConfigs(patientIndex,1).studyName(4,1).studyName = 'SA-middle-4';
patientConfigs(patientIndex,1).SliceSpec(4,1).spec = 'SAcine';

%%SA middle 3
patientConfigs(patientIndex,1).dir(5,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(5,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0018';
patientConfigs(patientIndex,1).studyName(5,1).studyName = 'SA-middle-5';
patientConfigs(patientIndex,1).SliceSpec(5,1).spec = 'SAcine';

%%SA apical 1
patientConfigs(patientIndex,1).dir(6,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(6,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0019';
patientConfigs(patientIndex,1).studyName(6,1).studyName = 'SA-apical-1';
patientConfigs(patientIndex,1).SliceSpec(6,1).spec = 'SAcine';

%%SA apical 2
patientConfigs(patientIndex,1).dir(7,1).studyDir = 'I:\MRIdata\MR-IMR_201_MR-IMR_201\CARDIAC_DAVE_CARDIAC_20120508_081803_984000';
patientConfigs(patientIndex,1).dirMidSA(7,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0020';
patientConfigs(patientIndex,1).studyName(7,1).studyName = 'SA-apical-2';
patientConfigs(patientIndex,1).SliceSpec(7,1).spec = 'SAcine';




