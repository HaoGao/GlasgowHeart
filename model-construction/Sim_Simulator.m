function out = Sim_Simulator(A, B, Af, Bf, As, Bs, Afs, Bfs, pres)
  
%%load gloabal options for HV1. Useful data will be saved in globla option
%%structure
DirConfigForwardComputation_HV01;

% %%using the right parameter sets
% %%A, B, Af, Bf, As, Bs, Afs, Bfs are the 8 unknown parameters for HGO
% %%myocardial material model
% A = 0.224487;
% B = 1.621500;
% Af = 2.426717;
% Bf = 1.826862;
% As = 0.556238;
% Bs = 0.774678;
% Afs = 0.390516;
% Bfs = 1.695000;
% pres = 8.0; %%mmHg, end-diastolic pressure loading


mpara.A = A;
mpara.B = B;
mpara.Af = Af;
mpara.Bf = Bf;
mpara.As = As;
mpara.Bs = Bs;
mpara.Afs = Afs;
mpara.Bfs = Bfs;
options.mpara = mpara;

%%using how many cpus for parameter computing, 4 - 6 will be good choice
%%we might have only 48 tokens currently, 16 more are being purchased
%%so please use only maximum 40 tokens, which means if 4 token per matlab session,
%%then you can run up to 10 matlab sessions in parallel. 
%%for the current setting
options.cpunumber = 4;  

%%calling one forward simulation with provided 8 unknown parameters 
[LVVolumeAba, strainAbaTotal, LVVolumeMRI, strainMRITotal, SuccessB] = ...
        LVPassiveForwardSimulationMatPres(A,   B, ...
                                          Af,  Bf, ...
                                          As,  Bs, ...
                                          Afs, Bfs, ...
                                          pres);
   % datestr(now)

%%using LVVolumeAba and  LVVolumeMRI to formualte volume objective function 
%%using strainAbaTotal and strainMRITotal to formulate strain objective function
%%SuccessB is used to decide whether FE computation is successful or not
%%if SuccessB == 0, then all output will be empty. 

out.VolumeAbaqus = LVVolumeAba;         % cavity volume
out.TotalStrainAbaqus = strainAbaTotal; % for 24 segments
out.VolumeMRI = LVVolumeMRI;            % data from MRI
out.TotalStrainMRI = strainMRITotal;    % data from MRI
out.Success = SuccessB;                  % 1 = success
out.Options = options;
out.Inputs = struct('a', A, 'b', B, 'af', Af, 'bf', Bf, ...
    'as', As, 'bs', Bs, 'afs', Afs, 'bfs', Bfs, 'p', pres);

end
