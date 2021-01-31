function [check_status,check_result] = ...
      Sim_LVPassiveForwardSimulationMatPres_dataCheck(A, B, Af, Bf, As, Bs, Afs, Bfs, pres, data_check)
%%%input
%%A, B, Af, Bf, As, Bs, Afs, Bfs are material parameters for HGO model
%%
%%output
%%LVVolumeAba: simulated LV cavility volume from Abaqus
%%strainAbaTotal: segmental myocardial strain from Abaqus
%%LVVolumeMRI: measured LV cavility volume from MRI or synthetic models
%%strainMRITotal: segmental myocaridal strain from MRI or synthetic models
%%SuccessB: whehter Abaqus successes (SuccessB==1) or fails (!=1)

workingDir = pwd();
global options;

%%%now need to call abaqus to run the simualtion 
abaqusDir = options.abaqusDir;
abaqus_input_main_filename = options.abaqus_input_main_filename;
abaqus_input_main_original_filename = options.abaqus_input_main_original_filename;
materialParam_startLine = options.materialParam_startLine;
pressure_loadingLine = options.pressure_loadingLine;
pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName;
lineNoForDisName = options.lineNoForDisName;
abaqus_dis_out_filename = options.abaqus_dis_out_filename;
%nodeIndex_endo = options.nodeIndex_endo;
opt_log_filename = options.opt_log_filename;

if data_check
    disp('running abaqus for data check!');
    abaqusInputFileUpdate_MatModel_Press(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                                materialParam_startLine, A, B, Af, Bf, As, Bs, Afs, Bfs, ...
                                                pressure_loadingLine, pres);
    %%%call abaqus to run the simulation 
    [check_status,check_result] = RunAbaqusJobFromMatlab_dataCheck(abaqusDir,abaqus_input_main_filename)
end







