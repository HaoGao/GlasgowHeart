function  nIDEpi= findEpiFromElem(elem, apexEleStartNo, nIDEndo)

Nel = size(elem, 1);
for el = 1 : Nel
    node_el = elem(el,:);
    
    IDX = find(node_el == nIDEndo, 1);
    if ~isempty(IDX)
        if el<apexEleStartNo
            if IDX == 1 
                nIDEpi =node_el(4);
            elseif IDX == 2
                nIDEpi = node_el(3);
            elseif IDX == 6
                nIDEpi = node_el(7);
            elseif IDX == 5
                nIDEpi = node_el(8);
            else
                disp('should never be here in function findEpiFromElem');
            end
            
        else %%this is for apical elements
            if IDX == 1 
                nIDEpi =node_el(5);
            elseif IDX == 2
                nIDEpi = node_el(6);
            elseif IDX == 3
                nIDEpi = node_el(7);
            elseif IDX == 4
                nIDEpi = node_el(8);
            else
                disp('should never be here in function findEpiFromElem');
            end  
            
        end
            
        
    end%%%end of empty
    
    
    
    
end