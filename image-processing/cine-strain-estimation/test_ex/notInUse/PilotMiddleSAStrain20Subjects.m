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


%%%HV14
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV14';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV14_HV14\CARDIAC_DAVE_CARDIAC_20120412_120914_796000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0026';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV14_HV14\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120411_112547_109000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV15
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV15';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV15_HV15\CARDIAC_DAVE_CARDIAC_20120419_124812_703000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0022';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV15_HV15\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120418_112733_406000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0022';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';

%%%HV17
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV17';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV17_HV17\CARDIAC_DAVE_CARDIAC_20120504_080706_343000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0020';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV17_HV17\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120502_111109_328000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPA_SA_0024';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV24
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV24';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV-24_HV-24\CARDIAC_DAVE_CARDIAC_20120628_121458_812000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
%patientConfigs(patientIndex,1).dir(2,1).studyDir = '';
%patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = '';
%patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA'


%%%HV25
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV25';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV-25_HV-25\CARDIAC_DAVE_CARDIAC_20120705_124708_250000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0022';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV25_HV25\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20120704_112537_234000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0020';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV45
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV45';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV-45_HV-45\CARDIAC_CONGENITAL_20121129_120543_156000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0023';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV45_HV45\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20121128_115111_234000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';

%%%HV46
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV46';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV46_HV46\CARDIAC_DAVE_CARDIAC_20121206_123729_156000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0022';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV46_HV46\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20121205_115435_546000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0015';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV48
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV48';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV48_HV48\CARDIAC_NIKO_20121220_121915_953000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV48_HV48\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20121219_114042_703000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV49
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV49';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV49_HV49\CARDIAC_DAVE_CARDIAC_20130110_122427_500000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV49_HV49\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130109_114004_968000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';

%%%HV50
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV50';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV50_HV50\CARDIAC_DAVE_CARDIAC_20130221_082951_171000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0097';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
%patientConfigs(patientIndex,1).dir(2,1).studyDir = '';
%patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = '';
%patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA'

%%%HV51
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV51';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV51_HV51\CARDIAC_DAVE_CARDIAC_20130125_161200_750000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0019';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV51_HV51\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130123_115826_140000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0015';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV70
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV70';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV70_HV70\CARDIAC_CONGENITAL_20130718_085445_703000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0023';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV70_HV70\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130717_110214_984000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0016';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';

%%%HV71
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV71';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV71_HV71\CARDIAC_DAVE_CARDIAC_20130725_170421_625000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0019';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV71_HV71\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130724_113137_843000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0017';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';


%%%HV73
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV73';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV73_HV73\CARDIAC_DAVE_CARDIAC_20130814_170656_890000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0021';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV73_HV73\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130814_113934_750000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0020';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';

%%%HV74
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV74';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV-74_HV-74\CARDIAC_DAVE_CARDIAC_20130822_164100_343000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
%patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV73_HV73\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130814_113934_750000';
%patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0020';
%patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA'


%%%HV75
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV75';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV75_HV75\CARDIAC_CARDIAC_20130829_171300_828000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0026';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV75_HV75\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130828_112817_156000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0019';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';



%%%HV76
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV76';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV76_HV76\CARDIAC_DAVE_CARDIAC_20130905_170411_078000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV76_HV76\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20130904_115827_250000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0018';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';



%%%HV82
patientIndex = patientIndex + 1;
patientConfigs(patientIndex,1).name = 'HV82';
%1.5T SPL36.8
patientConfigs(patientIndex,1).dir(1,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV-82_HV-82\CARDIAC_RESEARCH_20131024_170711_781000';
patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0024';
patientConfigs(patientIndex,1).studyName(1,1).studyName = 'GJH1.5T_MidSA';
%3.0T
patientConfigs(patientIndex,1).dir(2,1).studyDir = 'I:\MRIdata\MI-BHF-Grant\Hao Gao\HV82_HV82\GCRC_PROJECTS_HEALTHY_VOLUNTEER_20131023_115246_171000';
patientConfigs(patientIndex,1).dirMidSA(2,1).ImgDir = 'TF2D12_RETRO_IPAT_SA_0016';
patientConfigs(patientIndex,1).studyName(2,1).studyName = 'GCRC3.0T_MidSA';







