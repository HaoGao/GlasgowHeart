function LV_WholeMesh_abaqusFilePreparation(abaqusDir_pca,abaqusDir)

workingDir = pwd();
cd(abaqusDir_pca);
if ~exist('abaqusInputPCAReconstruction.mat', 'file')
    error('looking for abaqusInputPCAReconstruction.mat, not found in abaqusDir_pca');
    pause;
else
    load abaqusInputPCAReconstruction;
end
cd(workingDir);

abaqusInputData = abaqusInputPCAReconstruction;
abaqusFiberDir = abaqusDir_pca;

abaqusInputFileName = 'hexheartLVmeshF60S45.inp';


%%%now need to output the meshfiles for fiber generation
%%%nodes generation
cd(abaqusFiberDir);
fid_nodes = fopen('Node.txt', 'w');
fid_domain = fopen('domainID.txt','w');
cd(workingDir);
scaleTomm = abaqusInputData.scaleTomm;
for i = 1 : size(abaqusInputData.node,1)
    fprintf(fid_nodes, '\t%d, \t%f, \t%f, \t%f\n', i, abaqusInputData.node(i,1)*scaleTomm,...
                                                      abaqusInputData.node(i,2)*scaleTomm,...
                                                      abaqusInputData.node(i,3)*scaleTomm);
end
fclose(fid_nodes);

apexEleStartNo = abaqusInputData.apexEleStartNo;
fprintf(fid_domain, '%d \t %d\t %d\n',1, apexEleStartNo-1,1);
fprintf(fid_domain,'%d \t %d\t %d\n', apexEleStartNo, size(abaqusInputData.elem,1), 2);
fclose(fid_domain);

%%%elements
cd(abaqusFiberDir);
fid_elems = fopen('Element.txt','w');
cd(workingDir);
for i = 1 : size(abaqusInputData.elem,1)
    fprintf(fid_elems, '\t%d, \t%d, \t%d, \t%d, \t%d, \t%d, \t%d, \t%d, \t%d\n', i, abaqusInputData.elem(i,1), abaqusInputData.elem(i,2), abaqusInputData.elem(i,3)...
                                                                                  , abaqusInputData.elem(i,4), abaqusInputData.elem(i,5), abaqusInputData.elem(i,6)...
                                                                                  , abaqusInputData.elem(i,7), abaqusInputData.elem(i,8));
end
fclose(fid_elems);


%%%endo faces
endofaces = abaqusInputData.endofaces;
endofacesT = endofacesDivision(endofaces);
WriteAbaqusFaces(endofacesT,'Endo',abaqusFiberDir,workingDir);

%%%epi faces
epifaces = abaqusInputData.epifaces;
epifacesT = endofacesDivision(epifaces);
WriteAbaqusFaces(epifacesT,'Epi',abaqusFiberDir,workingDir);

%%%base faces
basefaces = abaqusInputData.basefaces;
basefacesT = endofacesDivision(basefaces);
WriteAbaqusFaces(basefacesT,'base',abaqusFiberDir,workingDir);

%%%basenodes
baseNodes = abaqusInputData.baseNodes;
WriteAbaqusNodesSet(baseNodes,'baseNodes.txt',abaqusFiberDir,workingDir);

%%endonodes
endoNodes = abaqusInputData.endoNodes;
WriteAbaqusNodesSet(endoNodes,'endoNodes.txt',abaqusFiberDir,workingDir);


%%%abaqus input file generation for abaqus simulation
WriteAbaqusMeshInput(abaqusInputData, abaqusInputFileName, abaqusDir,workingDir);



% %%%for verification
% cd(abaqusFiberDir);
% node_ref = load('Node.txt');
% elem_ref = load('Element.txt');
% 
% endoface_S1_ref =  26401: 10 : 28641;
% endoface_S3_ref =  1: 10 :26391;
% epiface_S2_ref =  26410 :10: 28650;
% epiface_S5_ref =  10 : 10: 26400;
% base_S1_ref = 1:1:600;
% 
% endoNodesFileHandle = fopen('baseNodes.txt','r');
% endoNodes_ref = 1:1:2896;
% cd(workingDir);
% 
% baseNodes_ref = readingAbaqusSetsData(endoNodesFileHandle);
% 
% baseNodes = abaqusInputData.baseNodes;
% endoNodes = abaqusInputData.endoNodes;
% 
% diffST_endoNodes = comparisonTwoVectors(endoNodes, endoNodes_ref);
% diffST_baseNodes = comparisonTwoVectors(baseNodes, baseNodes_ref);
% 
% %%
% endofaces = abaqusInputData.endofaces;
% endofacesT = endofacesDivision(endofaces);
% endoface_S1 = endofacesT.S1faces;
% endoface_S3 = endofacesT.S3faces;
% 
% diffST_endofaces_S1 = comparisonTwoVectors(endoface_S1, endoface_S1_ref);
% diffST_endofaces_S3 = comparisonTwoVectors(endoface_S3, endoface_S3_ref);
% 
% epifaces = abaqusInputData.epifaces;
% epifacesT = endofacesDivision(epifaces);
% epiface_S2 = epifacesT.S2faces;
% epiface_S5 = epifacesT.S5faces;
% 
% diffST_epifaces_S2 = comparisonTwoVectors(epiface_S2, epiface_S2_ref);
% diffST_epifaces_S5 = comparisonTwoVectors(epiface_S5, epiface_S5_ref);

%%%calculate the LV cavity volume
% endoNodes = abaqusInputData.endoNodes;
NodesTotal = abaqusInputData.node;
nodes_x = NodesTotal(endoNodes,1);
nodes_y = NodesTotal(endoNodes,2);
nodes_z = NodesTotal(endoNodes,3);
DT =  DelaunayTri(nodes_x,nodes_y,nodes_z);
[~, vol_ori] = convexHull(DT);
% [vol_ori] = convexHull(DT);


