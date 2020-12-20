%%%whole lv manual segmentation configuration
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


%%figure out how many short axis images 
totalSASlices = 0;
for i = 1 : size(patientConfigs.SliceSpec, 1)
    if strcmp('SAcine', patientConfigs.SliceSpec(i,1).spec)
        totalSASlices = totalSASlices + 1;
    end
    
end


seg_index = 1;
while 1
    
    for i = 1 : totalSASlices
       list{i} = sprintf('%d', i); 
    end
    
    [imSelected, ~] = listdlg('ListString', list, 'SelectionMode', 'single',...
    'ListSize', [100,200], 'InitialValue',seg_index); %%current does not support change location
    %%cancer button will quit the loop
   
    if isempty(imSelected)
        break;
    end

   try 
    Function_LVWM_SASegManualUsingImpoint(imSelected,projectConfig_dir,projectConfig_name);
    seg_index = mod(seg_index, totalSASlices) + 1;
    msg_to_show = sprintf('finish one segmenation for %s\n', projectConfig_name);
    cprintf('blue',msg_to_show);
   catch 
       cprintf('red', 'need to re-segment\n');
       continue;
   end
   
end