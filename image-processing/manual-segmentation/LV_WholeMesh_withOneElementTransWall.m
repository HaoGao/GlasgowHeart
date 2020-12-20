clear all; close all; clc;

%%%find the proper directory 
LVWM_config;

%%%% load parameter for one study
%%%% load parameter for one study
cd(resultDir);
if exist('SetParameters.m', 'file')
    SetParameters;
    cd(workingDir);
else
    cd(workingDir);
    SetParametersDefault;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%remember this is the nubmer to specify how many layers will be used for
%%%reconstructing the 3D mesh. 
NwMesh = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%only for cubic spline
if(kS ~=4)
    disp('The program is ONLY for Cubic B-Spline with kS=4');
    disp('Please change kS in setparameters back to kS=4');
    stop;
end

 % c=======read geometry of the reference prolate spheriodal surface
disp('read geometry of the reference prolate spheriod');
[alpha0, w1, w2, umax, umin] = readGeometry_wholeLV(resultDir, prolateParametersFileName);

[uknot, vknot, AIJ_Endo, AIJ_Epi] =Fit_EndoEpi_Parameters(resultDir, Endo_FitparameterFileName, Epi_FitparameterFileName, ...
                               nptsu, nptsv, kS);

[uvnode, NNode,Nelement,ElementNode,neRegular, nnRegular, naReg] = PartitionUV(umax, w1, alpha0, NuMesh, NvMesh);                           
%%%%write out the mesh file
cd(resultDir);
fileNameNewMesh = sprintf('LVMeshWith_%dLayers.dat', NwMesh);
fid = fopen(fileNameNewMesh, 'w');
cd(workingDir);
fprintf(fid, 'TITLE = " 3D Mesh of a LV reconstructed from MR slices with few layers"\n');
fprintf(fid, 'VARIABLES = "x","y","z","u","v","w"\n');

%%%write out the reference mesh
ReferenceMesh(NwMesh, NuMesh, NvMesh, NNode,uvnode, Nelement, ElementNode, ...
                      w1, w2,alpha0,umax, fid);

%FittedLVMesh(w1, w2, alpha0, umax, NwMesh, NuMesh, NvMesh, NNode, Nelement, ElementNode,...
%                      uvnode,  nptsu, nptsv, uknot, vknot, kS, AIJ_Epi, AIJ_Endo, fid);
NeRegularApex = neRegular*NwMesh + naReg*NwMesh*NvMesh+1;
abaqusInputData = FittedLVMeshWithOutPut(w1, w2, alpha0, umax, NwMesh, NuMesh, NvMesh, NNode, Nelement,ElementNode, ...
                      uvnode,  nptsu, nptsv, uknot, vknot, kS, AIJ_Epi, AIJ_Endo,NeRegularApex, fid);
scaleTomm = 10; %%%since all data here after segmenation output it has been changed to be cm, while in Abaqus, better to be mm.
abaqusInputData.scaleTomm = 10;

cd(resultDir);
save abaqusInputData_OneLayerMesh abaqusInputData;
cd(workingDir);
                  
cd(resultDir);
AbaLVHexMeshFileName_layered = sprintf('LVMeshWith_%dLayers.inp', NwMesh);
fidAba = fopen(AbaLVHexMeshFileName_layered, 'w');
cd(workingDir);
 
abaqusInpGenerationForHexMesh(abaqusInputData, scaleTomm, fidAba); %%fidAba is closed in side the function       
              
                  
%%%plot guided spline
% PlotGuideSplines(resultDir, fid,outterGuidePointsFileName, innerGuidePointsFileName);
                  
fclose(fid);



%%need to output LV mesh in MRI coordinate system
cd(resultDir);
fid = fopen('LVFittedMeshWith_OneLayer_MRICoor.dat', 'w');
cd(workingDir);

NodeMat = abaqusInputData.node;
ElemMat = abaqusInputData.elem;

nodeMat(:,2) = NodeMat(:,1)*abaqusInputData.scaleTomm;
nodeMat(:,3) = NodeMat(:,2)*abaqusInputData.scaleTomm;
nodeMat(:,4) = NodeMat(:,3)*abaqusInputData.scaleTomm;
nodeMatMRI = rotationBackToMRICoordinateSystemt(nodeMat,resultDir);

% TecplotHexMesh(nodeMatMRI, ElemMat,[],fid);
uvw = NodeMat(:,4:6);
TecplotHexMeshVec(nodeMatMRI, ElemMat,uvw,fid)
fclose(fid);
















                           
                           