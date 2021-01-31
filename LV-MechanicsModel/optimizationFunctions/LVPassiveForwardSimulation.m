function [LVVolumeAba, strainAbaTotal, LVVolumeMRI, strainMRITotal, SuccessB] = LVPassiveForwardSimulation(A, B, Af, Bf, As, Bs, Afs, Bfs)
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

% mpara = options.mpara;

% %%only Af, Bf, As, Bs will be optimized
% A = mpara.A;
% B = mpara.B;
% Af = mpara.Af;
% Bf = mpara.Bf;
% As = mpara.As;
% Bs = mpara.Bs;
% Afs = mpara.Afs;
% Bfs = mpara.Bfs;


%%%now need to call abaqus to run the simualtion 

abaqusDir = options.abaqusDir;
abaqus_input_main_filename = options.abaqus_input_main_filename;
abaqus_input_main_original_filename = options.abaqus_input_main_original_filename;
materialParam_startLine = options.materialParam_startLine;
pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName;
lineNoForDisName = options.lineNoForDisName;
abaqus_dis_out_filename = options.abaqus_dis_out_filename;
nodeIndex_endo = options.nodeIndex_endo;
opt_log_filename = options.opt_log_filename;

abaqusInputFileUpdate_MatModel(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                            materialParam_startLine, A, B, Af, Bf, As, Bs, Afs, Bfs);
%%%call abaqus to run the simulation 
[~,status] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename)
%%check whether the running is finished or not
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);

if (SuccessB == 1)
    strainComparison = strainComparisonAbaqusVsMRI();

    feval_total = strainComparison.strainDiff; 
    feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;

    feval_total_fmincon = sum(feval_total.^2);

    %%%write out the resuls 
    cd(abaqusDir);
    fid_log = fopen(opt_log_filename,'w');
    cd(workingDir);
    timestr =  datestr(clock());
    fprintf(fid_log, 'running a synthetic model');
    fprintf(fid_log, 'Step running on %s\n', timestr);
    fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
    fprintf(fid_log, 'parameters used: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', A, B, Af, Bf, As, Bs, Afs, Bfs);
    fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, strainComparison.LVVolumeMRI);
    %fprintf(fid_log, 'LV strain difference squared: %f\n', sum(feval_total.^2));
    fprintf(fid_log, 'LV strain difference squared: %f using %d segments (ave: %f vs %f) \n', sum(feval_total.^2)^0.5, length(strainComparison.strainMRITotal), ...
                                   mean(strainComparison.strainMRITotal),mean(strainComparison.strainAbaTotal) );
    %%output the strain data
    fprintf(fid_log, 'measured strain data \n');
    for i = 1 : length(strainComparison.strainMRITotal)
        fprintf(fid_log, '%f', strainComparison.strainMRITotal(i) );
    end
    fprintf(fid_log, '\n');	

    %%output the strain data
    fprintf(fid_log, 'abaqus strain data \n');
    for i = 1 : length(strainComparison.strainAbaTotal)
        fprintf(fid_log, '%f', strainComparison.strainAbaTotal(i) );
    end
    fprintf(fid_log, '\n');	

    fprintf(fid_log, 'step ends\n');
    fprintf(fid_log, '\n');
    fclose(fid_log);
    
    LVVolumeAba = strainComparison.LVVolumeAba;
    strainAbaTotal = strainComparison.strainAbaTotal;
    LVVolumeMRI = strainComparison.LVVolumeMRI;
    strainMRITotal = strainComparison.strainMRITotal;
    
else
    cd(abaqusDir);
    fid_log = fopen(opt_log_filename,'w');
    cd(workingDir);
    timestr =  datestr(clock());
    fprintf(fid_log, 'running a synthetic model');
    fprintf(fid_log, 'Step running on %s\n', timestr);
    fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
    fclose(fid_log);
    
    LVVolumeAba = [];
    strainAbaTotal = [];
    LVVolumeMRI = [];
    strainMRITotal = [];
end







