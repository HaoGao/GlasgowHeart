%%accessing image with segmented results
clear all; close all; clc;
if ispc
    path(path, '.\segmentation');
    path(path, '.\BSplineFitting');
    path(path, '.\meshRelated');
end

if ismac 
    path(path, './segmentation');
    path(path,  './BSplineFitting');
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

cd(projectConfig_dir);
run(projectConfig_name);
cd(workingDir);


