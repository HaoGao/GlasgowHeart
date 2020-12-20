function copyAbaqusMeshFileAsReconstruction(abaqusDir_pca, abaqusDir_preMesh, outputB)
%%a simple copy, which is adapted from pca reconstuction function
disp('direct copy subject specific LV');

workingDir = pwd();

%%this is only for references, a standard structure
%%this is hard coded here, will need to update
%%it only provides a template to provide the topology connectivity information, not used
%%for actual shape
cd(abaqusDir_preMesh);
load abaqusInputData.mat;
cd(workingDir);

%%update to a new datastructure
abaqusInputPCAReconstructionOneLayler = abaqusInputData;

%%hard code here, needs to updated 
cd(abaqusDir_pca);
save abaqusInputPCAReconstructionOneLayer abaqusInputPCAReconstructionOneLayler;
cd(workingDir);

% LVMeshAddNLayers(abaqusInputPCAReconstructionOneLayer, NLayers)

if outputB
    %%output for checking
    cd(abaqusDir_pca);
    fid = fopen('LVMeshPCAOneLayerMeshByCopy.dat','w');
    cd(workingDir)
    fprintf(fid, 'TITLE = "Heart MESH copied with one layer" \n');
    fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
    fprintf(fid, 'ZONE T="TotalMesh", N = %d, E=%d, F=FEPOINT, ET=BRICK \n', ...
        size(abaqusInputPCAReconstructionOneLayler.node, 1), size(abaqusInputPCAReconstructionOneLayler.elem,1));


    for i = 1 : size(abaqusInputPCAReconstructionOneLayler.node,1)
        fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',abaqusInputPCAReconstructionOneLayler.node(i,1),...
             abaqusInputPCAReconstructionOneLayler.node(i,2),abaqusInputPCAReconstructionOneLayler.node(i,3),...
             abaqusInputPCAReconstructionOneLayler.node(i,4),abaqusInputPCAReconstructionOneLayler.node(i,5),...
             abaqusInputPCAReconstructionOneLayler.node(i,6));
    end

    for i = 1 : size(abaqusInputPCAReconstructionOneLayler.elem,1)
        fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', abaqusInputPCAReconstructionOneLayler.elem(i,1),abaqusInputPCAReconstructionOneLayler.elem(i,2), ...
                                               abaqusInputPCAReconstructionOneLayler.elem(i,3),abaqusInputPCAReconstructionOneLayler.elem(i,4),...
                                               abaqusInputPCAReconstructionOneLayler.elem(i,5), ...
                                               abaqusInputPCAReconstructionOneLayler.elem(i,6),abaqusInputPCAReconstructionOneLayler.elem(i,7),...
                                               abaqusInputPCAReconstructionOneLayler.elem(i,8));
    end



    fclose(fid);
     

end


