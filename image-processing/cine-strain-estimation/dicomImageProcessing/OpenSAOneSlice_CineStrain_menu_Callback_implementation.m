function OpenSAOneSlice_CineStrain_menu_Callback_implementation(handles)


workingDir = handles.workingDir;
folder_name = uigetdir(workingDir, 'choose the dicom image folder');
cd(folder_name);
cd('..');
studyDirT = pwd();
cd(workingDir);
%%figure out the ImgDir
folderSepratorPosition = strfind(folder_name, '\');
studyDir = folder_name(1:folderSepratorPosition(end)-1);
if strcmp(studyDir, studyDirT) ~= 1
    disp('failed to figure out the right studyDir path, in function OpenSAOneSlice_CineStrain...');
end
ImgDir = folder_name(folderSepratorPosition(end)+1:end);
if length(folderSepratorPosition)>=2
    patientNameDef = folder_name(folderSepratorPosition(end-1)+1:folderSepratorPosition(end)-1);
    studyNameDef = patientNameDef;
else
    patientNameDef = 'patient_name';
    studyNameDef = 'study_name';
end

%%%now we need to find out other information
prompt = {'PatientName:','Study Name:'};
dlg_title = 'Information Input';
num_lines = 1;
def = {patientNameDef,studyNameDef};
answer = inputdlg(prompt,dlg_title,num_lines,def);
patientName = answer{1};
studyName = answer{2};

%%decide whether it is SA_Mid or SA_Apex
button = questdlg('Short-Axis Middle Slice','slice position','Yes');
if strcmp(button, 'Yes')
  position = 'SA_Mid';
else
  position = 'SA_Apex';
end

%%%now next step is to add this to a project file
newfileB = 0;
button = questdlg('save to a new file','save patient config','No');
if strcmp(button, 'Yes')
  [filename,pathname] = uiputfile('*.m','Save to a new project config file');
  newfileB = 1;
else
  [filename, pathname] = uigetfile('*.m', 'Select an existed project config file');
end

if isequal(filename,0) || isequal(pathname,0)
   disp('User selected Cancel')
else
    %%sav the options to the files
    dateStr = datestr(now);
    dateStr = sprintf('%% config file added on %s',dateStr);
    filename = sprintf('%s\\%s', pathname, filename);
    
    if newfileB == 1
        fid = fopen(filename, 'w');
        fprintf(fid, '%s\n', dateStr);
        folder_name = uigetdir(studyDir, 'choose a folder to save strain results');
        if  isequal(folder_name,0)
             disp('User selected Cancel to save strain result'); 
             disp('Using the patient Dir');
             folder_name = studyDir;
        end
        fprintf(fid,'projectResultDir = ''%s'';\n',  folder_name);
        fprintf(fid, 'sampleN = 50;\n');
        fprintf(fid, '\n\n\n\n');
        
        fprintf(fid, 'patientIndex = 1;\n');
    else
        fid = fopen(filename, 'a');
        fprintf(fid, '\n\n\n\n');
        fprintf(fid, '%s\n', dateStr);
        fprintf(fid, 'patientIndex = patientIndex + 1;\n');
    end %%end newfileB
    
    fprintf(fid, 'patientConfigs(patientIndex,1).name =''%s'';\n', patientName);
    fprintf(fid, 'patientConfigs(patientIndex,1).dir(1,1).studyDir = ''%s'';\n', studyDir);
    fprintf(fid, 'patientConfigs(patientIndex,1).dirMidSA(1,1).ImgDir = ''%s'';\n',ImgDir);
    fprintf(fid, 'patientConfigs(patientIndex,1).studyName(1,1).studyName =''%s'';\n', studyName);
    fprintf(fid, 'patientConfigs(patientIndex,1).slicePosition(1,1).position =''%s'';\n', position);   
    fclose(fid);
end