function varargout = SAAdjustmentBYLASeries(varargin)
% SAADJUSTMENTBYLASERIES MATLAB code for SAAdjustmentBYLASeries.fig
%      SAADJUSTMENTBYLASERIES, by itself, creates a new SAADJUSTMENTBYLASERIES or raises the existing
%      singleton*.
%
%      H = SAADJUSTMENTBYLASERIES returns the handle to a new SAADJUSTMENTBYLASERIES or the handle to
%      the existing singleton*.
%
%      SAADJUSTMENTBYLASERIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAADJUSTMENTBYLASERIES.M with the given input arguments.
% 
%      SAADJUSTMENTBYLASERIES('Property','Value',...) creates a new SAADJUSTMENTBYLASERIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAAdjustmentBYLASeries_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAAdjustmentBYLASeries_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAAdjustmentBYLASeries

% Last Modified by GUIDE v2.5 18-Sep-2013 16:48:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAAdjustmentBYLASeries_OpeningFcn, ...
                   'gui_OutputFcn',  @SAAdjustmentBYLASeries_OutputFcn, ...
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


% --- Executes just before SAAdjustmentBYLASeries is made visible.
function SAAdjustmentBYLASeries_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAAdjustmentBYLASeries (see VARARGIN)

% Choose default command line output for SAAdjustmentBYLASeries
clc;
handles.output = hObject;
LVWM_config;
% handles.dicomDir = dicomDir;
handles.resultDir = resultDir;
handles.workingDir = workingDir;

%%%load results
cd(resultDir);
load DataSegSA;
load imDesired;
cd(workingDir);

SXSliceSorted = imDesired.SXSlice;
LVOTSliceSorted = imDesired.LVOTSlice;

totalSXSliceLocation = size(SXSliceSorted, 2);
totalLVOTSliceLocation = size(LVOTSliceSorted,2);
TimeEndOfSystole = imDesired.TimeEndOfSystole; 
TimeEndOfDiastole = imDesired.TimeEndOfDiastole; 
TimeEarlyOfDiastole =  imDesired.TimeEarlyOfDiastole;


TimeInstanceSelected = patientConfigs.timeInstanceSelected;
% TimeInstanceSelected = TimeEndOfDiastole;
msgStr = sprintf('TimeInstanceSelected:  %d, please check', TimeInstanceSelected);
msgbox(msgStr, 'warning');

totalTimeInstance = size(SXSliceSorted(1,1).SXSlice,1);


%%%now figure out what others 
handles.totalSXSliceLocation = totalSXSliceLocation;
handles.usuableSXSlice = totalSXSliceLocation;
handles.apexSliceIndex = totalSXSliceLocation-2;
handles.SASlicePositionApex = totalSXSliceLocation;
handles.totalLVOTSliceLocation = totalLVOTSliceLocation;
handles.totalTimeInstance = totalTimeInstance;
handles.timeInstanceSelected = TimeInstanceSelected;
handles.timeInstanceSelectedSystole = TimeEndOfSystole;
handles.timeInstanceSelectedDiastile = TimeEndOfDiastole;
handles.sampleN = sampleN;
handles.SASliceDistance = 10; %%%will be updated later
handles.LASliceSelected = totalLVOTSliceLocation;

handles.SXSliceSorted = SXSliceSorted;
handles.DataSegSA = DataSegSA;
handles.DataSegSAOrig = DataSegSA;
handles.LVOTSliceSorted = LVOTSliceSorted;
handles.sliceNoToBeCorrected = [];
handles.figureSA = [];
handles.figureLA3D = [];
handles.imdataSA = [];
handles.imDataLA3D = [];
handles.infoSA = [];
handles.infoLA = [];
handles.crossPx = [];
handles.crossPy = [];
handles.crossVec = [];




%%% figure out the right LA data if using LVOT, 1Ch or 4CH
% LVOTSelected = 1;
prompt = {'1 for LVOT, 2 for 4CH, 3 for OneCH'};
dlg_title = 'choose logitudial view';
num_lines = 1;
def = {'1'};
LVOTSelected = inputdlg(prompt,dlg_title,num_lines,def);
LVOTSelected = str2num(LVOTSelected{1});

if LVOTSelected == 1
    handles.imDataLA  =  LVOTSliceSorted(1,totalLVOTSliceLocation).LVOTSlice(TimeInstanceSelected,1).imData;
    handles.imInfo1LA = LVOTSliceSorted(1,totalLVOTSliceLocation).LVOTSlice(TimeInstanceSelected,1).imInfo;
elseif LVOTSelected == 2
    handles.imDataLA  =  imDesired.FourCHSlice(1,totalLVOTSliceLocation).FourCHSlice(TimeInstanceSelected,1).imData;
    handles.imInfo1LA = imDesired.FourCHSlice(1,totalLVOTSliceLocation).FourCHSlice(TimeInstanceSelected,1).imInfo;
elseif LVOTSelected == 3 
    handles.imDataLA  =  imDesired.OneCHSlice(1,totalLVOTSliceLocation).OneCHSlice(TimeInstanceSelected,1).imData;
    handles.imInfo1LA = imDesired.OneCHSlice(1,totalLVOTSliceLocation).OneCHSlice(TimeInstanceSelected,1).imInfo;
end
    



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SAAdjustmentBYLASeries wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAAdjustmentBYLASeries_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in move_plus.
function move_plus_Callback(hObject, eventdata, handles)
% hObject    handle to move_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliceNoToBeCorrected = handles.sliceNoToBeCorrected;
SXSliceSorted = handles.SXSliceSorted;
timeInstanceSelected = handles.timeInstanceSelected;
DataSegSA = handles.DataSegSA;
DataSegSAOrig = handles.DataSegSAOrig;
endo_current = DataSegSA(sliceNoToBeCorrected).endo_c;
endo_orig = DataSegSAOrig(sliceNoToBeCorrected).endo_c;
epi_current = DataSegSA(sliceNoToBeCorrected).epi_c;

%%%move along the cutting plane
disVec = handles.crossVec;
endo_current(1,:) = endo_current(1,:) + disVec(1);
endo_current(2,:) = endo_current(2,:) + disVec(2);

epi_current(1,:) = epi_current(1,:) + disVec(1);
epi_current(2,:) = epi_current(2,:) + disVec(2);

imInfo = infoExtract(handles.infoSA);
endo_cReal = TransformCurvesFromImToRealSpace(endo_current,imInfo);
epi_cReal = TransformCurvesFromImToRealSpace(epi_current,imInfo);
%%update the result
DataSegSA(sliceNoToBeCorrected).endo_c = endo_current;
DataSegSA(sliceNoToBeCorrected).endo_cReal = endo_cReal;
DataSegSA(sliceNoToBeCorrected).epi_c = epi_current;
DataSegSA(sliceNoToBeCorrected).epi_cReal = epi_cReal;
handles.DataSegSA = DataSegSA;

figure(handles.figureSA); 
% clf(handles.figureSA);
% hold on;
imshow(handles.imdataSA,[]); hold on;
plot(endo_current(1,:),endo_current(2,:),'r-', 'LineWidth',2);
plot(epi_current(1,:),epi_current(2,:),'b-', 'LineWidth',2);
plot(endo_orig(1,:), endo_orig(2,:),'w-');

%%%%3D figure
figure(handles.figureLA3D);
DicomeRealDisplay(handles.figureLA3D, handles.imDataLA3D); hold on;
delete(handles.curve3Dh)
curve3Dh = plot3(endo_cReal(1,:),endo_cReal(2,:), endo_cReal(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
hold off
handles.curve3Dh = curve3Dh;
%%%update the whole structure
guidata(hObject, handles);

% --- Executes on button press in move_minus.
function move_minus_Callback(hObject, eventdata, handles)
% hObject    handle to move_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliceNoToBeCorrected = handles.sliceNoToBeCorrected;
DataSegSA = handles.DataSegSA;
DataSegSAOrig = handles.DataSegSA;
endo_current = DataSegSA(sliceNoToBeCorrected).endo_c;
endo_orig = DataSegSAOrig(sliceNoToBeCorrected).endo_c;
epi_current = DataSegSA(sliceNoToBeCorrected).epi_c;

%%%move along the cutting plane
disVec = handles.crossVec;
endo_current(1,:) = endo_current(1,:) - disVec(1);
endo_current(2,:) = endo_current(2,:) - disVec(2);

epi_current(1,:) = epi_current(1,:) - disVec(1);
epi_current(2,:) = epi_current(2,:) - disVec(2);

imInfo = infoExtract(handles.infoSA);
endo_cReal = TransformCurvesFromImToRealSpace(endo_current,imInfo);
epi_cReal = TransformCurvesFromImToRealSpace(epi_current,imInfo);
%%update the result
DataSegSA(sliceNoToBeCorrected).endo_c = endo_current;
DataSegSA(sliceNoToBeCorrected).endo_cReal = endo_cReal;
DataSegSA(sliceNoToBeCorrected).epi_c = epi_current;
DataSegSA(sliceNoToBeCorrected).epi_cReal = epi_cReal;
handles.DataSegSA = DataSegSA;

figure(handles.figureSA); 
% clf(handles.figureSA);
% hold on;
imshow(handles.imdataSA,[]); hold on;
plot(endo_current(1,:),endo_current(2,:),'r-', 'LineWidth',2);
plot(epi_current(1,:),epi_current(2,:),'b-', 'LineWidth',2);
plot(endo_orig(1,:), endo_orig(2,:),'w-');

%%%%3D figure
figure(handles.figureLA3D); hold off;
DicomeRealDisplay(handles.figureLA3D, handles.imDataLA3D); hold on;
delete(handles.curve3Dh)
curve3Dh = plot3(endo_cReal(1,:),endo_cReal(2,:), endo_cReal(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
handles.curve3Dh = curve3Dh;


%%%update the whole structure
guidata(hObject, handles);


function input_slice_NO_Callback(hObject, eventdata, handles)
% hObject    handle to input_slice_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_slice_NO as text
%        str2double(get(hObject,'String')) returns contents of input_slice_NO as a double
handles.sliceNoToBeCorrected = str2double(get(hObject,'String'));
str = sprintf('slice No %d: is being selected',handles.sliceNoToBeCorrected);
disp(str);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function input_slice_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_slice_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_displayImages.
function btn_displayImages_Callback(hObject, eventdata, handles)
% hObject    handle to btn_displayImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%display figure 1 and figure 2 with SA and LA views
sliceNoToBeCorrected = handles.sliceNoToBeCorrected;
timeInstanceSelected = handles.timeInstanceSelected;
SXSliceSorted = handles.SXSliceSorted;
DataSegSA = handles.DataSegSAOrig;
% dicomDir = handles.dicomDir;

imData = SXSliceSorted(1,sliceNoToBeCorrected).SXSlice(timeInstanceSelected,1).imData;
imInfo1 = SXSliceSorted(1,sliceNoToBeCorrected).SXSlice(timeInstanceSelected,1).imInfo;
imInfo = infoExtract(imInfo1);
sliceLocationStr = sprintf('%s',imInfo.SliceLocation);
endo_current = DataSegSA(sliceNoToBeCorrected).endo_c;
epi_current = DataSegSA(sliceNoToBeCorrected).epi_c;

if isempty(handles.figureSA)
    handles.figureSA=figure();
else
    figure(handles.figureSA);
end
imshow(imData,[]);hold on;
plot(endo_current(1,:), endo_current(2,:),'r-');
plot(epi_current(1,:), epi_current(2,:),'r-');
title(sliceLocationStr);

%%%3D figure with LA view
imDataLA  = handles.imDataLA;
imInfo1LA = handles.imInfo1LA;
imInfoLA = infoExtract(imInfo1LA);
imDataT = MRIMapToRealWithImageAndHeadData(imDataLA, imInfoLA);

if isempty(handles.figureLA3D)
    handles.figureLA3D = figure(); hold on;
    DicomeRealDisplay(handles.figureLA3D, imDataT);
    endo_c = DataSegSA(sliceNoToBeCorrected).endo_cReal;
    epi_c = DataSegSA(sliceNoToBeCorrected).epi_cReal;
    %%%%plot 3D curves
    curve3Dh = plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
    % plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
    handles.curve3Dh = curve3Dh;
end

%%%find the cutting plane of the long axis view
[px,py] = findCrossLines(imData, imDataLA, imInfo, imInfoLA);
figure(handles.figureSA);hold on;
plot(px(1),py(1),'r+');
plot(px(2),py(2),'ro');
line(px, py);

handles.infoSA = imInfo1;
handles.imdataSA = imData;
handles.imDataLA3D = imDataT;

handles.crossPx = px;
handles.crossPy = py;
handles.crossVec = NormalizationVec([px(1)-px(2) py(1)-py(2)]);
guidata(hObject, handles);


% --- Executes on button press in BCTogether3DLA.
function BCTogether3DLA_Callback(hObject, eventdata, handles)
% hObject    handle to BCTogether3DLA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LVOTSliceSorted = handles.LVOTSliceSorted;
timeInstanceSelected = handles.timeInstanceSelected;
DataSegSA = handles.DataSegSA;
usuableSXSlice = handles.usuableSXSlice;

%%%3D figure with LA view
imDataLA  = handles.imDataLA;
imInfo1LA = handles.imInfo1LA;
imInfoLA = infoExtract(imInfo1LA);
imDataT = MRIMapToRealWithImageAndHeadData(imDataLA, imInfoLA);

h3D = figure(); hold on;
DicomeRealDisplay(h3D, imDataT);

for imIndex = 1 : usuableSXSlice
    endo_c = DataSegSA(imIndex).endo_cReal;
    epi_c = DataSegSA(imIndex).epi_cReal;
    plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
    plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
end


% --- Executes on button press in SAVE.
function SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workingDir = handles.workingDir;
resultDir = handles.resultDir;
cd(resultDir);
DataSegSA = handles.DataSegSA;
save DataSegSA DataSegSA;
cd(workingDir);




