function [strainAba17, strain_segs]= segRegionsStrainSummarization(AHALVMeshDivision, fiberStrain_cra, elem, endoNodes, endoSummaryOnly)


elRegions = AHALVMeshDivision.elRegions;

elRegionsFull = AHALVMeshDivision.elRegionsFull; %%means we can use the top 4 slices, usually the first two slices are combined

%% the following is for AHA17 segments
for i = 1 : max(elRegions)
    strainDataAbaqusSegRegions(i,1).strain = [];
    strainAba17(i,1) = 0;
end


for elemIndex = 1 : size(elem,1)
    nodeSeq = elem(elemIndex, :);
    if endoSummaryOnly
    %% decide whether this elemment in endo 
        onEndo = 0;
        for nodeIndex = 1 : length(nodeSeq)
            if (~isempty(find(endoNodes == nodeSeq(nodeIndex), 1)) )
                onEndo = 1;
                break;
            end
        end

        if onEndo  %%that will be save for processing
            regionIndex = elRegions(elemIndex);
            strain = strainDataAbaqusSegRegions(regionIndex,1).strain;
            strain = [strain fiberStrain_cra(elemIndex)];
            strainDataAbaqusSegRegions(regionIndex,1).strain = strain;
        end
    else
        regionIndex = elRegions(elemIndex);
        strain = strainDataAbaqusSegRegions(regionIndex,1).strain;
        strain = [strain fiberStrain_cra(elemIndex)];
        strainDataAbaqusSegRegions(regionIndex,1).strain = strain;
    end %endoSummaryOnly

    
end


for i = 1 : max(elRegions)
    strainAba17(i) = mean(strainDataAbaqusSegRegions(i,1).strain);
end


%% that is for each slice
for i = 1 : max(elRegionsFull(:))   
    strainDataAbaqusSegRegions_segs(i,1).strain = [];
    strain_segs(i,1) = 0; 
end

for elemIndex = 1 : size(elem,1)
    nodeSeq = elem(elemIndex, :);
    if endoSummaryOnly
        %% decide whether this elemment in endo 
        onEndo = 0;
        for nodeIndex = 1 : length(nodeSeq)
            if (~isempty(find(endoNodes == nodeSeq(nodeIndex), 1)) )
                onEndo = 1;
                break;
            end
        end

        if  onEndo  %%that will be save for processing
            regionIndex = elRegionsFull(elemIndex);
            strain = strainDataAbaqusSegRegions_segs(regionIndex,1).strain;
            strain = [strain fiberStrain_cra(elemIndex)];
            strainDataAbaqusSegRegions_segs(regionIndex,1).strain = strain;
        end
        
    else
            regionIndex = elRegionsFull(elemIndex);
            strain = strainDataAbaqusSegRegions_segs(regionIndex,1).strain;
            strain = [strain fiberStrain_cra(elemIndex)];
            strainDataAbaqusSegRegions_segs(regionIndex,1).strain = strain;
        
    end %% endoSummaryOnly
    
end


for i = 1 : max(elRegionsFull)
    strain_segs(i) = mean(strainDataAbaqusSegRegions_segs(i,1).strain);
end


