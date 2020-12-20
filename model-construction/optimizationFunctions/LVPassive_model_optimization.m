function feval_total = LVPassive_model_optimization(x)
workingDir = pwd();
global options;

mpara = options.mpara;

A = mpara.A*x(1);
B = mpara.B*x(2);
Af = mpara.Af*x(3);
Bf = mpara.Bf*x(4);
As = mpara.As*x(5);
Bs = mpara.Bs*x(6);
Afs = mpara.Afs*x(7);
Bfs = mpara.Bfs*x(8);

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
[~,~] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename);
%%check whether the running is finished or not
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);

strainComparison = strainComparisonAbaqusVsMRI();

feval_total = strainComparison.strainDiff; 
feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;

%%%write out the resuls 
cd(abaqusDir);
fid_log = fopen(opt_log_filename,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, 'one iteration begins');
fprintf(fid_log, 'Step 2 optimization on %s\n', timestr);
fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
fprintf(fid_log, 'x updated:          %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8));
fprintf(fid_log, 'parameters updated: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', A, B, Af, Bf, As, Bs, Afs, Bfs);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, strainComparison.LVVolumeMRI);
fprintf(fid_log, 'LV strain difference squared: %f\n', sum(feval_total.^2));
fprintf(fid_log, 'one iteration ends');
fclose(fid_log);


assert(SuccessB==1);
