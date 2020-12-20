clear all; close all; clc;

%%%whole lv manual segmentation configuration
if ispc
    path(path, '.\segmentation');
    path(path, '.\BSplineFitting');
    path(path, '.\meshRelated');
end

if ismac
    path(path, './segmentation');
    path(path, './BSplineFitting');
    path(path, './meshRelated');
end

workingDir = pwd();



%%load the patient config file
% resultDirRoot = 'D:\HaoGao\PhDs\PhD_Alan\Results';
% cd(resultDirRoot);
if ispc
    [FileName,PathName,~] = uigetfile('..\MI_Models\*.m');
elseif ismac || isunix
    [FileName,PathName,~] = uigetfile('../MI_Models/*.m');
end
% [FileName, PathName] = uigetfile( ...
%        {'*.m'}, ...
%         'Pick a file');
projectConfig_dir = PathName;
projectConfig_name = FileName(1:end-2);
cd(workingDir);

seg_index = 1;
while 1
    list = {'1', '2', '3'};
    [imSelected, ~] = listdlg('ListString', list, 'SelectionMode', 'single',...
    'ListSize', [80,50], 'InitialValue',seg_index); %%current does not support change location
    %%cancer button will quit the loop
   
    if isempty(imSelected)
        break;
    end

   try 
    LVWM_LASegManual(imSelected,projectConfig_dir,projectConfig_name);
    seg_index = mod(seg_index, 3) + 1;
   catch 
       disp('need to re-segment');
       continue;
   end
   
end