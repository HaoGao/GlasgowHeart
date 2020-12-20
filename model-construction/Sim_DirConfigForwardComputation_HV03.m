workingDir = pwd();

path(path, './optimizationFunctions');
path(path, './meshRelated');
path(path, './HexMeshProcessing');
path(path, './PCAReconstruction');
path(path, './tools');

disp('running HV03 subject!');

%% pythonfileDir
cd('../LVModelSimulator/pythonFiles');
pythonOriginalFilesDir = pwd();
cd(workingDir);

pythonfilename = 'abaqus_dis.py';
lineNoForODBName = 9;
lineNoForDisName = 32;

pythonfilename_strain = 'abaqus_stress_strain';
lineNoForODBName_strain = 9;
lineNoForStrainName = 72;

outputFileName = 'opt_result_8mmHg.txt';

%% all the simulation and postprocessing files will be saved in this folder
%% pathToFile = which('lvSimulator.m');
%% pathAddress = strrep(pathToFile, 'lvSimulator.m', '');

if ispc 
    abaqusDir = 'not defined yet';
elseif isunix 
    abaqusDir = '/xlwork3/hgao/Alan_Simulator/AbaqusWorkingSpace/HV03';
end
if ~exist(abaqusDir, 'dir')
    mkdir(abaqusDir);
end

copyTemplateFile = false;
cd(abaqusDir);
if exist('abaqus_v6.env', 'file') && exist('heartLVmainG3F60S45P08.inp', 'file') ...
        && exist('myuanisohyper_inv.for', 'file') && exist('parameterOptimization.m', 'file')
    copyTemplateFile = true;
end
cd(workingDir);

if ~copyTemplateFile
%%copy template files into this folder, everytime it will copy those files, only copy when needed 
    cd('../LVModelSimulator/templateFiles');
    copyfile('abaqus_v6.env', fullfile(abaqusDir, 'abaqus_v6.env')); 
    copyfile('heartLVmainG3F60S45P08.inp', fullfile(abaqusDir, 'heartLVmainG3F60S45P08.inp'));
    copyfile('myuanisohyper_inv.for', fullfile(abaqusDir, 'myuanisohyper_inv.for') );
    copyfile('parameterOptimization.m', fullfile(abaqusDir, 'parameterOptimization.m'));
    cd(workingDir);
end




cd(abaqusDir);
parameterOptimization;
cd(workingDir);

%% those are directory with segmentation and reconstruction, but is not
%% used for simulation, saved here for future loading
if ispc 
    abaqusDir_preMesh = 'not defined yet';
    LVSegDir =          'not defined yet';
elseif isunix
    abaqusDir_preMesh = '/xlwork3/hgao/segmentationResults/Results_done_HG/HV03/earlyDiastole';
    LVSegDir = abaqusDir_preMesh;
end


%% abaqusDir_pca is the reconstructed geometry from pca analysis
%% FiberGenerationDir is for fibre generation
abaqusDir_pca = 'pca_reconstruction';
cd(abaqusDir);
if ~exist('pca_reconstruction', 'dir')
    mkdir(abaqusDir_pca);
end
cd(abaqusDir_pca);
abaqusDir_pca = pwd();
if ~exist('Results_fiber_60_45', 'dir')
    mkdir('Results_fiber_60_45');
end
cd('Results_fiber_60_45');
FiberGenerationDir = pwd();
cd(workingDir);

abaqus_input_name = 'abaqusInputPCAReconstruction.mat';



%% prepare the strain data, it is only used to provide the 24 segmentations, 
%% which is a template across all LV geometries, similar for LVVolume
%cd(abaqusDir);
%fid_strainMRI = fopen(straininvivoMRI_filename,'r');
%load LVVolume; %%LVVolume.endSystole, LVVolume.endDiastole; 
%cd(workingDir);

%% read strain from MRI measurement
%strainData = readStrainAfterBsplineRecovery(fid_strainMRI);
%fclose(fid_strainMRI);

%% now need to load the LV mesh with seg regions assigned
%% the mesh data used for simulation 
cd(abaqusDir_pca);
% load abaqusInputDataFibreGeneration;
% nodeIndex_endo = abaqusInputData.endoNodes;
% clear abaqusInputData;
AHADivisionExisted = true;
if exist('AHALVMeshDivisionPCAReconstructed.mat','file')
    load AHALVMeshDivisionPCAReconstructed; %% this provide the seg regions which will be used for strain comparison 
else
    AHADivisionExisted = false;
    disp('the AHADivision does not exist, will need to genereate the mesh first and then define the AHA');
end
cd(workingDir);


%% load the average shape and eigen vectors, which are saved in pcaResult
cd('../LVModelSimulator/averageShape');
load LV_mean;
pcaResult.LV_mean = LV_mean; clear LV_mean;
load Eigvecs_HVMI;
pcaResult.eigVecs = eigVecs; clear eigVecs;
cd(workingDir);


%% create a global options which can be reused in other functions
global options;
options.FiberGenerationDir = FiberGenerationDir;
options.abaqusDir_pca = abaqusDir_pca;
options.abaqusDir=abaqusDir;
options.abaqus_input_name = abaqus_input_name; %%the reconstructed abaqus file in matlab format
%% options.strainData = strainData;
options.abaqus_dis_out_filename = abaqus_dis_out_filename;
options.abaqus_input_main_filename = abaqus_input_main_filename;
options.abaqus_input_main_original_filename = abaqus_input_main_original_filename;
options.pythonOriginalFilesDir = pythonOriginalFilesDir;
options.pythonfilename = pythonfilename;
options.lineNoForODBName = lineNoForODBName;
options.lineNoForDisName = lineNoForDisName;
%% options.LVVolume = LVVolume;
%% options.sliceRegions = AHALVMeshDivision.segRegions;
if AHADivisionExisted
    options.AHALVMeshDivision = AHALVMeshDivision;
else
    options.AHALVMeshDivision = [];
end
options.abaqusDir_preMesh = abaqusDir_preMesh;
options.mpara_literature = mpara;
options.materialParam_startLine = materialParam_startLine;
options.pressure_loadingLine = pressure_loadingLine;
options.opt_log_filename = 'forward_LV_FE_running.dat';
options.cpunumber = 6; %%using how many cpu numbers, default value can be overwritten 
options.pcaResult = pcaResult;
%options.nodeIndex_endo =nodeIndex_endo;




%% strain data in 24 segs, which will depend on the images we have
%% if there are 5 images before apical region, then we will skip the first
strain_index_1 = 1;
strain_index_24 = 24;

%% or 
% strain_index_1 = 1;
% strain_index_24 = 24;

