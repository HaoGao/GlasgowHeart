function [LVVolumeAba, strainAbaTotal,strainComparison,SuccessB] = ...
      Sim_LVPassiveForwardSimulationMatPres(A, B, Af, Bf, As, Bs, Afs, Bfs, pres, postprocess_only)
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

if ~postprocess_only
    abaqusInputFileUpdate_MatModel_Press(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                                materialParam_startLine, A, B, Af, Bf, As, Bs, Afs, Bfs, ...
                                                pressure_loadingLine, pres);
    %%%call abaqus to run the simulation 
    [~,status] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename)
end

%%check whether the running is finished or not, or there is the result file
%%for postprocessing
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);

if (SuccessB == 1)
    strainComparison = strainComparisonAbaqusVsMRI();

    %feval_total = strainComparison.strainDiff;  %%this is not useful
    %feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;

    %feval_total_fmincon = sum(feval_total.^2);

    %%%write out the resuls 
    cd(abaqusDir);
    fid_log = fopen(opt_log_filename,'a');
    cd(workingDir);
    timestr =  datestr(clock());
    fprintf(fid_log, 'running a synthetic model');
    fprintf(fid_log, 'Step running on %s\n', timestr);
    fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
    fprintf(fid_log, 'parameters used: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f, \t%f mmHg\n', A, B, Af, Bf, As, Bs, Afs, Bfs, pres);
    fprintf(fid_log, 'LV volume: %f\n', strainComparison.LVVolumeAba);
    %fprintf(fid_log, 'LV strain difference squared: %f\n', sum(feval_total.^2));
    fprintf(fid_log, 'LV strain: ave: %f with %d segments \n',mean(strainComparison.strainAbaTotal), ...
        length(strainComparison.strainAbaTotal) );	

    %%output the strain data
    fprintf(fid_log, 'abaqus strain data according to AHA17 \n');
    for i = 1 : length(strainComparison.strainAbaTotal)
        fprintf(fid_log, '%f\t', strainComparison.strainAbaTotal(i) );
    end
    fprintf(fid_log, '\n');	
    
     %%output the strain data ib each slice
     
    fprintf(fid_log, 'LV strain from each slice: ave: %f with %d segments \n',mean(strainComparison.strainAbaTotalOnEachSlice(1:24)), ...
        length(strainComparison.strainAbaTotalOnEachSlice(1:24)) );	
    fprintf(fid_log, 'abaqus strain data on each slice \n');
    for i = 1 : length(strainComparison.strainAbaTotalOnEachSlice)
        fprintf(fid_log, '%f\t', strainComparison.strainAbaTotalOnEachSlice(i) );
    end
    fprintf(fid_log, '\n');	

    fprintf(fid_log, 'step ends\n');
    fprintf(fid_log, '\n');
    fclose(fid_log);
    
    LVVolumeAba = strainComparison.LVVolumeAba;
    strainAbaTotal = strainComparison.strainAbaTotal;
    
    
else
    cd(abaqusDir);
    fid_log = fopen(opt_log_filename,'a');
    cd(workingDir);
    timestr =  datestr(clock());
    fprintf(fid_log, 'running a synthetic model');
    fprintf(fid_log, 'Step running on %s\n', timestr);
    fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
    fclose(fid_log);
    
    LVVolumeAba = [];
    strainAbaTotal = [];
end







