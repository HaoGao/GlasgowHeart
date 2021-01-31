%%%
clear all; 
close all; 
clc;

path(path, '.\segmentation');
path(path, '.\BSplineFitting');
path(path, '.\meshRelated');
workingDir = pwd();

%%load the patient config file
[FileName, PathName] = uigetfile( ...    
       {'*.m'}, ...
        'Pick a file');%[FileName,PathName,~] = uigetfile('*.m');
projectConfig_dir = PathName;
projectConfig_name = FileName(1:end-2);

% cd(projectConfig_dir);
% run(projectConfig_name);
% cd(workingDir) 

early_dia_dir = 'early_diastole';
end_dia_dir = 'end_diastole';
fibre_dir = 'fibreGeneration/Results_fiber_60_45';
simplifed_fibre_direction = 1;

%%now need to figure out the distance from the basal plane to the valvular
%%ring

II = [1 0 0;... 
      0 1 0; ...
      0 0 1];


cd(projectConfig_dir);
cd(end_dia_dir);
load abaqusInputData;
if simplifed_fibre_direction 
    load abaqusInputData_OneLayerMesh;
end
Result_end_dia_dir = pwd();
cd(fibre_dir);
if exist('fiberDir.txt', 'file')
        fiberDir = load('fiberDir.txt');
        sheetDir = load('sheetDir.txt');
        radDir = load('radDir.txt');
        cirDir = load('cirDir.txt');     
end
cd(workingDir);
abaqusInputDataRef = abaqusInputData;
clear abaqusInputData;
    
cd(projectConfig_dir);
cd(early_dia_dir);
load abaqusInputData;
if simplifed_fibre_direction 
    load abaqusInputData_OneLayerMesh;
end
Result_early_dia_dir = pwd();
cd(workingDir);
abaqusInputDataCur = abaqusInputData;
clear abaqusInputData;

FF_r = []; EE_r = [];
FF_c = []; EE_c = [];
FF_l = []; EE_l = [];
        
FF_f = []; EE_f = [];
FF_s = []; EE_s = [];
FF_n = []; EE_n = [];


for i = 1 : size(abaqusInputDataRef.elem,1)
            plist = abaqusInputDataRef.elem(i,:);
            nodeRef_x =  abaqusInputDataRef.node(plist,1);
            nodeRef_y =  abaqusInputDataRef.node(plist,2);
            nodeRef_z =  abaqusInputDataRef.node(plist,3);
            
            

            nodeCur_x =  abaqusInputDataCur.node(plist,1);
            nodeCur_y =  abaqusInputDataCur.node(plist,2);
            nodeCur_z =  abaqusInputDataCur.node(plist,3);
            FF = finiteStrainHex(nodeCur_x, nodeCur_y, nodeCur_z, ...
                               nodeRef_x, nodeRef_y, nodeRef_z);
            EE = 1/2*(FF'*FF-II);

%             %%a simple way to figure out local direction 
%             cirDir = [ abaqusInputDataRef.node(plist(3),1) - abaqusInputDataRef.node(plist(2),1), ...
%                        abaqusInputDataRef.node(plist(3),2) - abaqusInputDataRef.node(plist(2),2), ...
%                        abaqusInputDataRef.node(plist(3),3) - abaqusInputDataRef.node(plist(2),3)];
%             cirDir=NormalizationVec(cirDir);
% 
%             logiDir = [ abaqusInputDataRef.node(plist(1),1) - abaqusInputDataRef.node(plist(2),1), ...
%                         abaqusInputDataRef.node(plist(1),2) - abaqusInputDataRef.node(plist(2),2), ...
%                         abaqusInputDataRef.node(plist(1),3) - abaqusInputDataRef.node(plist(2),3)];
%             logiDir=NormalizationVec(logiDir);
% 
%             raDir = cross(cirDir,logiDir);
%             logiDir = cross(raDir, cirDir);

           if simplifed_fibre_direction == 1
                x0 = mean(nodeRef_x);
                y0 = mean(nodeRef_y);
                z0 = mean(nodeRef_z);
                ldir = [0 0 1];
                rdir = NormalizationVec([x0 y0 z0] - [0 0 0]);
                cdir = NormalizationVec(cross(ldir, rdir));
                rdir = NormalizationVec(cross(cdir, ldir));
            else
                rdir = radDir(i,2:4);
                cdir = cirDir(i,2:4);
                ldir = cross(cdir, rdir);
           end
                
            Rot = [cdir;rdir;ldir]; 
            FF_RCL = Rot*FF*(Rot');   EE_RCL = Rot*EE*(Rot');
            FF_c(i,1) = FF_RCL(1,1);  EE_c(i,1) = EE_RCL(1,1);
            FF_r(i,1) = FF_RCL(2,2);  EE_r(i,1) = EE_RCL(2,2);
            FF_l(i,1) = FF_RCL(3,3);  EE_l(i,1) = EE_RCL(3,3);
            
            Rot = [];

            fdir = fiberDir(i, 2:4);
            sdir = sheetDir(i, 2:4);
            ndir = cross(fdir,sdir);
            Rot = [fdir; sdir;ndir];
            FF_fsn = Rot*FF*(Rot');  EE_fsn = Rot*EE*(Rot');
            FF_f(i,1) = FF_fsn(1,1); EE_f(i,1) = EE_fsn(1,1);
            FF_s(i,1) = FF_fsn(2,2); EE_s(i,1) = EE_fsn(2,2);
            FF_n(i,1) = FF_fsn(3,3); EE_n(i,1) = EE_fsn(3,3);


end

cd(Result_early_dia_dir);
tecfid_F = fopen('FF_early_to_end.dat', 'w');
tecStrainfid = fopen('EE_early_to_end.dat', 'w');
cd(workingDir);

TecplotLVMeshWriteWithCentreData(tecfid_F,abaqusInputDataRef,FF_f,FF_s,FF_n,FF_c, FF_r, FF_l);
TecplotLVMeshWriteWithCentreData(tecStrainfid,abaqusInputDataRef,EE_f,EE_s,EE_n,EE_c, EE_r, EE_l);
fclose(tecfid_F);
fclose(tecStrainfid);
        


%% the strain calculation based on this seems still problematic





