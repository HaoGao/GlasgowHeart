function abaqusInputPCAReconstructionOneLayerMesh = update_endo_epi_3(abaqusInputData,PCA_reconstructed)

endoNodes = abaqusInputData.endoNodes;
epiNodes = abaqusInputData.epiNodes;

node = abaqusInputData.node; 

N = length(endoNodes);


%%update for endo x y z
for i = 1 : N
    i_rec_1 = (i-1)*3+1;
    i_rec_2 = (i-1)*3+2;
    i_rec_3 = (i-1)*3+3;
    
    nodeID = endoNodes(i);
    node(nodeID, 1) = PCA_reconstructed(i_rec_1);
    node(nodeID, 2) = PCA_reconstructed(i_rec_2);
    node(nodeID, 3) = PCA_reconstructed(i_rec_3);
end

%%update for epi x y z
for i = 1 : N
    i_rec_1 = (i-1)*3+1 + 3*N;
    i_rec_2 = (i-1)*3+2 + 3*N;
    i_rec_3 = (i-1)*3+3 + 3*N;
    nodeID = epiNodes(i);
   
    
    node(nodeID, 1) = PCA_reconstructed(i_rec_1);
    node(nodeID, 2) = PCA_reconstructed(i_rec_2);
    node(nodeID, 3) = PCA_reconstructed(i_rec_3);
end

abaqusInputPCAReconstructionOneLayerMesh = abaqusInputData;
abaqusInputPCAReconstructionOneLayerMesh.node = node;