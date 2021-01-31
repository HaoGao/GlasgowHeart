
%resultDir = 'D:\HaoGao\OneDriveBusiness\OneDrive for Business\SoftMech\LVModelling\LVModelGenerationUsingFitting\results_volunteers\MI258_scan1'; 
% resultDir = 'C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\LVModelGenerationUsingFitting_New_withMapping\results_volunteers\MI258_scan1';

dicomDir = 'F:\MRIdata\VALVES_VALVES_kenneth\GCRC_PROJECTS_ALTERED_20151029_135136_609000';
resultDirRoot = 'D:\HaoGao\PhDs\PhD_Alan\Results_Simulation\HV01\reconstruction';
resultDir = 'earlyDiastole';



%for mac computer to redefine
if ismac
   resultDirRoot = './Results';
   resultDir = 'HV01/early_diastole';
end


cd(workingDir);

cd(resultDirRoot);
cd(resultDir);
resultDir = pwd();
cd(workingDir);


if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

cd(resultDir);
if ~exist('fibreGeneration', 'dir')
    mkdir('fibreGeneration');
    cd(workingDir);
end

%%let's figure out whether we need to move basal plane or not
BasalMovingB = 0; %%if exist then it will try to move the first basal plane, otherwise it will not do anything

sampleN = 50;

%%%patient image data
patientIndex = 1;seriesIndex = 1;
patientConfigs(patientIndex,1).name = 'HV01';
patientConfigs(patientIndex,1).TimeEndOfSystole = 10;
patientConfigs(patientIndex,1).TimeEndOfDiastole = 1;
patientConfigs(patientIndex,1).TimeEarlyOfDiastole =12;
patientConfigs(patientIndex,1).sampleN = sampleN;  
patientConfigs(patientIndex,1).SASliceDistance = 10; % mm

patientConfigs(patientIndex,1).SASlicePositionApex = 6; %%%the starting slice position of apical region, which means slice 6 and 7 will considered to be at apical region
patientConfigs(patientIndex,1).totalLVOTSliceLocation = 3;
patientConfigs(patientIndex,1).totalTimeInstance = 25;
patientConfigs(patientIndex,1).timeInstanceSelected = patientConfigs(patientIndex,1).TimeEarlyOfDiastole;

% sampleN = patientConfigs(patientIndex,1).sampleN;

%this is for writing out the guide points when fitiing
sliceToBeSkipped = [];
sliceToBeSkippedLA = [];
basalSlices = [1 2];
middlSlices = [3 4 5];
apicaSlices = 6 ;


%%not sure what to do with this, but leave it now
% scanIndex = 1;
basalMoving = 0;
basalMovingDistance = 0.0;
% if basalMoving == 1
%     cd(resultDir);
%     cd('..'); %%assume the adjustment for different scans is saved in the parent directory
%     load ResultsDirAllScans;
%     basalMovingDistance = ResultsDirAllScans(scanIndex).moveTowardsApex;
% end

%%SA basal 1: %SP A44.3
%%this is for end-diastole, in other time, such as in early-diastole and
%%mid-diastole, this slice does not cover the LV anymore, so needs to take
%%care when integrating other pathological information.
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0017'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-basal-1';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';


%%SA basal 2: %SP A54.3
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0018'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-basal-2';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';


%%SA mid 1: %SP A64
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0019'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-middle-3';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';


%%SA mid 2 :%SP A74
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0020'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-middle-4';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';

%%SA mid 3 :%SP A84
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0021'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-middle-5';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';

%%SA apex 1 :%SP A94
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_SA_0022'; %%%most base at end-diastole
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-apical-6';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';

% %%SA apex 2:  :%SP A104
 %seriesIndex = seriesIndex + 1;
 %patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
 %patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0029'; %%%most base at end-diastole
 %patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-apical-7';
 %patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';

% %%SA apex 3  :%SP L108.8
 %seriesIndex = seriesIndex + 1;
 %patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
 %patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D15_RETRO_IPAT_SA_0026'; %%%most base at end-diastole
 %patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'SA-apical-8';
 %patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'SAcine';

 
%%%LVot 1
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_LVOT_0009';
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'LAcine-LVOT-1';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'LAcine_LVOT';

%%4CH
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_HLA_0008';
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'LAcine-4CH-1';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'LAcine_4CH';

%%1CH
seriesIndex = seriesIndex + 1;
patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'TF2D12_RETRO_IPAT_7MM_VLA_0007';
patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'LAcine-1CH-1';
patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'LAcine_1CH';

% SA distance will be constant. do not assume it, it will directly
% calculated from the dicom header
%%LGE basal 1
% seriesIndex = seriesIndex + 1;
% patientConfigs(patientIndex,1).dir(seriesIndex,1).studyDir = dicomDir;
% patientConfigs(patientIndex,1).dirMidSA(seriesIndex,1).ImgDir = 'MI_together';
% patientConfigs(patientIndex,1).studyName(seriesIndex,1).studyName = 'LGSeries';
% patientConfigs(patientIndex,1).SliceSpec(seriesIndex,1).spec = 'LGE_SA';
% 
% 
% %%the following is for MI intensity window segmentation 
% intensityWindow = [2342-551/2 2342+551/2]; 
% kcluster_centers = 3;
% MIApex = 0;
