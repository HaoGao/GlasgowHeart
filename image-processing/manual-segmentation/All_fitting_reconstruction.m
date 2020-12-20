%% All_fitting_reconstruction
%% it will combine the following steps
%% LVWM_SALASeg_LongAxisAlignment
%% LVWM_SA_GuidPointsGeneration_LongAxisAlignment
%% LV_EndoFitting
%% LV_EpiFitting
%% LV_WholeMesh
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

%%calling step by steps
disp('run LVWM_SALASeg_LongAxisAlignment');
LVWM_SALASeg_LongAxisAlignment(projectConfig_dir,projectConfig_name);

disp('run LVWM_SA_GuidPointsGeneration_LongAxisAlignment');
LVWM_SA_GuidPointsGeneration_LongAxisAlignment(projectConfig_dir,projectConfig_name);

disp('run LV_EndoFitting');
LV_EndoFitting(projectConfig_dir,projectConfig_name);

disp('run LV_EpiFitting');
LV_EpiFitting(projectConfig_dir,projectConfig_name);

disp('run LV_WholeMesh');
LV_WholeMesh(projectConfig_dir,projectConfig_name);

