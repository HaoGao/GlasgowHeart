function segRegions = ApexSliceDivision(nodeMat,zUpper,zLower,centerPoint, ApexConfig)

for nodeIndex = 1 : size(nodeMat,1)
    segRegions(nodeIndex) = 0;
    pT = nodeMat(nodeIndex,2:4);
    if pT(3)>=zLower && pT(3)<=zUpper
        theta = degreeCalculationPointBased([pT(1) pT(2)],centerPoint)*180/pi; %%%need to change it to be degree
        regionValue = assignSegAccordingToThetaForApexRegion(theta,ApexConfig);
        segRegions(nodeIndex)=regionValue;
    end
end


function value = assignSegAccordingToThetaForApexRegion(theta,ApexConfig)
%%%assing node according to theta
%%%value will be from 1 to 6 as Sept(1), ant(3),Lat(4), inf(6)
value = 0;

%%%check for Sept
if ApexConfig.SeptTheta.crossZero == 0
    if theta <= ApexConfig.SeptTheta.upperBound && theta >= ApexConfig.SeptTheta.lowerBound
        value = 1;
    end
else
    if (theta>=0 && theta<=ApexConfig.SeptTheta.lowerBound) ||(theta<=360 && theta>=ApexConfig.SeptTheta.upperBound)
        value = 1;
    end
end


%%%check for Ant
if ApexConfig.AntTheta.crossZero == 0
    if theta <= ApexConfig.AntTheta.upperBound && theta >= ApexConfig.AntTheta.lowerBound
        value = 3;
    end
else
    if (theta>=0 && theta<=ApexConfig.AntTheta.lowerBound) ||(theta<=360 && theta>=ApexConfig.AntTheta.upperBound)
        value = 3;
    end
end

%%%check for Lat
if ApexConfig.Lat.crossZero == 0
    if theta <= ApexConfig.Lat.upperBound && theta >= ApexConfig.Lat.lowerBound
        value = 4;
    end
else
    if (theta>=0 && theta<=ApexConfig.Lat.lowerBound) ||(theta<=360 && theta>=ApexConfig.Lat.upperBound)
        value = 4;
    end
end

%%%check for Lat
if ApexConfig.Inf.crossZero == 0
    if theta <= ApexConfig.Inf.upperBound && theta >= ApexConfig.Inf.lowerBound
        value = 6;
    end
else
    if (theta>=0 && theta<=ApexConfig.Inf.lowerBound) ||(theta<=360 && theta>=ApexConfig.Inf.upperBound)
        value = 6;
    end
end

