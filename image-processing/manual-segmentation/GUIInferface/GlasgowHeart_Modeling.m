function varargout = GlasgowHeart_Modeling(varargin)
% GLASGOWHEART_MODELING MATLAB code for GlasgowHeart_Modeling.fig
%      GLASGOWHEART_MODELING, by itself, creates a new GLASGOWHEART_MODELING or raises the existing
%      singleton*.
%
%      H = GLASGOWHEART_MODELING returns the handle to a new GLASGOWHEART_MODELING or the handle to
%      the existing singleton*.
%
%      GLASGOWHEART_MODELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLASGOWHEART_MODELING.M with the given input arguments.
%
%      GLASGOWHEART_MODELING('Property','Value',...) creates a new GLASGOWHEART_MODELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GlasgowHeart_Modeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GlasgowHeart_Modeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GlasgowHeart_Modeling

% Last Modified by GUIDE v2.5 17-Jan-2019 23:32:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GlasgowHeart_Modeling_OpeningFcn, ...
                   'gui_OutputFcn',  @GlasgowHeart_Modeling_OutputFcn, ...
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


% --- Executes just before GlasgowHeart_Modeling is made visible.
function GlasgowHeart_Modeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GlasgowHeart_Modeling (see VARARGIN)

% Choose default command line output for GlasgowHeart_Modeling
handles.output = hObject;

%%%it is better to save workingDir in the handles, therefore it will always
%%%can go back to the working directory
GUI_workingDir = pwd();
handles.workingDir = GUI_workingDir;


%Create tab group
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'left');
handles.tab_seg = uitab('Parent', handles.tgroup, 'Title', 'Sementation');
handles.tab_geo_fit = uitab('Parent', handles.tgroup, 'Title', 'Geometry Fitting');
handles.tab_strain_est = uitab('Parent', handles.tgroup, 'Title', 'Strain Estimation');
%Place panels into each tab
set(handles.P_seg,'Parent',handles.tab_seg)
set(handles.P_geo_fit,'Parent',handles.tab_geo_fit)
set(handles.P_strain_estimation,'Parent',handles.tab_strain_est)
%Reposition each panel to same location as panel 1
set(handles.P_geo_fit,'position',get(handles.P_seg,'position'));
set(handles.P_strain_estimation,'position',get(handles.P_seg,'position'));



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GlasgowHeart_Modeling wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GlasgowHeart_Modeling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_patient_Callback(hObject, eventdata, handles)
% hObject    handle to open_patient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_folder_Callback(hObject, eventdata, handles)
% hObject    handle to open_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
