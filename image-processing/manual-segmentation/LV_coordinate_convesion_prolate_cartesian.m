clear all; close all; clc; 
%%reconstruct cartesian coordinat from prolate coordinate system

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


% LVWM_config;
if ~exist('projectConfig_name', 'var')
    LVWM_config; %% that is for standalone run
else
    cd(projectConfig_dir);
    run(projectConfig_name);
    cd(workingDir);
end

%%%% load parameter for one study
cd(resultDir);
if exist('SetParameters.m', 'file')
    SetParameters;
    cd(workingDir);
else
    cd(workingDir);
    SetParametersDefault;
end

[alpha0, w0, umax] = readGeometry(resultDir, prolateParametersFileName);
%%alpha0 is very important parameter, in order to compare \rho from
%%different LV geometry, in the fitting procedure, alpha0 should be same
%%readGeometry function will load the alpha0 used for fitting a specific LV


%%% load the mesh file
cd(resultDir);
load abaqusInputData;
cd(workingDir);

node = abaqusInputData.node;
x = node(:,1);
y = node(:,2);
z = node(:,3);

u = node(:,4)*pi/180;
v = node(:,5)*pi/180;
w = node(:,6);


for i = 1 : length(x)
    p = w(i);
    cw=cosh(p);
    sw=sinh(p);
	x1=alpha0*cos(u(i))*cos(v(i));
	y1=alpha0*cos(u(i))*sin(v(i));
	z1=alpha0*sin(u(i));
	x_p(i,1)=x1*sw;
	y_p(i,1)=y1*sw;
	z_p(i,1)=z1*cw; 
end

x_diff = max(abs(x_p - x));
y_diff = max(abs(y_p - y));
z_diff = max(abs(z_p - z));






















