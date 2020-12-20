function feval_total_fmincon = LVPassive_model_optimization_fmincon_a_afs(x)
workingDir = pwd();
global options;

mpara = options.mpara;

%%only Af, Bf, As, Bs will be optimized
A = mpara.A*x(1);
B = mpara.B;
Af = mpara.Af;
Bf = mpara.Bf;
As = mpara.As;
Bs = mpara.Bs;
Afs = mpara.Afs*x(1);
Bfs = mpara.Bfs;

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
[status, results] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename)
%%check whether the running is finished or not
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);
if SuccessB == 0
    disp('abaqus is not converged!');
end

strainComparison = strainComparisonAbaqusVsMRI();

feval_total = strainComparison.strainDiff; 
% feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;
feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI);

feval_total_fmincon = sum(feval_total.^2);

%%%write out the resuls 
cd(abaqusDir);
fid_log = fopen(opt_log_filename,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, 'one iteration begins: ');
fprintf(fid_log, 'Step 3 optimization on %s\n', timestr);
fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
fprintf(fid_log, 'x updated:          %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', x, 1.0, 1.0, 1.0, 1.0, 1.0, x, 1.0);
fprintf(fid_log, 'parameters updated: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', A, B, Af, Bf, As, Bs, Afs, Bfs);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, strainComparison.LVVolumeMRI);
fprintf(fid_log, 'LV strain difference squared: %f using %d segments (ave: %f vs %f) \n', sum(feval_total.^2)^0.5, length(strainComparison.strainMRITotal), ...
                               mean(strainComparison.strainMRITotal),mean(strainComparison.strainAbaTotal) );
fprintf(fid_log, 'one iteration ends\n');
fprintf(fid_log, '\n');
fclose(fid_log);


assert(SuccessB==1);
