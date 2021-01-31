function strainDataAbaqusSegRegions = segRegionsStrainSummarization(sliceRegions, fiberStrain_cra, elem, endoNodes)

segplanes = size(sliceRegions,2);
%%%the apex top is the last segplane with value to be 7.

for planeIndex = 1 : segplanes-1
    if isfield(sliceRegions, 'segRegionsSlicesPlane')
        segRegionsSlicesPlane = sliceRegions(1,planeIndex).segRegionsSlicesPlane;
        segMax = max(segRegionsSlicesPlane);
    else
        segRegionsSlicesPlane = sliceRegions(1,planeIndex).segRegions;
        segMax = max(segRegionsSlicesPlane);
    end
    
    seg1 = [];
    seg2 = [];
    seg3 = [];
    seg4 = [];
    seg5 = [];
    seg6 = [];
    
    
    for elemIndex = 1 : size(elem,1)
        nodeSeq = elem(elemIndex,:);
        for nodeIndex = 1 : length(nodeSeq)
            
%             if segRegionsSlicesPlane(nodeSeq(nodeIndex)) >0 && (~isempty(find(endoNodes == nodeSeq(nodeIndex), 1)) || ~isempty(find(epiNodes == nodeSeq(nodeIndex), 1)))
            if (segRegionsSlicesPlane(nodeSeq(nodeIndex)) >0) && (~isempty(find(endoNodes == nodeSeq(nodeIndex), 1)) )
                if segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 1
                    seg1 = [seg1 fiberStrain_cra(elemIndex)];
                elseif segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 2
                    seg2 = [seg2 fiberStrain_cra(elemIndex)];
                elseif segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 3
                    seg3 = [seg3 fiberStrain_cra(elemIndex)];
                elseif segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 4
                    seg4 = [seg4 fiberStrain_cra(elemIndex)];
                elseif segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 5
                    seg5 = [seg5 fiberStrain_cra(elemIndex)];
                elseif segRegionsSlicesPlane(nodeSeq(nodeIndex)) == 6
                    seg6 = [seg6 fiberStrain_cra(elemIndex)];
                end
                
                
            end%%%if
            
            
        end%%for nodeIndex
        
        
    end%%%for elemIndex
        
    strainDataAbaqusSegRegions(planeIndex).segRegionNumber = segMax;
    strainDataAbaqusSegRegions(planeIndex).segStrian = [mean(seg1) mean(seg2) mean(seg3) mean(seg4) mean(seg5) mean(seg6)];
   
end



