function reconstructionLVGeometry(reconstructed_method, abaqusDir_pca, abaqusDir_preMesh, ...
                                  options, reconstruction_input, outputB)
%% reconstruction_input: parameters for different reconstruction approaches
%% abaqusDir_pca: the reconstructed LV geometry which can be used for simulation 
%% abaqusDir_preMesh: segmentation folder which is used for geometry analysis 
%% options: golabl setting up, pca commonets are also saved in this structure
%% outputB: whether to write out a tecplot file or not.

disp('preparing LV mesh begins .......');
 if reconstructed_method == 1
               wc_pca= reconstruction_input.wc_pca;
               pcaReconstructionUsing5EigenVectors(wc_pca, options.pcaResult.LV_mean,...
                        options.pcaResult.eigVecs, abaqusDir_pca,abaqusDir_preMesh, outputB);
                    %true means output shapes in tecplot format

elseif reconstructed_method == 0
                %% copy the original abaqusnInputData into abaqusInputPCAReconstructionOneLayler, no changes to the mesh
                %% this function output is same as pcaReconstructionUsing5EigenVectors
                 copyAbaqusMeshFileAsReconstruction(abaqusDir_pca, abaqusDir_preMesh, outputB); 
                 %true means outputing the mesh file
             
else
                error('Please specify a method for mesh reconstruction: 0 for direct copy, 1: PCA, 2: auto-encoder, ...');
end