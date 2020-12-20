function wc_pca=pcaconstruction(resultDir) 
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%%this is only calculate teh wc_endo and wc_epi
workingDir = pwd();
load 'LV_mean.mat';
load 'Eigvecs_HVMI.mat';


cd(resultDir)
load abaqusInputData.mat;
cd(workingDir);

%%sendo is [x_1, y_1, z_1, z_2, y_2 z_2, ...]  a row vector
%%similar for sepi
[sendo, sepi] = extract_endo_epi_3(abaqusInputData);

%%joining the two surface together as a column vector, 
%%the first half is for endo and the second half is for epi
LV_surface_ori=[sendo'; sepi']'; 
LV_surface = LV_surface_ori- LV_mean;

wc_pca = LV_surface*eigVecs;

PCA_reconstructed=LV_mean+wc_pca*eigVecs';

%%need to regenerate the abaqusInputData 
%save abaqusDir_pca
%abaqusInputPCAReconstructionOneLayerMesh

%%it is one layer mesh with only x y z updated but not u v w
abaqusInputPCAReconstructionOneLayerMesh = update_endo_epi_3(abaqusInputData,PCA_reconstructed); 


%%adding more layers between the endo and epi
abaqusInputPCAReconstruction = LVMeshAddNLayers(abaqusInputPCAReconstructionOneLayerMesh, NLayers);




% abaqusInputData.PCAReconstructed=PCA_projection;
% save abaqusInputData1 abaqusInputData;



