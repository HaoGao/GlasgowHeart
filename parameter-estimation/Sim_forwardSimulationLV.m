%% Initially prepared by Hao Gao

clear all; close all; clc;
  
%% load gloabal options for HV1. Useful data will be saved in globla option
%% structure, need to make sure the directories specifed in DirConfig file is accurate
%% check two variables at least
%%  abaqusDir = '';
%% abaqusDir_preMesh = '';
Sim_DirConfigForwardComputation_HV04;

options.cpunumber = 12; %%using more cpus here

%% that part is for debugging, should not be changed once the model is setup
%% properly, for most of runs keep the following two variables false.
postprocess_only = 0;
regenerate_fibre = 1;
runAbaqus = 0;


%% using the right parameter sets
%% A, B, Af, Bf, As, Bs, Afs, Bfs are the 8 unknown parameters for HGO
%% myocardial material model
A = mpara.A*0.2;
B = mpara.B*0.2;
Af = mpara.Af*0.2;
Bf = mpara.Bf*0.2;
As = mpara.As*0.2;
Bs = mpara.Bs*0.2;
Afs = mpara.Afs*0.2;
Bfs = mpara.Bfs*0.2;

%%% 
a_fibre_endo = -60.0*pi/180; %% negative in the endocardium
a_fibre_epi = 60.0*pi/180; %% positive in the epicardium
a_sheet = 45.0*pi/180; %% same angle at both endocardium and epicardium

% A = 0.100000;
% B =1.89;
% Af = 3.59;
% Bf = 5.66;
% As = 0566;
% Bs = 1.74;
% Afs = 0.100000;
% Bfs = 1.98;
%% myocardial material model from the porcine data
% A = mpara.A; B = mpara.B; Af = mpara.Af; Bf = mpara.Bf; As = mpara.As; Bs=mpara.Bs; Afs=mpara.Afs; Bfs=mpara.Bfs;
    

pres = 8.0; %%mmHg, end-diastolic pressure loading


%% here we need to provide the eigen values, which is calculated
%% (LV-LV_mean)*eigVecs, LV-LV_mean needs to be a row vector
%% wc_pca = [1.0 1.0 1.0 1.0 1.0]; %%only use five eigen vectors for reconstruction the mesh
%  wc_pca = [-18.2695   -1.4049    2.8309  -14.6374  -25.4179]; %% that is from HV03

%% using how many cpus for parameter computing, 4 - 6 will be good choice
%% we might have only 48 tokens currently, 16 more are being purchased
%% so please use only maximum 40 tokens, which means if 4 token per matlab session,
%% then you can run up to 10 matlab sessions in parallel. 
%% for the current setting
%% options.cpunumber = 6;  %%default value
  

%% pressure_loading = 8 : 16;


%% save the results for post processing
ResLVVol = [];
ResLVStrain = [];

%% now the main loops to run the forward simulator
for i = 1 : 1 %length(pressure_loading)

  
%     pres = pressure_loading(i);
     
     if ~postprocess_only  %%skip this part if only for post-processing
        %% regnerate the mesh based on PCA and average shape
        %% that function needs to properly desinged so that it should save a
        %% abaqusInputPCAReconstruction.mat inside abaqusDir_pca

        if regenerate_fibre
            %% this will save one layer mesh in abaqusDir_pca
            %% input: abaqusInput, hard coded inside
            %% output: abaqusInputPCAReconstructionOneLayer, hard coded inside
            disp('preparing LV mesh begins .......');
            %pcaReconstructionUsing5EigenVectors(wc_pca, options.pcaResult.LV_mean,...
            %            options.pcaResult.eigVecs, abaqusDir_pca, true);%true means output shapes in tecplot format

            %% copy the original abaqusnInputData into abaqusInputPCAReconstructionOneLayler, no changes to the mesh
            %% this function output is same as pcaReconstructionUsing5EigenVectors
            copyAbaqusMeshFileAsReconstruction(abaqusDir_pca, abaqusDir_preMesh, true); %true means outputing the mesh file

            %% output a fine mesh whcih can be used for abaqus simulation 
            %% input  : abaqusInputPCAReconstrucitonOneLayer, hard coded inside 
            %% output : abaqusInputPCAReconstruction.mat and LVMeshAba.inp
            NLayers = 10;
            abaqusInputPCAReconstruction = LVMeshAddNLayers(NLayers, abaqusDir_pca);
            disp('preparing LV mesh ends .......');

            disp('Generating fibre begins .......');  
            %% output the formate into abaqus formate and also generate the fibre direction
            %% abaqusDir_pca and FiberGenerationDir are subfolders inside abaqusDir
            %% abaqusDir needs to set up in the configure file
            %% input: abaquInputPCAReconstruction
            LV_WholeMesh_abaqusFilePreparation(abaqusDir_pca,abaqusDir);
            %% then the fibre generation
            LV_WholeMesh_FibreGeneration(a_fibre_endo, a_fibre_epi, a_sheet, ...
                                        abaqusDir_pca,FiberGenerationDir,abaqusDir);
            %% the above two functions will generate two differen files 
            %% file 1: mesh file in abaqusDir folder
            %% file 2: fibre direction, in abaqusDir folder
            disp('Generating fibre ends ........'); 
        end
     end
   
    if runAbaqus
        %% calling one forward simulation with provided 8 unknown parameters 
        [LVVolumeAba, strainAbaTotal,strainComparison, SuccessB] = ...
                    Sim_LVPassiveForwardSimulationMatPres(A,   B, ...
                                                      Af,  Bf, ...
                                                      As,  Bs, ...
                                                      Afs, Bfs, ...
                                                      pres, ...
                                                      postprocess_only); %false meanding running abaqus forward simulaiton, otherwise only post-processing
    %       pres_30 = 30;
    %      [LVVolumeAba_30, strainAbaTotal_30,strainComparison_30, SuccessB] = ...
    %                 Sim_LVPassiveForwardSimulationMatPres(A,   B, ...
    %                                                   Af,  Bf, ...
    %                                                   As,  Bs, ...
    %                                                   Afs, Bfs, ...
    %                                                   pres_30, ...
    %                                                   postprocess_only); %false meanding running abaqus forward simulaiton, otherwise only post-processing

       %%to save the volume and 24 strains
       ResLVVol(i, 1) = LVVolumeAba;
       ResLVStrain(i,1:24) = strainComparison.strainAbaTotalOnEachSlice(strain_index_1:strain_index_24);
       SimRes(i,1).strainComparison = strainComparison;
   
   
    end
end %% running the simulator                                              
                                              
                                         
%% datestr(now)
%% using LVVolumeAba and  LVVolumeMRI to formualte volume objective function 
%% using strainAbaTotal and strainMRITotal to formulate strain objective function
%% SuccessB is used to decide whether FE computation is successful or not
%% if SuccessB == 0, then all output will be empty. 

