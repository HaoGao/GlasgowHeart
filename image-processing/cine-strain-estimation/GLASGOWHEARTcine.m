function varargout = GLASGOWHEARTcine(varargin)
% GLASGOWHEARTCINE MATLAB code for GLASGOWHEARTcine.fig
%      GLASGOWHEARTCINE, by itself, creates a new GLASGOWHEARTCINE or raises the existing
%      singleton*.
%
%      H = GLASGOWHEARTCINE returns the handle to a new GLASGOWHEARTCINE or the handle to
%      the existing singleton*.
%
%      GLASGOWHEARTCINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLASGOWHEARTCINE.M with the given input arguments.
%
%      GLASGOWHEARTCINE('Property','Value',...) creates a new GLASGOWHEARTCINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GLASGOWHEARTcine_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GLASGOWHEARTcine_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GLASGOWHEARTcine

% Last Modified by GUIDE v2.5 18-Mar-2015 11:06:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLASGOWHEARTcine_OpeningFcn, ...
                   'gui_OutputFcn',  @GLASGOWHEARTcine_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GLASGOWHEARTcine is made visible.
function GLASGOWHEARTcine_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLASGOWHEARTcine (see VARARGIN)

% Choose default command line output for GLASGOWHEARTcine
handles.output = hObject;

%%%it is better to save workingDir in the handles, therefore it will always
%%%can go back to the working directory
workingDir = pwd();
handles.workingDir = workingDir;
cineStrainPathsConfig; %%%this will moved to the related project menu
%%%later, since it may conflict with others, because of function name, et
%%%al

%%%set up a figure window without menu and closing function 
scrsz = get(0,'ScreenSize');
width = scrsz(3)/2;
height = scrsz(4)/2;
hWindowSize = [scrsz(3)*0.2 scrsz(4)*0.2 width height];
hWindow = figure('Position',hWindowSize);
set(hWindow, 'CloseRequestFcn', '');
handles.hWindow = hWindow;
handles.hWindowSize = hWindowSize;

%%%middle slice 
handles.MiddleSliceB = 1;

%%%output to a new batch file
%%handles.newBachFile 
%%handles.existedBachFile


% Update handles structure
guidata(hObject, handles);
clc;

% UIWAIT makes GLASGOWHEARTcine wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GLASGOWHEARTcine_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_patient_study.
function popupmenu_patient_study_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_patient_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_patient_study contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_patient_study
selectedNo = get(hObject,'Value');
%%%the first one is a blank, therefore the real study ID is the selectdNo-1
selectedNo = selectedNo -1 ;

patientConfigs = handles.patientConfigs;
[patient_config_selected, patientName, studyName]= patientSelectionUsingNo(patientConfigs, selectedNo);

%%%creat the resultDir for saving result 
resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
if ~exist(resultDir, 'dir')
    mkdir(resultDir);
    patient_slice_data = loadPatientDataForOneSlice(patient_config_selected);
    cd(resultDir);
    save patient_slice_data patient_slice_data;
    cd(handles.workingDir);
else
    button = questdlg('Do you want to keep existed folder');
    if strcmp(button, 'No')%%%delete all files inside the folder
        cd(resultDir);
        delete('*.mat');
        delete('*.txt');
        delete('*.png');
        cd(handles.workingDir);
       %%%reload the image data
        patient_slice_data = loadPatientDataForOneSlice(patient_config_selected);
        cd(resultDir);
        save patient_slice_data patient_slice_data;
        cd(handles.workingDir);
    else
        cd(resultDir);
        fileExistedB = exist('patient_slice_data.mat', 'file');
        cd(handles.workingDir);
        if fileExistedB
            cd(resultDir);
            load patient_slice_data;
            cd(handles.workingDir);
        else
            msgbox('the patient data has not been loaded, loading now!');
            cd(handles.workingDir);
            patient_slice_data = loadPatientDataForOneSlice(patient_config_selected);
            cd(resultDir);
            save patient_slice_data patient_slice_data;
            cd(handles.workingDir);
        end
    end
        
end

handles.patient_config_selected = patient_config_selected;
%handles.patient_slice_data = patient_slice_data; % to save the memorry
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_patient_study_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_patient_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_crop_image.
function pushbutton_crop_image_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_crop_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%creat the resultDir for saving result 
patient_config_selected = handles.patient_config_selected;
patientName = patient_config_selected.patientName;
studyName = patient_config_selected.studyName;
resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;
cd(resultDir);
if ~exist('patient_slice_data.mat', 'file');
    errordlg('patient slice has not been loaded!', 'File Error');
else
    load patient_slice_data;
end
cd(workingDir);

totalInstanceNum = size(patient_slice_data.SXSlice,1); 

%%crop the images 

imSelectedIndex = 1;
imData = patient_slice_data.SXSlice(imSelectedIndex,1).imData;
        % patient_slice_data.SXSlice(imSelectedIndex,1).imData
        %%%now crop the image 

cd(resultDir);
fileExisted = exist('cropConfig.mat', 'file');
cd(workingDir);
if fileExisted
    button = questdlg('would you like to load the previous crop configuration');
    if strcmp(button, 'Yes')
        cd(resultDir);
        load cropConfig;
        cd(workingDir);
%         figure 
    else
        cropConfig = cropImagHG(imData);
        cd(resultDir);
        save cropConfig cropConfig;
        cd(workingDir);
    end
else
    cropConfig = cropImagHG(imData);
    cd(resultDir);
    save cropConfig cropConfig;
    cd(workingDir);
end


cd(resultDir);
load cropConfig;
cd(workingDir);


%%update the handles
guidata(hObject, handles);






% --- Executes on button press in pushbutton_segmentation.
function pushbutton_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% this fuction will segment the LV wall
%%%decide whethere to run this part
if isfield(handles, 'projectSpec')
    if strcmp(handles.projectSpec, 'cineSegLVModelling')
        msgbox('please use the segment function under LVModellingUsingCine if for LV reconstruction, this function will only be used for cine strain');
    end
end

    %%%creat the resultDir for saving result 
    patient_config_selected = handles.patient_config_selected;
    patientName = patient_config_selected.patientName;
    studyName = patient_config_selected.studyName;
    resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
    workingDir = handles.workingDir;
    loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
    loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;

    %%%segment the boundaries in the first image
    %%%if already existed, do we need to redo it again
    cd(resultDir);
    fileExisted = exist('EndoEpiBc.mat', 'file');
    cd(workingDir);

    imSelectedIndex = 1;
    imData = patient_slice_data.SXSlice(imSelectedIndex,1).imData;
    if fileExisted == 0
                [endoT epiT] = manualSegEndoEpi(imcrop(imData, cropConfig.rect), handles.sampleN);
                cd(resultDir);
                EndoEpiBc.endo = endoT;
                EndoEpiBc.epi = epiT;
                save EndoEpiBc EndoEpiBc;
                cd(workingDir);
    else
        button = questdlg('would you like to load the previous segmentation');
        if strcmp(button, 'Yes')
            cd(resultDir);
            load EndoEpiBc;
            cd(workingDir);
    %         figure 
        else
            [endoT epiT] = manualSegEndoEpi(imcrop(imData, cropConfig.rect), handles.sampleN);
            EndoEpiBc.endo = endoT;
            EndoEpiBc.epi = epiT;
            cd(resultDir);
            save EndoEpiBc EndoEpiBc;
            cd(workingDir);
        end

    end

    %%%do we need to show all the images or not
    %%%currently leave it

    %%%mesh generation
    [LVMesh LVPoints] = EndoEpiMeshGeneration(EndoEpiBc.endo,EndoEpiBc.epi,handles.sampleN);
    hmesh = handles.hWindow; 
    figure(hmesh);
    imshow(imcrop(imData,cropConfig.rect),[]); hold on;
    LVMeshShow(LVPoints,LVMesh,hmesh); 
    set(hmesh, 'Position', handles.hWindowSize);
    hold off;
    LVPointsTotalPhases(1).LVPoints = LVPoints;
    LVPointsTotalPhases(1).LVMesh = LVMesh;
    LVPointsTotalPhases(1).shapex = mean(EndoEpiBc.endo(:,1));
    LVPointsTotalPhases(1).shapey = mean(EndoEpiBc.endo(:,2));
    cd(resultDir);
    save LVPointsTotalPhases LVPointsTotalPhases ;
    cd(workingDir);


guidata(hObject, handles);


% --- Executes on button press in pushbutton_aha_definition.
function pushbutton_aha_definition_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_aha_definition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%creat the resultDir for saving result 
patient_config_selected = handles.patient_config_selected;
patientName = patient_config_selected.patientName;
studyName = patient_config_selected.studyName;
slicePosition = patient_config_selected.slicePosition;
resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;

%%decide whethere in the middle slice 
MiddleSliceB = handles.MiddleSliceB;
if strcmp(slicePosition, 'SA_Apex')
    MiddleSliceB = 0;
end
handles.MiddleSliceB = MiddleSliceB; %%after AHA defintion, the Slice position will be properly set up

loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;
loadedData = loadMatFiles(resultDir, 'EndoEpiBc'); EndoEpiBc = loadedData.EndoEpiBc;
clear loadedData;

%%%segment the boundaries in the first image
%%%if already existed, do we need to redo it again
cd(resultDir);
fileExisted = exist('DivisionConfig.mat', 'file');
cd(workingDir);

imSelectedIndex = 1;
imData = patient_slice_data.SXSlice(imSelectedIndex,1).imData;
if fileExisted == 0
            [MidConfig, ApexConfig] = AHADefinitionManual(imData, MiddleSliceB);
            DivisionConfig.MidConfig = MidConfig;
            DivisionConfig.ApexConfig = ApexConfig;
            cd(resultDir);
            save DivisionConfig DivisionConfig ;
            cd(workingDir);
else
    button = questdlg('would you like to load the previous AHA division');
    if strcmp(button, 'Yes')
        cd(resultDir);
        load DivisionConfig;
        cd(workingDir);
%         figure 
    else
        [MidConfig, ApexConfig] = AHADefinitionManual(imData, MiddleSliceB);
        DivisionConfig.MidConfig = MidConfig;
        DivisionConfig.ApexConfig = ApexConfig;
        cd(resultDir);
        save DivisionConfig DivisionConfig ;
        cd(workingDir);
    end
    
end

guidata(hObject, handles);



% --- Executes on button press in pushbutton_add_to_new_bach.
function pushbutton_add_to_new_bach_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_to_new_bach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

patient_config_selected = handles.patient_config_selected;
patientName = patient_config_selected.patientName;
studyName = patient_config_selected.studyName;
resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;
MiddleSliceB = handles.MiddleSliceB;
loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;
loadedData = loadMatFiles(resultDir, 'EndoEpiBc'); EndoEpiBc = loadedData.EndoEpiBc;
loadedData = loadMatFiles(resultDir, 'LVPointsTotalPhases'); LVPointsTotalPhases = loadedData.LVPointsTotalPhases;
loadedData = loadMatFiles(resultDir, 'DivisionConfig'); DivisionConfig = loadedData.DivisionConfig;
clear loadedData;


if isempty(patient_slice_data) || isempty(cropConfig) || isempty(EndoEpiBc) || ...
        isempty(LVPointsTotalPhases) || isempty(DivisionConfig)
   errordlg('preprocessing has not finished, please check!', 'File Error');
else    
%     handles.newBachFile
    newBachFileExisted = isfield(handles, 'newBachFile');
    if ~newBachFileExisted
        [FileNameT,PathNameT,~] = uiputfile('*.txt', 'Choosing a bachfile to save'); 
%        newBachFilename = inputdlg('Please specify a bach file name, other wise it will be newBachFile.txt','bach file generation',1);
       newBachFileName = sprintf('%s\\%s',PathNameT, FileNameT);
       if isempty(newBachFileName)
          newBachFileName = sprintf('%s\\%s',handles.projectResultDir, 'newBachFile.txt');
       end
%        cd(handles.projectConfigDir);
       fid_newBachFile = fopen(newBachFileName, 'w');
       handles.newBachFile = newBachFileName;
%        cd(workingDir);
       fprintf(fid_newBachFile, '%s\n', patientName);
       fprintf(fid_newBachFile, '%s\n', studyName);
       fclose(fid_newBachFile);
    else
%         cd(handles.projectConfigDir);
        fid_newBachFile_readOnly = fopen(handles.newBachFile, 'r');
%         cd(workingDir);
        BExisted = IsPatientAlreadyExisted(fid_newBachFile_readOnly, patientName, studyName);
        fclose(fid_newBachFile_readOnly);
        if ~BExisted
%             cd(handles.projectConfigDir);
            fid_newBachFile = fopen(handles.newBachFile, 'a');
%             cd(workingDir);
            fprintf(fid_newBachFile, '%s\n', patientName);
            fprintf(fid_newBachFile, '%s\n', studyName);
            fclose(fid_newBachFile);
        else
            msgbox('already added','waring', 'warn'); 
        end
        
    end
    
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton_add_to_existed_bach.
function pushbutton_add_to_existed_bach_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_to_existed_bach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
patient_config_selected = handles.patient_config_selected;
patientName = patient_config_selected.patientName;
studyName = patient_config_selected.studyName;
resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;
MiddleSliceB = handles.MiddleSliceB;
loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;
loadedData = loadMatFiles(resultDir, 'EndoEpiBc'); EndoEpiBc = loadedData.EndoEpiBc;
loadedData = loadMatFiles(resultDir, 'LVPointsTotalPhases'); LVPointsTotalPhases = loadedData.LVPointsTotalPhases;
loadedData = loadMatFiles(resultDir, 'DivisionConfig'); DivisionConfig = loadedData.DivisionConfig;
clear loadedData;


if isempty(patient_slice_data) || isempty(cropConfig) || isempty(EndoEpiBc) || ...
        isempty(LVPointsTotalPhases) || isempty(DivisionConfig)
   errordlg('preprocessing has not finished, please check!', 'File Error');
else    

    existedBachFileExisted = isfield(handles, 'existedBachFile');
    if ~existedBachFileExisted
        [FileNameT,PathNameT,~] = uiputfile('*.txt', 'Choosing an existed bachfile to save');
         existedBachFileName = sprintf('%s\\%s',PathNameT, FileNameT);
       if isempty(existedBachFileName)
          errordlg('bach file has not been selected!', 'File Error');
       end
%        cd(handles.projectConfigDir);
       handles.existedBachFile = existedBachFileName;
    end
        %%%check whether this patient has been added or not
        fid_existedBachFile_readOnly = fopen(handles.existedBachFile, 'r');
        BExisted = IsPatientAlreadyExisted(fid_existedBachFile_readOnly, patientName, studyName);
        fclose(fid_existedBachFile_readOnly);

        if ~BExisted
%             cd(handles.projectConfigDir);
            fid_existedBachFile = fopen(handles.existedBachFile, 'a');
%             cd(workingDir);
            fprintf(fid_existedBachFile, '%s\n', patientName);
            fprintf(fid_existedBachFile, '%s\n', studyName);
            fclose(fid_existedBachFile);
            msgstr = sprintf('%s %s added', patientName, studyName);
            msgbox(msgstr);
        else
            msgbox('already added','waring', 'warn'); 
        end 
  
        
end
    

guidata(hObject, handles);




% --- Executes on button press in pushbutton_check_for_ready.
function pushbutton_check_for_ready_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_check_for_ready (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CineStrainMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CineStrainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenProject_CineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenProject_CineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% a open dlg to choose the file
[FileName,PathName,~] = uigetfile('*.m', 'Choose the project config m file', ....
    'PilotMiddleSAStrain20Subjects.m');
%%get rid of the '.m'
FileName = FileName(1:end-2);
handles.projectConfigName = FileName;
handles.projectConfigDir = PathName; 

%%%now need to load the config data
cd(PathName);
run(FileName);
cd(handles.workingDir);
handles.patientConfigs = patientConfigs;
handles.projectResultDir = projectResultDir;
handles.sampleN = sampleN;

%%%set up the popup menu data
totalPatientNo = size(patientConfigs,1);
studyListIndex = 1;
sessionStr = 'select patient study';
studyLsitStr(studyListIndex,1) = cellstr(sessionStr);
for patientIndex = 1 : totalPatientNo
    patientT = patientConfigs(patientIndex,1);
    patientName = patientT.name;
    
    totalStudyNo = size(patientT.studyName,1);
    for studyIndex = 1 : totalStudyNo
        studyName = patientT.studyName(studyIndex,1).studyName;
        sessionStr = sprintf('%s_%s', patientName, studyName);
        studyListIndex = studyListIndex + 1;
        studyListStr(studyListIndex,1) = cellstr(sessionStr);
    end     
end

%%%now we can set up the popup menu context
set(handles.popupmenu_patient_study, 'string', studyListStr);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function OpenPatient_CineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenPatient_CineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenStudy_CineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenStudy_CineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenSAOneSlice_CineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenSAOneSlice_CineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OpenSAOneSlice_CineStrain_menu_Callback_implementation(handles);


% --------------------------------------------------------------------
function OpenOneDicom_CineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenOneDicom_CineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkSelectedData_cineStrain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to checkSelectedData_cineStrain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_apical_slice.
function radiobutton_apical_slice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_apical_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_apical_slice
%BApicalSlice = get(hObject, 'Value');
%if BApicalSlice 
%    handles.MiddleSliceB = 0;
%else
%    handles.MiddleSliceB = 1;
%end

guidata(hObject, handles);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.hWindow);
% Hint: delete(hObject) closes the figure
delete(hObject);


% --------------------------------------------------------------------
function RunBachFile_menu_Callback(hObject, eventdata, handles)
% hObject    handle to RunBachFile_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% patient_config_selected = handles.patient_config_selected;
% patientName = patient_config_selected.patientName;
% studyName = patient_config_selected.studyName;
% resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;
MiddleSliceB = handles.MiddleSliceB;
% loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
% loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;
% loadedData = loadMatFiles(resultDir, 'EndoEpiBc'); EndoEpiBc = loadedData.EndoEpiBc;
% loadedData = loadMatFiles(resultDir, 'LVPointsTotalPhases'); LVPointsTotalPhases = loadedData.LVPointsTotalPhases;
% loadedData = loadMatFiles(resultDir, 'DivisionConfig'); DivisionConfig = loadedData.DivisionConfig;
% clear loadedData;

%%%load the bachfile
cd(handles.projectConfigDir);
[FileName, PathName, ~] = uigetfile('*.txt');
cd(workingDir);

%%%build up the patient study names
cd(PathName);
fid_readOnly = fopen(FileName, 'r');
cd(workingDir);

patientIndex = 1;
while ~feof(fid_readOnly)
     tline = fgetl(fid_readOnly);
     patientNameList(patientIndex,1).name = tline;
     tline = fgetl(fid_readOnly);
     studyNameList(patientIndex,1).name = tline;
     patientIndex = patientIndex + 1;
end

%%%%next call the runnings
totalPatientNo = size(patientNameList,1);
totalStudyNo = size(studyNameList,1);

for patientIndex = 1 : totalPatientNo
    %%%this is for each patient, which can be looped through all the 
    patientName = patientNameList(patientIndex,1).name;
    %for studyIndex = 1 : totalStudyNo
        studyName = studyNameList(patientIndex,1).name; %%%study name has been expanded, no need to iterate
        resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);

        
        %%%%load the results
        if ~exist(resultDir, 'dir')
            errorstr = sprintf('not preprocessed for %s study:  %s ', patientName, studyName);
            error(errorstr);
        end
        
        cd(resultDir);
        if exist('patient_slice_data.mat', 'file')
            load patient_slice_data;
        else
            error('patient slice data is not saved!');
        end
        
        if exist('cropConfig.mat', 'file')
            load cropConfig;
        else
            error('cropConfig is not saved!');
        end
        
        
        if exist('DivisionConfig.mat', 'file')
            load DivisionConfig;
            if isempty(DivisionConfig.ApexConfig.SeptTheta) %%%for each ...
                %%slice there will be only one AHA definition, either in Apex or non Apex
                MiddleSliceB = 1;
            else
                MiddleSliceB = 0;
            end
        else
            error('DivisionConfig is not saved!');
        end
        
        if exist('EndoEpiBc.mat', 'file')
            load EndoEpiBc;
        else
            error('EndoEpiBc is not saved!');
        end
        
        if exist('LVPointsTotalPhases.mat', 'file')
            load LVPointsTotalPhases;
        else
            error('LVPointsTotalPhases not found')
        end
        
        bsplineDeformBool = 1;
%         if exist('imgDeformedBsplineRe.mat', 'file')
%             %%now nead to check the rect is the same as one in the folder 
%             load imgDeformedBsplineRe;
%             button = questdlg('do you want to load the previous one','existed result','yes');
%             if strcmp(button, 'Yes')
%                 NewCroppedB = 0; 
%                 for i = 1 : 4 
%                     if imgDeformedBsplineRe(1,1).rect(i) ~= cropConfig.rect(i)
%                         NewCroppedB = 1;
%                     end
%                 end
%                 if NewCroppedB 
%                     bsplineDeformBool = 1;
%                     msgbox('the crop rect is different from the saved result, need to be recompute!')
%                 else
%                     bsplineDeformBool = 0;
%                     msgbox('using previous deformed result')
%                 end
%            end
%             
%         end
        
        cd(workingDir);
        
        
        %%%checking done
        if bsplineDeformBool == 1
            disp('deforming the image');
        else
            disp('load the previous one');
        end
        
        %%%deforming the images 
        imgDeformedBsplineRe = BSplineDeformCall(patient_slice_data, cropConfig, resultDir, bsplineDeformBool);
        %%%tracking the LV meshes and strain
        [LVStrainTotal, LVPointsTotalPhases] = LVMeshDeformed(patient_slice_data, imgDeformedBsplineRe, EndoEpiBc, LVPointsTotalPhases);

        %%%strain calculation 
        regionalStrainCalculationOutput(resultDir, LVStrainTotal, LVPointsTotalPhases, ... 
                                     patient_slice_data, cropConfig, DivisionConfig, MiddleSliceB);
        
        
        
        
    %end
end

% --------------------------------------------------------------------
function Plot_Regional_Circ_Strain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Regional_Circ_Strain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Plot_regional_rad_strain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_regional_rad_strain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CineSegForLVModelling_menu_Callback(hObject, eventdata, handles)
% hObject    handle to CineSegForLVModelling_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LVModelling_LoadProjectFile_menu_Callback(hObject, eventdata, handles)
% hObject    handle to LVModelling_LoadProjectFile_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,~] = uigetfile('*.m', 'Choose the project config m file', ....
    '*.m');
%%get rid of the '.m'
FileName = FileName(1:end-2);
handles.projectConfigName = FileName;
handles.projectConfigDir = PathName; 
handles.projectSpec = 'cineSegLVModelling';

%%%now need to load the config data
cd(PathName);
run(FileName);
cd(handles.workingDir);
handles.patientConfigs = patientConfigs;
handles.projectResultDir = projectResultDir;
handles.sampleN = sampleN;

%%%set up the popup menu data
totalPatientNo = size(patientConfigs,1);
studyListIndex = 1;
sessionStr = 'select patient study';
studyLsitStr(studyListIndex,1) = cellstr(sessionStr);
for patientIndex = 1 : totalPatientNo
    patientT = patientConfigs(patientIndex,1);
    patientName = patientT.name;
    
    totalStudyNo = size(patientT.studyName,1);
    for studyIndex = 1 : totalStudyNo
        studyName = patientT.studyName(studyIndex,1).studyName;
        sessionStr = sprintf('%s_%s', patientName, studyName);
        studyListIndex = studyListIndex + 1;
        studyListStr(studyListIndex,1) = cellstr(sessionStr);
    end     
end

%%%%now we need to load all the images into SXSlice and LVOTSlice, and
        %%%%sorted them out
        %%%%for short axis images, it will be saved in 
 SASlicePosition = 0;
 LVOTSlicePosition = 0;
 for patientIndex = 1 : totalPatientNo
       patientT = patientConfigs(patientIndex,1);
       patientName = patientT.name;
    
       totalStudyNo = size(patientT.studyName,1);
       for studyIndex = 1 : totalStudyNo
          studyName_sel = patientConfigs(patientIndex,1).studyName(studyIndex,1).studyName;
          studyDir_sel = patientConfigs(patientIndex,1).dir(studyIndex,1).studyDir;
          ImgDir_sel = patientConfigs(patientIndex,1).dirMidSA(studyIndex,1).ImgDir;
          spec_sel = patientConfigs(patientIndex,1).SliceSpec(studyIndex,1).spec;
        
       %%%now decide it is SA or LA, or LAG   
          if strcmp(spec_sel, 'SAcine')
             %%%load the image into SASlice 
              SASlicePosition = SASlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              SXSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              SXSlice(SASlicePosition).SXSlice= SXSliceT;
              imDesired.SXSlice = SXSlice;
              imDesired.TimeEndOfSystole = PatientT.TimeEndOfSystole;
              imDesired.TimeEndOfDiastole = PatientT.TimeEndOfDiastole;
              imDesired.TimeEarlyOfDiastole = PatientT.TimeEarlyOfDiastole;
          elseif  strcmp(spec_sel, 'LAcine_LVOT')
              LVOTSlicePosition = LVOTSlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              LVOTSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              LVOTSlice(LVOTSlicePosition).LVOTSlice= LVOTSliceT;
              imDesired.LVOTSlice = LVOTSlice;
              
          end
          
       end
       
       %%%save all the data to the folder for this patient
        resultDir = sprintf('%s\\%s', projectResultDir, patientName);
        if ~exist(resultDir, 'dir')
            mkdir(resultDir);
            cd(resultDir);
            save imDesired imDesired;
            cd(handles.workingDir);
        else
           cd(resultDir);
           save imDesired imDesired;
           cd(handles.workingDir);
        end
 end
 


%%%now we can set up the popup menu context
set(handles.popupmenu_patient_study, 'string', studyListStr);
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function SASegmentation_menu_Callback(hObject, eventdata, handles)
% hObject    handle to SASegmentation_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
projectResultDir = handles.projectResultDir;
sampleN = handles.sampleN;
patientConfigs = handles.patientConfigs;
totalPatientNo = size(patientConfigs,1);
workingDir = handles.workingDir;
for patientIndex = 1 : totalPatientNo
       patientT = patientConfigs(patientIndex,1);
       patientName = patientT.name;
       resultDir = sprintf('%s\\%s', projectResultDir, patientName);
       
       %%%do the segmentation 
end
       



% --------------------------------------------------------------------
function LASegmentation_LVModelling_menu_Callback(hObject, eventdata, handles)
% hObject    handle to LASegmentation_LVModelling_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function StrainMapCalculation_menu_Callback(hObject, eventdata, handles)
% hObject    handle to StrainMapCalculation_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% patient_config_selected = handles.patient_config_selected;
% patientName = patient_config_selected.patientName;
% studyName = patient_config_selected.studyName;
% resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
workingDir = handles.workingDir;
% loadedData = loadMatFiles(resultDir, 'patient_slice_data'); patient_slice_data = loadedData.patient_slice_data;
% loadedData = loadMatFiles(resultDir, 'cropConfig'); cropConfig = loadedData.cropConfig;
% loadedData = loadMatFiles(resultDir, 'EndoEpiBc'); EndoEpiBc = loadedData.EndoEpiBc;
% loadedData = loadMatFiles(resultDir, 'LVPointsTotalPhases'); LVPointsTotalPhases = loadedData.LVPointsTotalPhases;
% loadedData = loadMatFiles(resultDir, 'DivisionConfig'); DivisionConfig = loadedData.DivisionConfig;
% clear loadedData;

%%%load the bachfile
cd(handles.projectConfigDir);
[FileName, PathName, ~] = uigetfile('*.txt');
cd(workingDir);

%%%build up the patient study names
cd(PathName);
fid_readOnly = fopen(FileName, 'r');
cd(workingDir);

patientIndex = 1;
while ~feof(fid_readOnly)
     tline = fgetl(fid_readOnly);
     patientNameList(patientIndex,1).name = tline;
     tline = fgetl(fid_readOnly);
     studyNameList(patientIndex,1).name = tline;
     patientIndex = patientIndex + 1;
end

%%%%next call the runnings
totalPatientNo = size(patientNameList,1);
totalStudyNo = size(studyNameList,1);

for patientIndex = 1 : totalPatientNo
    %%%this is for each patient, which can be looped through all the 
    patientName = patientNameList(patientIndex,1).name;
    %for studyIndex = 1 : totalStudyNo
        studyName = studyNameList(patientIndex,1).name; %%%study name has been expanded, no need to iterate
        resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
        resultDirStrainMapOutput = sprintf('%s\\%s\\%s\\strainMaps', handles.projectResultDir, patientName, studyName);
        if ~exist(resultDirStrainMapOutput, 'dir')
            mkdir(resultDirStrainMapOutput);
        end
        %%%%load the results
        if ~exist(resultDir, 'dir')
            errorstr = sprintf('not preprocessed for %s study:  %s ', patientName, studyName);
            error(errorstr);
        end
        
        cd(resultDir);
        if exist('patient_slice_data.mat', 'file')
            load patient_slice_data;
        else
            error('patient slice data is not saved!');
        end
        
        if exist('cropConfig.mat', 'file')
            load cropConfig;
        else
            error('cropConfig is not saved!');
        end
         
        if exist('DivisionConfig.mat', 'file')
            load DivisionConfig;
            if isempty(DivisionConfig.ApexConfig.SeptTheta) %%%for each ...
                %%slice there will be only one AHA definition, either in Apex or non Apex
                MiddleSliceB = 1;
            else
                MiddleSliceB = 0;
            end
        else
            error('DivisionConfig is not saved!');
        end
        
        if exist('EndoEpiBc.mat', 'file')
            load EndoEpiBc; %%%it is in the croped image
        else
            error('EndoEpiBc is not saved!');
        end
        
        if exist('LVPointsTotalPhases.mat', 'file')
            load LVPointsTotalPhases;
        else
            error('LVPointsTotalPhases not found')
        end
        

        if exist('imgDeformedBsplineRe.mat', 'file')
            load imgDeformedBsplineRe;
        else
            error('imgDeformedBsplineRe not found')
        end
        cd(workingDir);
        

        I1 = patient_slice_data.SXSlice(1,1).imData;
        I1 = imcrop(I1, cropConfig.rect);
        LVRoi = roipoly(I1,EndoEpiBc.epi(:,1),EndoEpiBc.epi(:,2))-roipoly(I1,EndoEpiBc.endo(:,1),EndoEpiBc.endo(:,2));
        shapex = mean(EndoEpiBc.endo(:,1));
        shapey = mean(EndoEpiBc.endo(:,2));
        Tx = zeros(size(LVRoi));
        Ty = zeros(size(LVRoi));
        Displace(1).Tx = Tx;
        Displace(1).Ty = Ty;
        
        mapij = [];
        for i = 1 : size(LVRoi,1)
            for j = 1 : size(LVRoi,2)
                mapij(i,j).i = i;
                mapij(i,j).j = j;
            end
        end
        
        
        totalInstanceNum = size(patient_slice_data.SXSlice,1); 
        
        for imIndex = 1 : totalInstanceNum-1
            Tx = imgDeformedBsplineRe(imIndex,1).Tx;
            Ty = imgDeformedBsplineRe(imIndex,1).Ty;
            for i = 1 : size(LVRoi,1)
                for j = 1 : size(LVRoi,2)
                    PreI = mapij(i,j).i;
                    PreJ = mapij(i,j).j;

                    if floor(PreI)<=2
                        rPreI = 2;
                    elseif floor(PreI)>=size(LVRoi,1)-1
                        rPreI = size(LVRoi,1)-1;
                    else
                        rPreI = floor(PreI);
                    end

                    if floor(PreJ)<=2 
                        rPreJ = 2;
                    elseif floor(PreJ)>size(LVRoi,2)-1
                        rPreJ = size(LVRoi,2)-1;
                    else
                        rPreJ = floor(PreJ);
                    end    
                    
                    
                    I0 = rPreI;
                    I1 = I0+1;
               
                    J0 = rPreJ;
                    J1 = J0+1;
                    
%                     [X,Y] = meshgrid(0:1:1);
%                     Zx = [Tx(I0,J0)  Tx(I0+1,J0);
%                           Tx(I0,J0+1) Tx(I0+1,J0+1)];
%                     dx = interp2(X,Y,Zx,rPreI-I0,rPreJ-J0);
%                     
%                     Zy = [Ty(I0,J0)  Ty(I0+1,J0);
%                           Ty(I0,J0+1) Ty(I0+1,J0+1)];
%                     dy = interp2(X,Y,Zy,rPreI-I0,rPreJ-J0);
%                     
%                     NowI = PreI - dx;
%                     NowJ = PreJ - dy;
                    
                    dI = rPreI - I0; dI = 2*dI -1;
                    dJ = rPreJ - J0; dJ = 2*dJ - 1;
                    
                    %%%using linear interpolation
                   fij  =   1/4.0*(1-dI)*(1-dJ);
                   fi1j =   1/4.0*(1+dI)*(1-dJ);
                   fi1j1 =  1/4.0*(1+dI)*(1+dJ);
                   fij1  =  1/4.0*(1-dI)*(1+dJ);
                   
                   dI_interp = fij*Tx(I0,J0)+fi1j*Tx(I1,J0) + fi1j1*Tx(I1,J1) + fij1*Tx(I0,J1);
                   dJ_interp = fij*Ty(I0,J0)+fi1j*Ty(I1,J0) + fi1j1*Ty(I1,J1) + fij1*Ty(I0,J1);
                   
                   NowI = PreI - dI_interp;
                   NowJ = PreJ - dJ_interp;
%                     NowI = PreI - Tx(rPreI, rPreJ);
%                     NowJ = PreJ - Ty(rPreI, rPreJ);

                    
                    %Displace(imIndex+1).Tx(i,j)=Displace(imIndex).Tx(i,j)+Tx(rPreI, rPreJ);
                    %Displace(imIndex+1).Ty(i,j)=Displace(imIndex).Ty(i,j)+Ty(rPreI, rPreJ);
                    Displace(imIndex+1).Tx(i,j)=Displace(imIndex).Tx(i,j)+dI_interp;
                    Displace(imIndex+1).Ty(i,j)=Displace(imIndex).Ty(i,j)+dJ_interp;
                
                    mapijN(i,j).i = NowI;
                    mapijN(i,j).j = NowJ;
                end
            end
            mapij = mapijN;
            [CirStrainLV, RadStrainLV]=strianCalculaton(Displace(imIndex+1).Tx,Displace(imIndex+1).Ty,LVRoi,shapex,shapey); 
            StrainMap(imIndex).CirStrainLV = CirStrainLV;
            StrainMap(imIndex).RadStrainLV = RadStrainLV;
            
            
                h1= figure('Visible', 'off');hold on;
                imshow(StrainMap(imIndex).CirStrainLV,[]);hold on;
                colormap('jet')
                caxis([-0.3 0.1]);
                colorbar;
                axis 'tight'
                contour(LVRoi,[0 0], 'Color','k');
                
                % h= imshow(I1OG,[]);
                % hold off;
                % alpha_data = LVRoi;
                % set(h,'AlphaData',alpha_data);
                h2= figure('Visible', 'off');hold on;
                imshow(StrainMap(imIndex).RadStrainLV,[]);hold on;
                colormap('jet')
                caxis([-0.1 0.4]);
                colorbar;
                axis 'tight'
                contour(LVRoi,[0 0], 'Color','k');
                
                cd(resultDirStrainMapOutput);
                fileName = sprintf('cirStrainSlice_%d', imIndex);
                print(h1, fileName, '-dpng');
                fileName = sprintf('radStrainSlice_%d', imIndex);
                print(h2, fileName, '-dpng');
                cd(workingDir);
                
                close(h1);
                close(h2);
                
                str_msg = sprintf('output strain map %s %s slice_%d', patientName, studyName, imIndex);
                disp(str_msg);
            
            
        end
        
        cd(resultDir)
        save StrainMap StrainMap;
        cd(workingDir);
        
        
        disp('strain map output finished');
        
end
