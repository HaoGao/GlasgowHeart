function abaqusInputFileUpdate_CaCbModel(abaqus_dir,abaqus_inputfile, abaqus_inputfile_original, ...
     materialParam_startLine, mpara, C_a, C_b)

 
%%boyce's suggestion
% a    = a^ini
% b    = 0.5*b^ini
% a_f  = C_a*a_f^ini
% a_s  = C_a*a_s^ini
% a_fs = C_a*a_fs^ini
% b_f  = C_b*a_f^ini
% b_s  = C_b*a_s^ini
% b_fs = C_b*a_fs^ini
%%%here we slightly change as 
% a = C_a*a^ini
% b = C_b*b^ini
% at the same time Ca is no less than Cb/3
 
 %%%this is for normal healthy subject
%%%original 
% mpara.A = 0.24;
% mpara.B = 5.08;
% mpara.Af = 2.04;
% mpara.Bf = 4.15;
% mpara.As = 1.2;
% mpara.Bs = 1.6;
% mpara.Afs = 0.41088;
% mpara.Bfs = 1.3;

workingDir = pwd();

cd(abaqus_dir);

cmd_delete_abaqus_odbfile = sprintf('%s.odb', abaqus_inputfile);
unix(cmd_delete_abaqus_odbfile);

abaqus_inputfile = sprintf('%s.inp',abaqus_inputfile);
abaqus_inputfile_original = sprintf('%s.inp',abaqus_inputfile_original);

fid_abaqus_inputfile = fopen(abaqus_inputfile,'w');
fid_abaqus_original= fopen(abaqus_inputfile_original,'r');

lineIndex = 1;
tline = fgetl(fid_abaqus_original);
fprintf(fid_abaqus_inputfile,'%s\r\n',tline);


while ~feof(fid_abaqus_original)
    lineIndex = lineIndex + 1;
    tline = fgetl(fid_abaqus_original);
    
    if lineIndex == materialParam_startLine
        tline = sprintf('A=%f',mpara.A*C_a);
    end
    if lineIndex == materialParam_startLine+1
        tline = sprintf('B=%f',mpara.B*C_b);
    end
    if lineIndex == materialParam_startLine+2
        tline = sprintf('Af=%f',mpara.Af*C_a);
    end
    if lineIndex == materialParam_startLine+3
        tline = sprintf('Bf=%f',mpara.Bf*C_b);
    end
    if lineIndex == materialParam_startLine+4
        tline = sprintf('As=%f',mpara.As*C_a);
    end
    if lineIndex == materialParam_startLine+5
        tline = sprintf('Bs=%f',mpara.Bs*C_b);
    end
    if lineIndex == materialParam_startLine+6
        tline = sprintf('Afs=%f',mpara.Afs*C_a);
    end
    if lineIndex == materialParam_startLine+7
        tline = sprintf('Bfs=%f',mpara.Bfs*C_b);
    end
    
    fprintf(fid_abaqus_inputfile,'%s\r\n',tline);
end
fclose(fid_abaqus_inputfile);
fclose(fid_abaqus_original);
cd(workingDir);



%%%now run the python file to get the displacement