function  dof = dof_map(elemT, totalNodes, component)
%%currently does not support dof for the element, but only in the node

nodesNo = length(elemT);
dof = zeros([nodesNo,1]);

for i = 1 : nodesNo
    dof(i) = totalNodes*(component-1)+ elemT(i);
end