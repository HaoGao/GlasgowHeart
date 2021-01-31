%%%project configure file for setting up the directory (patient) and scan series (SA)

%%%setting up the directories
projectResultDir = 'C:\Users\hg67u\Google Drive\paper_writing\LV_material_parameters\bSplineStrainAnalysis\sampleResults\20PilotResult\SecondRun';
sampleN = 50; 


%%%patient image data
%%%HV12
patientIndex = 1;
patientConfigs(patientIndex,1).name = 'HV12';
%1.5T, SP A102.5
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV12_HV12\CARDIAC_JOHN_PAYNE_20120329_163119_328000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
patientConfigs(patientIndex,1).slicePosition(1,1).position = 'SA_Mid';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV12_HV12\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120328_113400_406000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';
patientConfigs(patientIndex,1).slicePosition(2,1).position = 'SA_Apex';


%%%HV13
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV13';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV13_HV13\CARDIAC_CONGENITAL_20120405_134411_843000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETR_SA_0021';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV13_HV13\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120404_124500_671000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0024';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


