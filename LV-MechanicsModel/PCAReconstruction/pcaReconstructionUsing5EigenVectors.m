function pcaReconstructionUsing5EigenVectors(w_pca, LV_mean, eigVecs, abaqusDir_pca, ...
                                 abaqusDir_preMesh, outputB)

disp('reconstruct subject specific LV from PCA');
%%LV_mean, eigVecs
% %  w_pca = [-18.2695   -1.4049    2.8309  -14.6374  -25.4179]; %%that is from HV03
workingDir = pwd();

%%this is only for references, a standard structure
%%this is hard coded here, will need to update
%%it only provides a template to provide the topology connectivity information, not used
%%for actual shape
cd(abaqusDir_preMesh);
load abaqusInputData.mat;
cd(workingDir);

node = abaqusInputData.node;
node_ave = abaqusInputData.node;

endoNodes = abaqusInputData.endoNodes;
% sendo = zeros([length(endoNodes)*3, 1]);
% for i = 1 : length(endoNodes);
%     sendo((i-1)*3+1) = node(endoNodes(i),1);
%     sendo((i-1)*3+2) = node(endoNodes(i),2);
%     sendo((i-1)*3+3) = node(endoNodes(i),3);
% end


epiNodes = abaqusInputData.epiNodes;
% sepi = zeros([length(epiNodes)*3, 1]);
% for i = 1 : length(epiNodes);
%     sepi((i-1)*3+1) = node(epiNodes(i),1);
%     sepi((i-1)*3+2) = node(epiNodes(i),2);
%     sepi((i-1)*3+3) = node(epiNodes(i),3);
% end

%%reconstruction procedure
% LV_surface=[sendo; sepi]';
% LV_surface_std = LV_surface-LV_mean;
% PCA_projection=(LV_surface_std*eigVecs)*eigVecs';
PCA_projection = w_pca*eigVecs';
PCA_projection = PCA_projection + LV_mean;
sendo_projected = PCA_projection(1:length(PCA_projection)/2);
sepi_projected =  PCA_projection(length(PCA_projection)/2+1:end);

sendo_ave = LV_mean(1:length(LV_mean)/2);
sepi_ave  = LV_mean(length(LV_mean)/2+1:end);

%%update to a new datastructure
abaqusInputPCAReconstructionOneLayler = abaqusInputData;

for i = 1 : length(endoNodes)
    node(endoNodes(i),1) = sendo_projected( (i-1)*3 + 1);
    node(endoNodes(i),2) = sendo_projected( (i-1)*3 + 2);
    node(endoNodes(i),3) = sendo_projected( (i-1)*3 + 3);
    
    node_ave(endoNodes(i),1) = sendo_ave( (i-1)*3 + 1 );
    node_ave(endoNodes(i),2) = sendo_ave( (i-1)*3 + 2 );
    node_ave(endoNodes(i),3) = sendo_ave( (i-1)*3 + 3 ); 
end

for i = 1 : length(epiNodes)
    node(epiNodes(i),1) = sepi_projected( (i-1)*3 + 1);
    node(epiNodes(i),2) = sepi_projected( (i-1)*3 + 2);
    node(epiNodes(i),3) = sepi_projected( (i-1)*3 + 3);
    
    node_ave(epiNodes(i),1) = sepi_ave( (i-1)*3 + 1 );
    node_ave(epiNodes(i),2) = sepi_ave( (i-1)*3 + 2 );
    node_ave(epiNodes(i),3) = sepi_ave( (i-1)*3 + 3 );
end

abaqusInputPCAReconstructionOneLayler.node = node;

%%hard code here, needs to updated 
cd(abaqusDir_pca);
save abaqusInputPCAReconstructionOneLayer abaqusInputPCAReconstructionOneLayler;
cd(workingDir);



% LVMeshAddNLayers(abaqusInputPCAReconstructionOneLayer, NLayers)



if outputB
    %%output for checking
    cd(abaqusDir_pca);
    fid = fopen('LVMeshPCAProjectedOneLayerMesh.dat','w');
    cd(workingDir)
    fprintf(fid, 'TITLE = "Heart MESH projected with one layer" \n');
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
    
    %%output the average shape here
    cd(abaqusDir_pca);
    fid = fopen('LVMeshPCAAverageMesh.dat','w');
    cd(workingDir)
    fprintf(fid, 'TITLE = "Heart MESH average shape with one layer" \n');
    fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
    fprintf(fid, 'ZONE T="TotalMesh", N = %d, E=%d, F=FEPOINT, ET=BRICK \n', ...
        size(abaqusInputPCAReconstructionOneLayler.node, 1), size(abaqusInputPCAReconstructionOneLayler.elem,1));


    for i = 1 : size(abaqusInputPCAReconstructionOneLayler.node,1)
        fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',node_ave(i,1),...
             node_ave(i,2),node_ave(i,3),...
             node_ave(i,4),node_ave(i,5),...
             node_ave(i,6));
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


