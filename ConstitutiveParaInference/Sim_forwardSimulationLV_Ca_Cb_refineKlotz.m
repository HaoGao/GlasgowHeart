%% Initially prepared by Hao Gao
%% here we will optimize the volume according to the klotz curve

clear all; close all; clc;
  
%% load gloabal options for HV1. Useful data will be saved in globla option
%% structure
Sim_DirConfigForwardComputation_HVex;
options.cpunumber = 4; 


%% read the strain data from images 
cd(abaqusDir_preMesh);
fid_strainMRI = fopen(straininvivoMRI_filename,'r');
cd(workingDir);
%%%read strain from MRI measurement
strainData_struct = readStrainAfterBsplineRecovery(fid_strainMRI);
fclose(fid_strainMRI);
strainData = [];
for i = 1 : size(strainData_struct,2)
    strainData = [strainData; strainData_struct(1,i).segStrain];
end


%%load LV measured end-diastolic volume
cd(abaqusDir_preMesh);
load LVVolumeMeasured;
cd(workingDir);


%% using the right parameter sets
%% A, B, Af, Bf, As, Bs, Afs, Bfs are the 8 unknown parameters for HGO
%% myocardial material model
% A = 0.224487;
% B = 1.621500;
% Af = 2.426717;
% Bf = 1.826862;
% As = 0.556238;
% Bs = 0.774678;
% Afs = 0.390516;
% Bfs = 1.695000;






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
  

%% that part is for debugging, should not be changed once the model is setup
%% properly
postprocess_only = false;
regenerate_fibre = false;


%% before calling the optimization function, we will need to update the global options
cd(options.abaqusDir);
load stepCaCbOpt; %% Ca_opt Cb_opt;
cd(workingDir);

Ca = Ca_opt;
Cb = Cb_opt;
mpara.A = mpara.A*Ca;
mpara.B = mpara.B*Cb;
mpara.Af = mpara.Af*Ca;
mpara.Bf = mpara.Bf*Cb;
mpara.As = mpara.As*Ca;
mpara.Bs = mpara.Bs*Cb;
mpara.Afs = mpara.Afs*Ca;
mpara.Bfs = mpara.Bfs*Cb;
options.mpara = mpara; %%remember to update here


options.strainData= strainData;
options.LVEDVMRI = LVVolumeMeasured.edv;
options.LVEDP_high = 30;
options.LVEDP_norm = 8;



Lb_aafs = [0.1 0.05];
Ub_aafs = [10.0 10.0];
options_Opt = optimset('Algorithm', 'sqp', 'TolFun', 1e-3, ...
                       'TolX',0.001,'Diffminchange',1e-3);
ca_cb_0 = [1.0 1.0];
[ca_cb,fval,exitflag,output] = fmincon(@LVPassive_model_optimization_fmincon_ca_cb_klotz,ca_cb_0,[],[], [], [], Lb_aafs,Ub_aafs,[],options_Opt);

A_opt = mpara.A*ca_cb(1);
B_opt = mpara.B*ca_cb(2);
Af_opt = mpara.Af*ca_cb(1);
Bf_opt = mpara.Bf*ca_cb(2);
As_opt = mpara.As*ca_cb(1);
Bs_opt = mpara.Bs*ca_cb(2);
Afs_opt = mpara.Afs*ca_cb(1);
Bfs_opt = mpara.Bfs*ca_cb(2);
if A_opt < 0.1
    A_opt = 0.1;
end
if Af_opt < 0.1
    Af_opt = 0.1;
end
if As_opt < 0.1
    As_opt = 0.1;
end
if Afs_opt < 0.1
    Afs_opt = 0.1;
end
cd(options.abaqusDir);
save stepCaCbKlotzOpt  A_opt B_opt Af_opt Bf_opt As_opt Bs_opt Afs_opt Bfs_opt;
cd(workingDir);

[A_opt B_opt Af_opt Bf_opt As_opt Bs_opt Afs_opt Bfs_opt ]

















