function strainComparison = strainCompasrisonBasedOnSegs(strainData, strainDataAbaqusSegRegions)
%%will output the strain no matter whether segStrainAbaqus is ok or not,
%%which will be rechecked later. we shall have 24 regions output

strainMRITotal = [];
strainAbaTotal = [];
strainDiff = [];

for planeIndex = 1 : size(strainData,2)
    sliceNo = strainData(1,planeIndex).sliceNo;
    segStrain = strainData(1,planeIndex).segStrain;
    segStrainB = strainData(1,planeIndex).segStrainB;
    
    segStrainAbaqus = strainDataAbaqusSegRegions(1,sliceNo).segStrian;
    
    for i = 1 : length(segStrainB)
      %  if segStrainB(i)>0 && ~isnan(segStrainAbaqus(i))
        if segStrainB(i)>0  
            strainMRITotal = [strainMRITotal segStrain(i)];
            strainAbaTotal = [strainAbaTotal segStrainAbaqus(i)];
        end
    end
    
end

strainDiff = strainMRITotal - strainAbaTotal;

strainComparison.strainMRITotal = strainMRITotal;
strainComparison.strainAbaTotal = strainAbaTotal;
strainComparison.strainDiff = strainDiff;

