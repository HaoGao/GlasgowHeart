function lineDivisions = dividingEdges(node_el, node_ori,NLayers)



for i = 1 : 4
    
   
    
    if i==1
        nL = [node_el(1) node_el(4)];
    elseif i==2
        nL = [node_el(5) node_el(8)];
    elseif i==3 
        nL = [node_el(6) node_el(7)];
    elseif i==4
        nL = [node_el(2) node_el(3)];
    end
    
    x = node_ori(nL,1);
    y = node_ori(nL,2);
    z = node_ori(nL,3);
   
    [xnew, ynew, znew] = interp_hg(x, y, z, NLayers);
   
    IDGlobal = zeros(size(xnew));
    IDGlobal(1) = nL(1);
    IDGlobal(end) = nL(2);
    
    lineDivisions(i,1).xnew = xnew;
    lineDivisions(i,1).ynew = ynew;
    lineDivisions(i,1).znew = znew;
    lineDivisions(i,1).IDGlobal = IDGlobal;
    
    
    
    
    
    
end
