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

% Last Modified by GUIDE v2.5 30-Jan-2015 00:24:59

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
% Update handles structure
guidata(hObject, handles);

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


% --- Executes on selection change in popumenu_patientName.
function popumenu_patientName_Callback(hObject, eventdata, handles)
% hObject    handle to popumenu_patientName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popumenu_patientName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popumenu_patientName

%%%it is popupmenu1

selected = get(hObject, 'Value');






% --- Executes during object creation, after setting all properties.
function popumenu_patientName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popumenu_patientName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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
function OpenProject_CineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to OpenProject_CineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% a open dlg to choose the file
[FileName,PathName,~] = uigetfile('*.m', 'Choose the project config m file', ....
    'PilotMiddleSAStrain20Subjects.m');
handles.projectConfigName = FileName;
handles.projectConfigDir = PathName; 

%%%now need to load the config data
cd(PathName);
run(FileName);
cd(handles.workingDir);
handles.patientConfigs = patientConfigs;

%%%set up the popup menu data
totalPatientNo = size(patientConfigs,1);
studyListIndex = 0;
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
set(handles.popumenu_patientName, 'string', studyListStr);


% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function OpenPatient_CineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to OpenPatient_CineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenStudy_CineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to OpenStudy_CineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenSAOneSlice_CineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to OpenSAOneSlice_CineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenOneDicom_CineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to OpenOneDicom_CineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkSelectedData_cineStrain_Callback(hObject, eventdata, handles)
% hObject    handle to checkSelectedData_cineStrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_cropImage.
function pushbutton_cropImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cropImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_segmentBC.
function pushbutton_segmentBC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_segmentBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_AHA.
function pushbutton_AHA_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_AHA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
