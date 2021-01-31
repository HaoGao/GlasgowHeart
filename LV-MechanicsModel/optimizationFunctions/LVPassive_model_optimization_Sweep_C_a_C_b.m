function ResRecord = LVPassive_model_optimization_Sweep_C_a_C_b(C_a, C_b)

workingDir = pwd();
global options;

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
mpara = options.mpara;


abaqusInputFileUpdate_CaCbModel(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                            materialParam_startLine, mpara, C_a, C_b);
%%%call abaqus to run the simulation 
[status,result] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename);  

%%check whether the running is finished or not
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);
            %%%extract the displacement fileds for all nodes
if SuccessB == 1            
    strainComparison = strainComparisonAbaqusVsMRI();

    feval_total = strainComparison.strainDiff; 
    feval_total(end+1) = (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;

    objvol = abs(strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)/strainComparison.LVVolumeMRI;
    objksivol = sum(feval_total.^2)^0.5;
else
    objvol = -100;
    objksivol = -100;
    error('Abaqus quite without convergence!');
end


%%%save the result in the output variables
ResRecord.C_a = C_a;
ResRecord.C_b = C_b;
ResRecord.vol = strainComparison.LVVolumeAba;
ResRecord.strainComparison = strainComparison;
ResRecord.SuccessB = SuccessB;
ResRecord.objvol = objvol;
ResRecord.objksivol = objksivol;



%%%write out the resuls 
cd(abaqusDir);
fid_log = fopen(opt_log_filename,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, 'one iteration begins\n');
fprintf(fid_log, 'Step 1 sweeping optimization on %s\n', timestr);
fprintf(fid_log, 'abaqus running success: %d\n', SuccessB);
fprintf(fid_log, 'Ca Cb updated:          %f,\t%f\n', C_a, C_b);
fprintf(fid_log, 'parameters updated: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', mpara.A, mpara.B, mpara.Af, mpara.Bf, ...
                                                                                mpara.As, mpara.Bs, mpara.Afs, mpara.Bfs);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, strainComparison.LVVolumeMRI);
fprintf(fid_log, 'Initial LV volume (beginning of diastole): %f\n', strainComparison.LVVolumeOri);
fprintf(fid_log, 'LV strain difference squared: %f using %d segments (ave: %f vs %f) \n', sum(feval_total(1:end-1).^2)^0.5, length(strainComparison.strainMRITotal), ...
                               mean(strainComparison.strainMRITotal),mean(strainComparison.strainAbaTotal) );
fprintf(fid_log, 'object function evaluation: %f\n', sum(feval_total(1:end-1).^2) + ...
                             (strainComparison.LVVolumeAba-strainComparison.LVVolumeMRI)^2);                               
fprintf(fid_log, 'one iteration ends\n');
fprintf(fid_log, '\n');
fclose(fid_log);


% assert(SuccessB==1);
