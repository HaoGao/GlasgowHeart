close all; clear all; clc;
%% Initially prepared by Hao Gao
%% here we will optimize af bf
  
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
strainDataFlag = [];
for i = 1 : size(strainData_struct,2)
    strainData = [strainData; strainData_struct(1,i).segStrain];
    strainDataFlag = [strainDataFlag; strainData_struct(1,i).segStrainB];
end


%%load LV measured end-diastolic volume
cd(abaqusDir_preMesh);
load LVVolumeMeasured;
cd(workingDir);

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

%%%trying to load the result from step 2 
cd(options.abaqusDir);
load stepCaCbKlotzOpt; %  A B Af Bf As Bs Afs Bfs;
cd(workingDir);
%% before calling the optimization function, we will need to update the paramters from the second step		
mpara.A = A_opt;
mpara.B = B_opt;
mpara.Af = Af_opt;
mpara.Bf = Bf_opt;
mpara.As = As_opt;
mpara.Bs = Bs_opt;
mpara.Afs = Afs_opt;
mpara.Bfs = Bfs_opt;
options.mpara = mpara; %%remember to update here
clear A_opt B_opt Af_opt Bf_opt As_opt Bs_opt Afs_opt Bfs_opt;


options.strainData= strainData;
options.strainDataFlag = strainDataFlag;
options.LVEDVMRI = LVVolumeMeasured.edv;
options.LVEDP_high = 30;
options.LVEDP_norm = 8;
options.strain_index_1 = 1;
options.strain_index_24 = 24;


cd(abaqusDir);
fid_log = fopen(opt_log_filename,'a');
cd(workingDir);
fprintf(fid_log, '\n \n beginning of step 3 for af bf\n \n');

options_Opt = optimset('Algorithm', 'sqp', 'TolFun', 1e-6, ...
                           'TolX',0.000001,'Diffminchange',1e-4,'Diffmaxchange',1e-3, 'MaxIter', 100);
afmin = 0.1;
afmax = 5;
bfmin = 0.1;
bfmax = 5;

Lb = [afmin bfmin ];
Ub = [afmax bfmax ];
x0 = [1.0  1.0];
[x,fval,exitflag,output] = fmincon(@LVPassive_model_optimization_fmincon_afbf,x0,[],[],[],[],Lb,Ub,[],options_Opt);


cd(abaqusDir);
A_opt = options.mpara.A;
B_opt = options.mpara.B;
Af_opt = options.mpara.Af*x(1);
Bf_opt = options.mpara.Bf*x(2);
As_opt = options.mpara.As;
Bs_opt = options.mpara.Bs;
Afs_opt = options.mpara.Afs;
Bfs_opt = options.mpara.Bfs;
save step_Af_Bf_opt A_opt B_opt Af_opt Bf_opt As_opt Bs_opt Afs_opt Bfs_opt
cd(workingDir);











