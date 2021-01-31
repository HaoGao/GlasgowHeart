function abaqusInputFileUpdate_MI_MatModel(abaqus_dir,abaqus_inputfile, abaqus_inputfile_original, ...
                                            materialParam_startLine, A, B, Af, Bf, As, Bs, Afs, Bfs, ...
                                            materialScaleMI_lineNo, MACHANGE, ...
                                            pressureLoading_lineNo, endSystolicPressure)
                                        
%%%here we also going to make whole LV like a MI LV                                        
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
        tline = sprintf('A=%f * MACHANGE',A);
    end
    if lineIndex == materialParam_startLine+1
        tline = sprintf('B=%f',B);
    end
    if lineIndex == materialParam_startLine+2
        tline = sprintf('Af=%f * MACHANGE',Af);
    end
    if lineIndex == materialParam_startLine+3
        tline = sprintf('Bf=%f',Bf);
    end
    if lineIndex == materialParam_startLine+4
        tline = sprintf('As=%f * MACHANGE',As);
    end
    if lineIndex == materialParam_startLine+5
        tline = sprintf('Bs=%f',Bs);
    end
    if lineIndex == materialParam_startLine+6
        tline = sprintf('Afs=%f * MACHANGE',Afs);
    end
    if lineIndex == materialParam_startLine+7
        tline = sprintf('Bfs=%f',Bfs);
    end
    
    %%%adding the MI part, and also set up the proper pressure 
    if lineIndex == pressureLoading_lineNo
        tline = sprintf('P_mmHg = %f', endSystolicPressure);
    end
    if lineIndex == materialScaleMI_lineNo
        tline = sprintf('MACHANGE = %f', MACHANGE);
    end
    
    
    %%write to the inp file
    fprintf(fid_abaqus_inputfile,'%s\r\n',tline);
end
fclose(fid_abaqus_inputfile);
fclose(fid_abaqus_original);
cd(workingDir);