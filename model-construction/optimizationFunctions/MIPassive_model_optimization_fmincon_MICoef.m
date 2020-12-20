function feval_total_fmincon = MIPassive_model_optimization_fmincon_MICoef(x)

workingDir = pwd();
global options;

mpara = options.mpara;

%%only Af, Bf, As, Bs will be optimized
A = mpara.A;
B = mpara.B;
Af = mpara.Af;
Bf = mpara.Bf;
As = mpara.As;
Bs = mpara.Bs;
Afs = mpara.Afs;
Bfs = mpara.Bfs;
MICoefMax = options.MICoefMax;
MACHANGE = x(1)*MICoefMax;

%%%now need to call abaqus to run the simualtion 

abaqusDir = options.abaqusDir;
abaqus_input_main_filename = options.abaqus_input_main_filename;
abaqus_input_main_original_filename = options.abaqus_input_main_original_filename;
materialParam_startLine = options.materialParam_startLine;

materialScaleMI_lineNo = options.materialScaleMI_lineNo;
pressureLoading_lineNo = options.pressureLoading_lineNo;
endSystolicPressure = options.endSystolicPressure ; %%currently the end-diasatolic pressur will be used in the prepared inp file

pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName;
lineNoForDisName = options.lineNoForDisName;
abaqus_dis_out_filename = options.abaqus_dis_out_filename;
nodeIndex_endo = options.nodeIndex_endo;
opt_log_filename = options.opt_log_filename;


abaqusInputFileUpdate_MI_MatModel(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                            materialParam_startLine, A, B, Af, Bf, As, Bs, Afs, Bfs, ...
                                            materialScaleMI_lineNo, MACHANGE, ...
                                            pressureLoading_lineNo, endSystolicPressure);
                                        
                                        
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
% feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI);
% only use the strain data, there is no volume data available

% feval_total_fmincon = sum(feval_total.^2);
feval_total_fmincon = abs(mean(strainComparison.strainMRITotal)-mean(strainComparison.strainAbaTotal));

%%%write out the resuls 
cd(abaqusDir);
fid_log = fopen(opt_log_filename,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, 'one iteration begins: ');
fprintf(fid_log, 'Step 4 optimization for MI on %s\n', timestr);
fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
fprintf(fid_log, 'MI scale updated:          %f\n', x);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, strainComparison.LVVolumeMRI);
fprintf(fid_log, 'LV strain difference squared: %f using %d segments (ave: %f vs %f) \n', sum(feval_total.^2)^0.5, length(strainComparison.strainMRITotal), ...
                               mean(strainComparison.strainMRITotal),mean(strainComparison.strainAbaTotal) );
for i = 1 : length(strainComparison.strainMRITotal)
     fprintf(fid_log, '%f   ', strainComparison.strainMRITotal(i)  );
end
fprintf(fid_log, '\n');

for i = 1 : length(strainComparison.strainAbaTotal)
     fprintf(fid_log, '%f   ', strainComparison.strainAbaTotal(i)  );
end
fprintf(fid_log, '\n');     
     
fprintf(fid_log, 'one iteration ends\n');
fprintf(fid_log, '\n');
fclose(fid_log);


assert(SuccessB==1);


