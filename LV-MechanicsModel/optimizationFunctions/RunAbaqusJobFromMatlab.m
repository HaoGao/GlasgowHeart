function [status,result] = RunAbaqusJobFromMatlab(abaqus_dir,abaqus_inputfile)

global options;
abaqusCMD = options.abaqusCMD;

disp('abaqus running');

workingDir = pwd();
cd(abaqus_dir);
% abaqusDir = pwd();


abaqus_inputfile = sprintf('%s.inp',abaqus_inputfile);

%%%now running the abaqus 

%this is for windows running
% command = sprintf('abaqus job=%s user=myuanisohyper_inv cpus=3 interactive scratch=%s',abaqus_inputfile,abaqus_dir);
% [status,result] = dos(command);

%%% to be updated for linux machine, configured with Euclid at University
%%% of Glasgow
if isunix
    cd('/maths/abaqus/Commands');
    %if ~exist('abq6121','file')
    if  ~exist('abq6142','file')
        cd(workingDir);
        errordlg('abaqus can not be located');
        quit force;
    else

       cd(abaqus_dir);
       command = sprintf('/maths/abaqus/Commands/abq6142 job=%s user=myuanisohyper_inv cpus=%d interactive scratch=%s',abaqus_inputfile,options.cpunumber, abaqus_dir);
    % command = sprintf('/maths/Abaqus_Heart/Commands/abq6143 job=%s user=myuanisohyper_inv cpus=%d interactive scratch=%s',abaqus_inputfile,options.cpunumber, abaqus_dir);
    % command = sprintf('/maths/abaqus/Commands/abq6121 job=%s user=myuanisohyper_inv cpus=4 interactive',abaqus_inputfile);
       [status,result] = system(command,'-echo');
       cd(workingDir);
    end
end

if ispc
    %%%now running the abaqus 
    %%%first we delete all old results
    delete('*.com');
    delete('*.lck');
    delete('*.odb');
    delete('*.par');
    delete('*.msg');
    delete('*.pes');
    delete('*.pmg');
    delete('*.prt');
    delete('*.sim');
    delete('*.sta');
    delete('*.mdl');

    command = sprintf('%s job=%s user=myuanisohyper_inv cpus=%d interactive',abaqusCMD, abaqus_inputfile, options.cpunumber);
    [status,result] = dos(command)
    cd(workingDir);
end


cd(workingDir);
