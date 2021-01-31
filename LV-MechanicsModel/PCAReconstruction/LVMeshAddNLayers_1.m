function abaqusInputPCAReconstruction = LVMeshAddNLayers(abaqusInputPCAReconstructionOneLayerMesh, NLayers)

%%only work for hex mesh

abaqusInputData = abaqusInputPCAReconstructionOneLayerMesh;
node_ori = abaqusInputPCAReconstructionOneLayerMesh.node;
elem_ori = abaqusInputPCAReconstructionOneLayerMesh.elem;
endofaces_ori = abaqusInputPCAReconstructionOneLayerMesh.endofaces;
epifaces_ori = abaqusInputPCAReconstructionOneLayerMesh.epifaces;
apexEleStartNo_ori = abaqusInputPCAReconstructionOneLayerMesh.apexEleStartNo;
scaleTomm_ori = abaqusInputPCAReconstructionOneLayerMesh.scaleTomm;

node = node_ori;
elem = [];
endofaces = [];
epifaces = [];

%%no need to add original nodes if they are already existed, only the
%%middle points
%%first step, loop element above apexEleStartNo_ori
elCoarse = 1;
nCoarse = 1;
nID = size(node_ori,1);%%existed node ID
elID = 0;
for elCoarse = 1 : apexEleStartNo_ori-1
    node_el = elem_ori(elCoarse, 1:8);
    
    
    
    
    lineDivisions = dividingEdges(node_el, node_ori,NLayers);
   
    for lineIndex = 1 : 4
        IDGlobal = lineDivisions(lineIndex,1).IDGlobal;
        for nIndex = 2 : NLayers
            nID = nID + 1;
            IDGlobal(nIndex) = nID;
            %%update the nodes
            node(nID,1:3) = [lineDivisions(lineIndex,1).xnew(nIndex), ...
                             lineDivisions(lineIndex,1).ynew(nIndex), ...
                             lineDivisions(lineIndex,1).znew(nIndex)];
        end
        lineDivisions(lineIndex,1).IDGlobal = IDGlobal;
    end
    
     %%%adding the elem
     for nIndex = 1 : NLayers
         elID = elID + 1;
         elem(elID,1:8) = [lineDivisions(1,1).IDGlobal(nIndex),   lineDivisions(4,1).IDGlobal(nIndex),...
                       lineDivisions(4,1).IDGlobal(nIndex+1),   lineDivisions(1,1).IDGlobal(nIndex+1),...
                       lineDivisions(2,1).IDGlobal(nIndex),   lineDivisions(3,1).IDGlobal(nIndex),...
                       lineDivisions(3,1).IDGlobal(nIndex+1),   lineDivisions(2,1).IDGlobal(nIndex+1)...
                       ];
         if nIndex == 1
           endofaces = [endofaces; elID, 3]; 
         end
         if nIndex == NLayers
             epifaces= [epifaces; elID, 5];
         end
         
     end
    
end

%%for apical region 
for elCoarse = apexEleStartNo_ori : size(elem_ori,1)
    
    node_el = elem_ori(elCoarse, 1:8);
    lineDivisions = dividingEdges(node_el, node_ori,NLayers);
   
    for lineIndex = 1 : 4
        IDGlobal = lineDivisions(lineIndex,1).IDGlobal;
        for nIndex = 2 : NLayers
            nID = nID + 1;
            IDGlobal(nIndex) = nID;
            %%update the nodes
            node(nID,1:3) = [lineDivisions(lineIndex,1).xnew(nIndex), ...
                             lineDivisions(lineIndex,1).ynew(nIndex), ...
                             lineDivisions(lineIndex,1).znew(nIndex)];
        end
        lineDivisions(lineIndex,1).IDGlobal = IDGlobal;
    end
    
     %%%adding the elem
     for nIndex = 1 : NLayers
         elID = elID + 1;
         elem(elID,1:8) = [lineDivisions(1,1).IDGlobal(nIndex),   lineDivisions(4,1).IDGlobal(nIndex),...
                       lineDivisions(4,1).IDGlobal(nIndex+1),   lineDivisions(1,1).IDGlobal(nIndex+1),...
                       lineDivisions(2,1).IDGlobal(nIndex),   lineDivisions(3,1).IDGlobal(nIndex),...
                       lineDivisions(3,1).IDGlobal(nIndex+1),   lineDivisions(2,1).IDGlobal(nIndex+1)...
                       ];
         if nIndex == 1
           endofaces = [endofaces; elID, 3]; 
         end
         if nIndex == NLayers
             epifaces= [epifaces; elID, 5];
         end
         
     end
    
end



 
 



