function [heartNode, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_node, epiB, endoB)

%%% define the node in difference surfaces 
%%% inner node is 0
NoOfFace = size(heart_face,1);

indexEndoSurf = 0;
indexEpiSurf = 0;

epiSurf = [];
endoSurf = [];
heartNode=zeros([size(heart_node,1),size(heart_node,2)+1]);
%%%the +1 is for the lableing the point

for i = 1 : size(heart_node,1)
   heartNode(i,1:4)=heart_node(i,1:4);
end


for i =1: NoOfFace
    NodeTemp = heart_face(i,2:5);
    if epiB == heart_face(i,6)
        indexEpiSurf = indexEpiSurf + 1;
        epiSurf(indexEpiSurf,:)=NodeTemp;
        heartNode(NodeTemp(1),5)=epiB;
        heartNode(NodeTemp(2),5)=epiB;
        heartNode(NodeTemp(3),5)=epiB;
        heartNode(NodeTemp(4),5)=epiB;
    elseif endoB == heart_face(i,6)
        indexEndoSurf = indexEndoSurf + 1;
        endoSurf(indexEndoSurf,:)=NodeTemp;
        heartNode(NodeTemp(1),5)=endoB;
        heartNode(NodeTemp(2),5)=endoB;
        heartNode(NodeTemp(3),5)=endoB;
        heartNode(NodeTemp(4),5)=endoB;
    end
end


