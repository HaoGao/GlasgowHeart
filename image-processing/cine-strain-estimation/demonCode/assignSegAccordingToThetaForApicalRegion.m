%%%assing node according to theta
%%%value will be from 1 to 6 as infSept, antSept, ant, antLat, infLat, and
%%%inf
function value = assignSegAccordingToThetaForApicalRegion(theta,ApexConfig)

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


%%%check for AntSept
if ApexConfig.AntTheta.crossZero == 0
    if theta <= ApexConfig.AntTheta.upperBound && theta >= ApexConfig.AntTheta.lowerBound
        value = 2;
    end
else
    if (theta>=0 && theta<=ApexConfig.AntTheta.lowerBound) ||(theta<=360 && theta>=ApexConfig.AntTheta.upperBound)
        value = 2;
    end
end

%%%check for Ant
if ApexConfig.Lat.crossZero == 0
    if theta <= ApexConfig.Lat.upperBound && theta >= ApexConfig.Lat.lowerBound
        value = 3;
    end
else
    if (theta>=0 && theta<=ApexConfig.Lat.lowerBound) ||(theta<=360 && theta>=ApexConfig.Lat.upperBound)
        value = 3;
    end
end

%%%check for AntLat
if ApexConfig.Inf.crossZero == 0
    if theta <= ApexConfig.Inf.upperBound && theta >= ApexConfig.Inf.lowerBound
        value = 4;
    end
else
    if (theta>=0 && theta<=ApexConfig.Inf.lowerBound) ||(theta<=360 && theta>=ApexConfig.Inf.upperBound)
        value = 4;
    end
end






