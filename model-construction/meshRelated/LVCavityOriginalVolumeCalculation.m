function vol_ori=LVCavityOriginalVolumeCalculation(abaqusInputPCAReconstruction)
%% this will take the mesh format as the input, anc calculate cavity volume in mm^3
% %%%the orginal mesh file
% cd(options.abaqusDir_pca);
% load(options.abaqus_input_name); 
% cd(workingDir);

%%%some updates to the abaqusInputData structure
node_ori = abaqusInputPCAReconstruction.node(:,1:3);
node_ori(:,1) = node_ori(:,1)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,2) = node_ori(:,2)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,3) = node_ori(:,3)*abaqusInputPCAReconstruction.scaleTomm;

endoNodes = abaqusInputPCAReconstruction.endoNodes;

nodes_x = node_ori(endoNodes',1);
nodes_y = node_ori(endoNodes',2);
nodes_z = node_ori(endoNodes',3);


DT =  DelaunayTri(nodes_x,nodes_y,nodes_z);

[~, vol_ori] = convexHull(DT);

