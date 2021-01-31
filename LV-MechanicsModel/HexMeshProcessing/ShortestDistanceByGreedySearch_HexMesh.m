function nodeDistance = ShortestDistanceByGreedySearch_HexMesh(heart_node,endoSurf,epiSurf, epiB, endoB, innerB)

Nnode = size(heart_node,1);

nodeDistance = zeros([size(heart_node,1) 1]);

for inode = 1 : Nnode
    if heart_node(inode,5)==  epiB
        nodeDistance(inode)= 1;
    elseif heart_node(inode,5) == endoB
        nodeDistance(inode)=0;
    elseif heart_node(inode,5) == innerB
        p = heart_node(inode,2:4);
        [indexEndo dendo] = DistanceFromPointToSurfaceArray(p,endoSurf,heart_node, innerB);
        [indexEpi depi]   = DistanceFromPointToSurfaceArray(p,epiSurf, heart_node, innerB);
        nodeDistance(inode,1)=dendo/(depi+dendo);
        nodeDistance(inode,2)=indexEndo;
        nodeDistance(inode,3)=indexEpi;
%           if mod(inode,100)==0
%               inode
%           end
%           pause;
    else

    end
  
end


function [indexi dendo] = DistanceFromPointToSurface(p,Surf,heart_node, innerB)
N = size(Surf,1);
N2 = size(Surf,2);

d = 10000;
indexi=0;
for i = 1 : N
    for j = 1 : N2
        pt = heart_node(Surf(i,j),2:4);
        dt = (pt(1)-p(1))^2+(pt(2)-p(2))^2+(pt(3)-p(3))^2;
        if dt < d
            d = dt;
            indexi = Surf(i,j);
        end
    end
end
dendo = d^0.5;

if heart_node(indexi,5)==innerB
       disp('wrong');
       pause;
end


function [indexi dendo] = DistanceFromPointToSurfaceArray(p,Surf,heart_node, innerB)
SurfT = Surf(:);
%%%set up the point matrix
% for i = 1 : N
%     for j = 1 : 3
%         ptTotal(i,1:4)=[Surf(i,j) heart_node(Surf(i,j),2:4)];
%     end
% end
ptTotal = heart_node(Surf,1:4); 


dT = ((ptTotal(:,2)-p(1)).^2+(ptTotal(:,3)-p(2)).^2 + (ptTotal(:,4)-p(3)).^2).^0.5;
indexDt = find(dT == min(dT));
indexi = ptTotal(indexDt(1),1);
dendo = min(dT);
