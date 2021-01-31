function DislacementExtractByPython(abaqus_dir,abaqus_inputfile,pythonOriginalFilesDir,...
           pythonfile, lineNoForODBName, lineNoForDisName, abaqus_dis_out_filename)
       
global options;
abaqusCMD = options.abaqusCMD;

workingDir = pwd();
%%%abaqus odb file name
abaqus_odb_name = sprintf('%s.odb',abaqus_inputfile);

%%%need to change some lines in pythonfile
cd(pythonOriginalFilesDir);
fid_python = fopen(pythonfile,'r');
cd(abaqus_dir);
fid_python_updated = fopen('abaqus_dis_up.py','w');
cd(workingDir);

lineIndex = 1;
tline = fgetl(fid_python);
fprintf(fid_python_updated,'%s\r\n',tline);

while ~feof(fid_python)
    lineIndex = lineIndex + 1;
    tline = fgetl(fid_python);
    if lineIndex == lineNoForODBName
        tline = sprintf('myOdb = openOdb(path=''%s'')',abaqus_odb_name);
    elseif lineIndex == lineNoForDisName
        tline = sprintf('outfilename=''%s''',abaqus_dis_out_filename );
    end
    fprintf(fid_python_updated,'%s\r\n',tline);
end
fclose(fid_python_updated);
fclose(fid_python);

%% to be updated in linux
%%%now run the python file to get the displacement
cd(abaqus_dir);
if isunix
command = sprintf('/maths/abaqus/Commands/abq6142 python abaqus_dis_up.py -odb, %s',abaqus_odb_name);
dos(command);
end


if ispc
    command = sprintf('%s python abaqus_dis_up.py -odb, %s',abaqusCMD, abaqus_odb_name);
    dos(command);
end



% command=['!abaqus python abaqus_stress.py -odb', 'LVpassive.odb'];
% eval(command);
cd(workingDir);
