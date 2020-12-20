function abaqusInputPCAReconstruction = LVMeshAddNLayers(abaqusInputPCAReconstructionOneLayerMesh, NLayers)

%%only work for hex mesh

abaqusInputData = abaqusInputPCAReconstructionOneLayerMesh;
node_ori = abaqusInputPCAReconstructionOneLayerMesh.node;
elem_ori = abaqusInputPCAReconstructionOneLayerMesh.elem;
endofaces_ori = abaqusInputPCAReconstructionOneLayerMesh.endofaces;
epifaces_ori = abaqusInputPCAReconstructionOneLayerMesh.epifaces;
apexEleStartNo_ori = abaqusInputPCAReconstructionOneLayerMesh.apexEleStartNo;
scaleTomm_ori = abaqusInputPCAReconstructionOneLayerMesh.scaleTomm;
endoNodes = abaqusInputData.endoNodes;
epiNodes = abaqusInputData.epiNodes;






% %%the other way is to use endoNodes 
% endo_epi_map = [];
% for i = 1 : length(endoNodes)
%     nIDEndo = endoNodes(i); 
%     nIDEpi= findEpiFromElem(elem_ori, apexEleStartNo_ori, nIDEndo);
%     endo_epi_map(i,1) = nIDEndo;
%     endo_epi_map(i,2) = nIDEpi;
% end

node = node_ori;
%%actually endo node and epi node are already paired
nodeIDGlobal = size(node_ori,1);
for nId = 1 : length(endoNodes)
     xyz_endo = node_ori(endoNodes(nId), 1:6);
     xyz_epi  =  node_ori(epiNodes(nId), 1:6);
     x = [xyz_endo(1) xyz_epi(1)];
     y = [xyz_endo(2) xyz_epi(2)];
     z = [xyz_endo(3) xyz_epi(3)];
   
    [xnew, ynew, znew] = interp_hg(x, y, z, NLayers);
   
    IDGlobal = zeros(size(xnew));
    IDGlobal(1) = endoNodes(nId);
    IDGlobal(end) = epiNodes(nId);
    
    %%adding new nodes to IDGlobal
    for i = 2 : NLayers
        nodeIDGlobal = nodeIDGlobal + 1;
        IDGlobal(i) = nodeIDGlobal;
        node(nodeIDGlobal,1:6) = [xnew(i) ynew(i) znew(i) xyz_endo(4) xyz_endo(5) xyz_endo(6)];
    end
    
    lineDivisions(endoNodes(nId),1).xnew = xnew;
    lineDivisions(endoNodes(nId),1).ynew = ynew;
    lineDivisions(endoNodes(nId),1).znew = znew;
    lineDivisions(endoNodes(nId),1).IDGlobal = IDGlobal;  
end



%%now we can add the new element
el_coarse = size(elem_ori, 1);
el_fine = 0;
elem = [];
endofaces = [];
epifaces = [];
%this is for mid ventricle
for el_index = 1 : apexEleStartNo_ori-1
    
    nd_el_coarse = elem_ori(el_index, 1:8);
    endo_nd_1 = nd_el_coarse(1);
    endo_nd_5 = nd_el_coarse(5);
    endo_nd_6 = nd_el_coarse(6);
    endo_nd_2 = nd_el_coarse(2);
    
    endo_line_1 = lineDivisions(endo_nd_1).IDGlobal;
    endo_line_5 = lineDivisions(endo_nd_5).IDGlobal;
    endo_line_6 = lineDivisions(endo_nd_6).IDGlobal;
    endo_line_2 = lineDivisions(endo_nd_2).IDGlobal;
    
    for i = 1 : NLayers
       nd_el_fine = [endo_line_1(i), endo_line_2(i), endo_line_2(i+1), endo_line_1(i+1), ...
                     endo_line_5(i), endo_line_6(i), endo_line_6(i+1), endo_line_5(i+1)];
       el_fine = el_fine + 1;
       elem(el_fine,1:8) = nd_el_fine;
       
       if i == 1
           endofaces = [endofaces; el_fine,3];
       end
       
       if i== NLayers
           epifaces = [epifaces; el_fine, 5];
       end
    end
    
end

apexEleStartNo = el_fine + 1;

for el_index = apexEleStartNo_ori: el_coarse
    nd_el_coarse = elem_ori(el_index, 1:8);
    endo_nd_1 = nd_el_coarse(1);
    endo_nd_2 = nd_el_coarse(2);
    endo_nd_3 = nd_el_coarse(3);
    endo_nd_4 = nd_el_coarse(4);
    
    endo_line_1 = lineDivisions(endo_nd_1).IDGlobal;
    endo_line_2 = lineDivisions(endo_nd_2).IDGlobal;
    endo_line_3 = lineDivisions(endo_nd_3).IDGlobal;
    endo_line_4 = lineDivisions(endo_nd_4).IDGlobal;
    
    for i = 1 : NLayers
        nd_el_fine = [endo_line_1(i), endo_line_2(i), endo_line_3(i), endo_line_4(i), ...
                      endo_line_1(i+1), endo_line_2(i+1) endo_line_3(i+1), endo_line_4(i+1)];
                  
       el_fine = el_fine + 1;
       elem(el_fine,1:8) = nd_el_fine;
       
       if i == 1
           endofaces = [endofaces; el_fine,1];
       end
       
       if i== NLayers
           epifaces = [epifaces; el_fine, 2];
       end
    end
    
end

abaqusInputPCAReconstruction.node = node;
abaqusInputPCAReconstruction.elem = elem;
abaqusInputPCAReconstruction.endofaces = endofaces;
abaqusInputPCAReconstruction.epifaces = epifaces;
abaqusInputPCAReconstruction.distance_to_endo = [];
abaqusInputPCAReconstruction.endoNodes = [];
abaqusInputPCAReconstruction.epiNodes = [];
abaqusInputPCAReconstruction.baseNodes = [];
abaqusInputPCAReconstruction.apexEleStartNo = apexEleStartNo;
abaqusInputPCAReconstruction.scaleTomm = scaleTomm_ori;


%%%output an abaqus input file for checking
fidAba = fopen('LVMeshAba,inp', 'w');
abaqusInpGenerationForHexMesh(abaqusInputData, abaqusInputData.scaleTomm, fidAba)
fclose(fidAba);

















%%this is for test whether the refined mesh is ok or not
%%need to output LV mesh in MRI coordinate system
fid = fopen('LVFittedMeshWithLayers.dat', 'w');

NodeMat = abaqusInputPCAReconstruction.node;
ElemMat = abaqusInputPCAReconstruction.elem;

nodeMat(:,2) = NodeMat(:,1)*abaqusInputPCAReconstruction.scaleTomm;
nodeMat(:,3) = NodeMat(:,2)*abaqusInputPCAReconstruction.scaleTomm;
nodeMat(:,4) = NodeMat(:,3)*abaqusInputPCAReconstruction.scaleTomm;

% TecplotHexMesh(nodeMatMRI, ElemMat,[],fid);

fprintf(fid, 'TITLE = "Heart MESH maped with nodal value" \n');
fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
fprintf(fid, 'ZONE T="Fitted LV Mesh", N=%d, E=%d, F=FEPOINT, ET=BRICK\n', size(nodeMat, 1), size(ElemMat,1));


for i = 1 : size(nodeMat,1)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',nodeMat(i,2),nodeMat(i,3),nodeMat(i,4),nodeMat(i,2),nodeMat(i,3),nodeMat(i,4));
end

for i = 1 : size(ElemMat,1)
     fprintf(fid, '%d   %d    %d    %d    %d    %d     %d    %d\n', ElemMat(i,1),ElemMat(i,2), ...
         ElemMat(i,3),ElemMat(i,4),ElemMat(i,5),ElemMat(i,6),ElemMat(i,7),ElemMat(i,8));
end

fclose(fid);





%     lineDivisions = dividingEdges(node_el, node_ori,NLayers);
%    
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%    
%     for lineIndex = 1 : 4
%         IDGlobal = lineDivisions(lineIndex,1).IDGlobal;
%         for nIndex = 2 : NLayers
%             nID = nID + 1;
%             IDGlobal(nIndex) = nID;
%             %%update the nodes
%             node(nID,1:3) = [lineDivisions(lineIndex,1).xnew(nIndex), ...
%                              lineDivisions(lineIndex,1).ynew(nIndex), ...
%                              lineDivisions(lineIndex,1).znew(nIndex)];
%         end
%         lineDivisions(lineIndex,1).IDGlobal = IDGlobal;
%     end
%     
%      %%%adding the elem
%      for nIndex = 1 : NLayers
%          elID = elID + 1;
%          elem(elID,1:8) = [lineDivisions(1,1).IDGlobal(nIndex),   lineDivisions(4,1).IDGlobal(nIndex),...
%                        lineDivisions(4,1).IDGlobal(nIndex+1),   lineDivisions(1,1).IDGlobal(nIndex+1),...
%                        lineDivisions(2,1).IDGlobal(nIndex),   lineDivisions(3,1).IDGlobal(nIndex),...
%                        lineDivisions(3,1).IDGlobal(nIndex+1),   lineDivisions(2,1).IDGlobal(nIndex+1)...
%                        ];
%          if nIndex == 1
%            endofaces = [endofaces; elID, 3]; 
%          end
%          if nIndex == NLayers
%              epifaces= [epifaces; elID, 5];
%          end
%          
%      end
%     
% end
% 
% %%for apical region 
% for elCoarse = apexEleStartNo_ori : size(elem_ori,1)
%     
%     node_el = elem_ori(elCoarse, 1:8);
%     lineDivisions = dividingEdges(node_el, node_ori,NLayers);
%    
%     for lineIndex = 1 : 4
%         IDGlobal = lineDivisions(lineIndex,1).IDGlobal;
%         for nIndex = 2 : NLayers
%             nID = nID + 1;
%             IDGlobal(nIndex) = nID;
%             %%update the nodes
%             node(nID,1:3) = [lineDivisions(lineIndex,1).xnew(nIndex), ...
%                              lineDivisions(lineIndex,1).ynew(nIndex), ...
%                              lineDivisions(lineIndex,1).znew(nIndex)];
%         end
%         lineDivisions(lineIndex,1).IDGlobal = IDGlobal;
%     end
%     
%      %%%adding the elem
%      for nIndex = 1 : NLayers
%          elID = elID + 1;
%          elem(elID,1:8) = [lineDivisions(1,1).IDGlobal(nIndex),   lineDivisions(4,1).IDGlobal(nIndex),...
%                        lineDivisions(4,1).IDGlobal(nIndex+1),   lineDivisions(1,1).IDGlobal(nIndex+1),...
%                        lineDivisions(2,1).IDGlobal(nIndex),   lineDivisions(3,1).IDGlobal(nIndex),...
%                        lineDivisions(3,1).IDGlobal(nIndex+1),   lineDivisions(2,1).IDGlobal(nIndex+1)...
%                        ];
%          if nIndex == 1
%            endofaces = [endofaces; elID, 3]; 
%          end
%          if nIndex == NLayers
%              epifaces= [epifaces; elID, 5];
%          end
%          
%      end
%     
% end



 
 



