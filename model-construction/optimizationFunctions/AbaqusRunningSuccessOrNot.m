function SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename)
%%%this function needs to read Abaqus sta file and find out the last time
%%%step, if there is only one stimulation step, it should work. 
%%if fail, the last sentence is  THE ANALYSIS HAS NOT BEEN COMPLETED
%%if success, the last sentence is  THE ANALYSIS HAS COMPLETED SUCCESSFULLY

SuccessB = 0;

workingDir = pwd();
cd(abaqusDir);
fileName = sprintf('%s.sta',abaqus_input_main_filename);

if ~exist(fileName, 'file')
    SuccessB = 1;
else
    
   fid = fopen(fileName, 'r');


   tline = fgetl(fid);
    while ~feof(fid) 
           tline = fgetl(fid);
           matchStr = regexp(tline, 'SUCCESSFULLY', 'match');
           if ~isempty(matchStr)
               SuccessB = 1;
           end 
    end
    fclose(fid);
end


%%%if successful, then delete all other files 
if SuccessB == 1 && isunix
    cd(abaqusDir);
    rmCmd = sprintf('rm -rf %s.inp', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.sta', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.prt', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.msg', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.dat', abaqus_input_main_filename); 
    unix(rmCmd);

    rmCmd = sprintf('rm -rf %s.sim', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.pmg', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.pes', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.par', abaqus_input_main_filename); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf %s.com', abaqus_input_main_filename); 
    unix(rmCmd);
    
end

%%%need to delete compiled fortran files 
if isunix
    rmCmd = sprintf('rm -rf *.o'); 
    unix(rmCmd);
    
    rmCmd = sprintf('rm -rf *.so'); 
    unix(rmCmd);
end

cd(workingDir);
    