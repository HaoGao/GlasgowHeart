 %%%assing node according to theta
%%%value will be from 1 to 6 as infSept, antSept, ant, antLat, infLat, and
%%%inf
function value = assignSegAccordingToThetaForMiddleRegion(theta,MidConfig)

value = 0;

%%%check for InfSept
if MidConfig.InfSeptTheta.crossZero == 0
    if theta <= MidConfig.InfSeptTheta.upperBound && theta >= MidConfig.InfSeptTheta.lowerBound
        value = 1;
    end
else
    if (theta>=0 && theta<=MidConfig.InfSeptTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.InfSeptTheta.upperBound)
        value = 1;
    end
end


%%%check for AntSept
if MidConfig.AntSeptTheta.crossZero == 0
    if theta <= MidConfig.AntSeptTheta.upperBound && theta >= MidConfig.AntSeptTheta.lowerBound
        value = 2;
    end
else
    if (theta>=0 && theta<=MidConfig.AntSeptTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.AntSeptTheta.upperBound)
        value = 2;
    end
end

%%%check for Ant
if MidConfig.AntTheta.crossZero == 0
    if theta <= MidConfig.AntTheta.upperBound && theta >= MidConfig.AntTheta.lowerBound
        value = 3;
    end
else
    if (theta>=0 && theta<=MidConfig.AntTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.AntTheta.upperBound)
        value = 3;
    end
end

%%%check for AntLat
if MidConfig.AntLatTheta.crossZero == 0
    if theta <= MidConfig.AntLatTheta.upperBound && theta >= MidConfig.AntLatTheta.lowerBound
        value = 4;
    end
else
    if (theta>=0 && theta<=MidConfig.AntLatTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.AntLatTheta.upperBound)
        value = 4;
    end
end

%%%check for InfLat
if MidConfig.InfLatTheta.crossZero == 0
    if theta <= MidConfig.InfLatTheta.upperBound && theta >= MidConfig.InfLatTheta.lowerBound
        value = 5;
    end
else
    if (theta>=0 && theta<=MidConfig.InfLatTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.InfLatTheta.upperBound)
        value = 5;
    end
end


%%%check for Inf
if MidConfig.InfTheta.crossZero == 0
    if theta <= MidConfig.InfTheta.upperBound && theta >= MidConfig.InfTheta.lowerBound
        value = 6;
    end
else
    if (theta>=0 && theta<=MidConfig.InfTheta.lowerBound) ||(theta<=360 && theta>=MidConfig.InfTheta.upperBound)
        value = 6;
    end
end






