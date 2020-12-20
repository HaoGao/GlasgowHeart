%% Initially prepared by Hao Gao

clear all; close all; clc;
restoredefaultpath; %% avoid to mess up
  
%% load gloabal options for HV1. Useful data will be saved in globla option
%% structure, need to make sure the directories specifed in DirConfig file is accurate
%% check two variables at least
%%  abaqusDir = '';
%% abaqusDir_preMesh = '';
Sim_DirConfigForwardComputation_PCA;

%% using the right parameter sets
%% A, B, Af, Bf, As, Bs, Afs, Bfs are the 8 unknown parameters for HGO
%% myocardial material model
A = mpara.A;
B = mpara.B;
Af = mpara.Af;
Bf = mpara.Bf;
As = mpara.As;
Bs = mpara.Bs;
Afs = mpara.Afs;
Bfs = mpara.Bfs;

%% myocardial material model from the porcine data
% A = mpara.A; B = mpara.B; Af = mpara.Af; Bf = mpara.Bf; As = mpara.As; Bs=mpara.Bs; Afs=mpara.Afs; Bfs=mpara.Bfs;
    

pres = 8.0; %%mmHg, end-diastolic pressure loading


%% here we need to provide the eigen values, which is calculated
%% (LV-LV_mean)*eigVecs, LV-LV_mean needs to be a row vector
%% wc_pca = [1.0 1.0 1.0 1.0 1.0]; %%only use five eigen vectors for reconstruction the mesh
wc_pca = [-39.248000 -10.523000 -12.100000 3.794900 ]; %% that is from HV03

reconstruction_input.wc_pca = wc_pca; %%adding other fields for different reconstruction methods


%% using how many cpus for parameter computing, 4 - 6 will be good choice
%% we might have only 48 tokens currently, 16 more are being purchased
%% so please use only maximum 40 tokens, which means if 4 token per matlab session,
%% then you can run up to 10 matlab sessions in parallel. 
%% for the current setting
%% options.cpunumber = 6;  %%default value
  



reconstructed_method = 1; 
%% 0: direct copy the original mesh file for this subject, this is not set up properly now, do not use 0
%% 1:  PCA of this subject
%% 2:  auto encorder or others


%% save the results for post processing
ResLVVol = [];
ResLVStrain = [];

%% now the main loops to run the forward simulator
for i = 1 : 1 %length(pressure_loading)

     
%     pres = pressure_loading(i);
     
       %%skip this part if only for post-processing
        %% regnerate the mesh based on PCA and average shape
        %% that function needs to properly desinged so that it should save a
        %% abaqusInputPCAReconstruction.mat inside abaqusDir_pca

        
        %% this will save one layer mesh in abaqusDir_pca
        %% input: abaqusInput, hard coded inside
        %% output: abaqusInputPCAReconstructionOneLayer, hard coded inside
        reconstructionLVGeometry_Alan(reconstructed_method, abaqusDir_pca, abaqusDir_preMesh, ...
                                  options, reconstruction_input, true); %%true means there will be output after reconstruction

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
        LV_WholeMesh_FibreGeneration(abaqusDir_pca,FiberGenerationDir,abaqusDir);
        %% the above two functions will generate two differen files 
        %% file 1: mesh file in abaqusDir folder
        
        %% file 2: fibre direction, in abaqusDir folder
        disp('Generating fibre ends ........'); 
  
          
        [check_status,check_result]  = ...
                    Sim_LVPassiveForwardSimulationMatPres_dataCheck(A,   B, ...
                                                      Af,  Bf, ...
                                                      As,  Bs, ...
                                                      Afs, Bfs, ...
                                                      pres, ...
                                                      1); %1 means doing the check
       error_find = contains(check_result, 'Abaqus Error');
       
       if ~error_find
            %% calling one forward simulation with provided 8 unknown parameters 
            [LVVolumeAba, strainAbaTotal,strainComparison, SuccessB] = ...
                        Sim_LVPassiveForwardSimulationMatPres(A,   B, ...
                                                          Af,  Bf, ...
                                                          As,  Bs, ...
                                                          Afs, Bfs, ...
                                                          pres, ...
                                                          0); %false meanding running abaqus forward simulaiton, otherwise only post-processing
      
       %%to save the volume and 24 strains
       ResLVVol(i, 1) = LVVolumeAba;
       ResLVStrain(i,1:24) = strainComparison.strainAbaTotalOnEachSlice(strain_index_1:strain_index_24);
       SimRes(i,1).strainComparison = strainComparison;
       
       else
           disp('abaqus reject the input file generated from this PCA reconstruction!')
       end
   
   

end %% running the simulator                                              
