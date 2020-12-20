function feval_total_fmincon = LVPassive_model_optimization_fmincon_afbf(x)

workingDir = pwd();
global options;
opt_log_filename = options.opt_log_filename ;
abaqusDir = options.abaqusDir;
strainData = options.strainData;
strainDataFlag = options.strainDataFlag;
strain_index_1 = options.strain_index_1;
strain_index_24 = options.strain_index_24;

%%only Af, Bf, As, Bs will be optimized
A = options.mpara.A;
B = options.mpara.B;
Af = options.mpara.Af*x(1);
Bf = options.mpara.Bf*x(2);
As = options.mpara.As;
Bs = options.mpara.Bs;
Afs = options.mpara.Afs;
Bfs = options.mpara.Bfs;

%%this is the constrain 
if As >= Af/2
    As = Af/2;
end

if Bs>=Bf/2
    Bs = Bf/2;
end

cd(abaqusDir);
fid_log = fopen(opt_log_filename ,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, '\n');
fprintf(fid_log, 'Step 3 optimization for af and bf %s\n', timestr);
fprintf(fid_log, 'one iteration begins in LVPassive_model_optimization_fmincon_afbf: %s\n',timestr);


%% calling one forward simulation with provided 8 unknown parameters 
pres = options.LVEDP_norm; 
[LVVolumeAba, ~,strainComparison, SuccessB] = ...
                    Sim_LVPassiveForwardSimulationMatPres(A,   B, ...
                                                      Af,  Bf, ...
                                                      As,  Bs, ...
                                                      Afs, Bfs, ...
                                                      pres, ...
                                                      false); 

fprintf(fid_log, 'finish one simulation with 8 mmHg\n\n');                                             

%%the objective function
strainComparison.strainAbaTotalOnEachSlice;
feval_total = [];
strain_selected_index=[];
for i = strain_index_1:1:strain_index_24
    if strainDataFlag(i)>0.0 
        feval_total = [feval_total, strainComparison.strainAbaTotalOnEachSlice(i) - strainData(i)];
        strain_selected_index = [strain_selected_index, i];
    end   
end
feval_total = [feval_total, (LVVolumeAba-options.LVEDVMRI)/options.LVEDVMRI]; %relative volume difference
feval_total_fmincon = sum(feval_total.^2); 

fprintf(fid_log, 'abaqus running success for step 3: %d\n', SuccessB);
fprintf(fid_log, 'x updated:          %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', 1.0, 1.0, x(1), x(2), 1.0, 1.0, 1.0, 1.0);
fprintf(fid_log, 'parameters updated: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', A, B, Af, Bf, As, Bs, Afs, Bfs);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, options.LVEDVMRI);
fprintf(fid_log, 'strain: %f (target: %f)\n', mean(strainComparison.strainAbaTotalOnEachSlice(strain_selected_index)),   ...
                                              mean(strainData(strain_selected_index) ) );
fprintf(fid_log, 'Difference (total): %f\n', feval_total_fmincon);

fprintf(fid_log, 'iteration ends\n');
fprintf(fid_log, '\n');
fclose(fid_log);

assert(SuccessB==1);
                                                  
                                                  
                                                  
                                                  
                                                  