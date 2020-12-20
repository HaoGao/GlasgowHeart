Sim_forwardSimulationLV_PCAbased.m is an example code
Brief explanation:  
1. line 35: wc_pca is assgined and saved in reconstruction_input structure, which will be passed to function reconstructionLVGeometry(). 

2. reconstructed_method needs to be defined, 0 for using the geometry directly from images, and 1 for pca reconstruction, you can define other approaches

3. regenerate_fibre: whenever you change the geometry, you will need to regenerate the fibre by calling LV_WholeMesh_abaqusFilePreparation(), followed by LV_WholeMesh_FibreGeneration().



fucntion reconstructionLVGeometry() is the adaptor for different reconstruction methods. It is within the folder PCAReconstuction. 


For PCA reconstruction:
the average shape and eigen vectors are loaded in the config file, for example: Sim_DirConfigForwardComputation_HV03, 

%% load the average shape and eigen vectors, which are saved in pcaResult
cd('../LVModelSimulator/averageShape');
load LV_mean;
pcaResult.LV_mean = LV_mean; clear LV_mean;
load Eigvecs_HVMI;
pcaResult.eigVecs = eigVecs; clear eigVecs;
cd(workingDir);

options.pcaResult = pcaResult;


You will need to verify the reconstruction method. I did compare the PCA reconstructed geometry using the first 5 components, but seems quite different from the imaged based geometry. But I might used wrong pca_wca or the reconstruction approach is not implemented properly.



