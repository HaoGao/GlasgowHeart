function feval_total_fmincon = LVPassive_model_optimization_fmincon_ca_cb_klotz(x)

workingDir = pwd();
global options;
opt_log_filename = options.opt_log_filename ;
abaqusDir = options.abaqusDir;

% mpara = options.mpara;

%%only Af, Bf, As, Bs will be optimized
A = options.mpara.A*x(1);
B = options.mpara.B*x(2);
Af = options.mpara.Af*x(1);
Bf = options.mpara.Bf*x(2);
As = options.mpara.As*x(1);
Bs = options.mpara.Bs*x(2);
Afs = options.mpara.Afs*x(1);
Bfs = options.mpara.Bfs*x(2);

%%this is the constrain 
if A < 0.1
    A= 0.1;
end
if Af < 0.1
    Af = 0.1;
end
if As < 0.1
    As = 0.1;
end
if Afs < 0.1
    Afs = 0.1;
end

cd(abaqusDir);
fid_log = fopen(opt_log_filename ,'a');
cd(workingDir);
timestr =  datestr(clock());
fprintf(fid_log, '\n');
fprintf(fid_log, 'Step 2 optimization for Ca Cb based on Klotz curve on %s\n', timestr);
fprintf(fid_log, 'one iteration begins in LVPassive_model_optimization_fmincon_ca_cb_klotz: %s\n',timestr);


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

pres = options.LVEDP_high; 
[LVVolumeAba_30, ~, ~, SuccessB_30] = ...
                    Sim_LVPassiveForwardSimulationMatPres(A,   B, ...
                                                      Af,  Bf, ...
                                                      As,  Bs, ...
                                                      Afs, Bfs, ...
                                                      pres, ...
                                                      false); 
fprintf(fid_log, 'finish one simulation with %d mmHg\n\n', pres);                                                 

%%the objective function
feval_total = (LVVolumeAba-options.LVEDVMRI)/options.LVEDVMRI; %relative volume difference
feval_total_fmincon = sum(feval_total.^2); 


%%%call the klotz function, the original code takes so long time to compute
%%%the klotz curve
%[SumError, press_sim, EDV_sim, EDV_sim_norm, EDP_norm_klotzPrediction]= klotz_error_function(mpara_t);
%feval_total_fmincon = sum(SumError.^2)+feval_total_fmincon;

%%now we will only try to calculate the LEVDP=30mmHg, not all
EDV_norm = klotz_fit_function_inverse(options.LVEDP_norm);
EDV_high = klotz_fit_function_inverse(options.LVEDP_high);

V0 = strainComparison.LVVolumeOri;
%V_ed = strainComparison.LVVolumeAba;
V_ed = options.LVEDVMRI; %using the end-diastolic volume for prodicting what the value should be for LVEDP30
V_30 = ( (V_ed - V0)*EDV_high  + EDV_norm*V0)/EDV_norm;%%predicted using klotz curve
V_30_klotz = LVVolumeAba_30;
SumError = (V_30_klotz-V_30)/V_30; 

feval_total_fmincon = sum(SumError.^2)+feval_total_fmincon;



fprintf(fid_log, 'abaqus running success for step 2 klotz: %d\n', SuccessB);
fprintf(fid_log, 'x updated:          %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', x(1), x(2), x(1), x(2), x(1), x(2), x(1), x(2));
fprintf(fid_log, 'parameters updated: %f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n', A, B, Af, Bf, As, Bs, Afs, Bfs);
fprintf(fid_log, 'LV volume: %f(target: %f)\n', strainComparison.LVVolumeAba, options.LVEDVMRI);
fprintf(fid_log, 'Difference (total, volume, klotz): %f\t %f\t %f\n', feval_total_fmincon,  sum(feval_total.^2), sum(SumError.^2));
fprintf(fid_log, 'EDV_30_sim: %f,\t EDV_30_predicted using klotz curve: %f\n', V_30_klotz, V_30);

fprintf(fid_log, 'one iteration ends\n');
fprintf(fid_log, '\n');
fclose(fid_log);

assert(SuccessB==1);
assert(SuccessB_30==1);
                                                  
                                                  
                                                  
                                                  
                                                  