function regionalStrainCalculationOutput(resultDir, LVStrainTotal, LVPointsTotalPhases, ... 
                                 patient_slice_data, cropConfig, DivisionConfig, MiddleSliceB)

workingDir = pwd();    
centerP = mean(LVPointsTotalPhases(1).LVPoints);
imgTotalNo = size(LVPointsTotalPhases,2);
LVMesh = LVPointsTotalPhases(1).LVMesh;
LVPoints = LVPointsTotalPhases(1).LVPoints;


for imNoShow = 2 : imgTotalNo
    cirInfSept=[]; cirAntSept=[]; cirAnt=[]; cirAntLat=[];cirInfLat=[];cirInf=[];
    radInfSept=[]; radAntSept=[]; radAnt=[]; radAntLat=[];radInfLat=[];radInf=[];
    
    %%for apical region 
    cirSept = []; cirLat = [];
    radSept = []; radLat = [];

    cirStrain = LVStrainTotal(imNoShow).cir;
    radStrain = LVStrainTotal(imNoShow).rad;
    LVMeshCor = LVMesh;
    for elemIndex = 1 : size(LVMesh,1)
        nodesList = LVMesh(elemIndex,:);
        p1 = LVPoints(nodesList(1),:);
        p2 = LVPoints(nodesList(2),:);
        p3 = LVPoints(nodesList(3),:);
        p4 = LVPoints(nodesList(4),:);

        elemCenter = mean([p1;p2;p3;p4]);
        theta = degreeCalculationPointBased(elemCenter,centerP)*180/pi;
        
        if MiddleSliceB
            value = assignSegAccordingToThetaForMiddleRegion(theta,DivisionConfig.MidConfig);
    % 
            if   value == 1
               cirInfSept =  [cirInfSept cirStrain(elemIndex)];
               radInfSept =  [radInfSept radStrain(elemIndex)];
               LVMeshCor(elemIndex,5) = 1;
            elseif value == 2
                cirAntSept =  [cirAntSept cirStrain(elemIndex)];
                radAntSept =  [radAntSept radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 2;
            elseif value == 3
                cirAnt =  [cirAnt cirStrain(elemIndex)];
                radAnt =  [radAnt radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 3;
            elseif value == 4
                cirAntLat =  [cirAntLat cirStrain(elemIndex)];
                radAntLat =  [radAntLat radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 4;
            elseif value == 5
                cirInfLat =  [cirInfLat cirStrain(elemIndex)];
                radInfLat =  [radInfLat radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 5;
            elseif value == 6
                cirInf =  [cirInf cirStrain(elemIndex)];
                radInf =  [radInf radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 6;
            end
        else
            value = assignSegAccordingToThetaForApicalRegion(theta,DivisionConfig.ApexConfig);
            if value == 1
                cirSept = [cirSept cirStrain(elemIndex)];
                radSept = [radSept radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 1; 
            elseif value == 2
                cirAnt = [cirAnt cirStrain(elemIndex)];
                radAnt = [radAnt radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 2; 
            elseif value == 3
                cirLat = [cirLat cirStrain(elemIndex)];
                radLat = [radLat radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 3;
            elseif value == 4
                cirInf = [cirInf cirStrain(elemIndex)];
                radInf = [radInf radStrain(elemIndex)];
                LVMeshCor(elemIndex,5) = 4;
            end %%%if value==1 
            
        end
        
    end
    
    if MiddleSliceB == 1
        cirInfSeptTotal(imNoShow) = mean(cirInfSept);
        cirAntSeptTotal(imNoShow) = mean(cirAntSept);
        cirAntTotal(imNoShow) = mean(cirAnt);
        cirAntLatTotal(imNoShow) = mean(cirAntLat);
        cirInfLatTotal(imNoShow) = mean(cirInfLat);
        cirInfTotal(imNoShow) = mean(cirInf);
    % 

        radInfSeptTotal(imNoShow) = mean(radInfSept);
        radAntSeptTotal(imNoShow) = mean(radAntSept);
        radAntTotal(imNoShow) = mean(radAnt);
        radAntLatTotal(imNoShow) = mean(radAntLat);
        radInfLatTotal(imNoShow) = mean(radInfLat);
        radInfTotal(imNoShow) = mean(radInf);
    else
        cirSeptTotal(imNoShow)= mean(cirSept);
        cirAntTotal(imNoShow) = mean(cirAnt);
        cirLatTotal(imNoShow) = mean(cirLat);
        cirInfTotal(imNoShow) = mean(cirInf);
    % 

        radSeptTotal(imNoShow)= mean(radSept);
        radAntTotal(imNoShow) = mean(radAnt);
        radLatTotal(imNoShow) = mean(radLat);
        radInfTotal(imNoShow) = mean(radInf);
        
    end%%%MiddleSliceB summarization
            
end

%%%%this is for validating the division blue: inferior septum; black =
%%%%anterior septum; red is in the fourth and sixth, depending on the 
hLVmeshDvision = figure();
imshow(imcrop(patient_slice_data.SXSlice(1,1).imData,cropConfig.rect),[]);hold on;
LVMeshShowcolorStr(LVPoints,LVMeshCor,hLVmeshDvision); 
titleStr = sprintf('LV division illustration');
title(titleStr);

cd(resultDir);
fileName = sprintf('LVDivision');
print(hLVmeshDvision, fileName, '-dpng');
cd(workingDir);
pause(1);
close(hLVmeshDvision);

h1 = figure(); title('cir strian curves for one slice')
if MiddleSliceB == 1
    showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(cirInfSeptTotal, ... 
    cirAntSeptTotal,  cirAntTotal,  cirAntLatTotal,  cirInfLatTotal, cirInfTotal,h1);
else
    showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(cirSeptTotal, ... 
    cirAntTotal,  cirLatTotal, cirInfTotal, [], [],h1);
end

%  
h2 = figure(); title('rad strian curves for one slice')
if MiddleSliceB == 1
    showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(radInfSeptTotal, ...
        radAntSeptTotal,  radAntTotal,  radAntLatTotal,  radInfLatTotal, radInfTotal,h2);
else
    showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(radSeptTotal, ...
        radAntTotal,  radLatTotal,  radInfTotal, [], [], h2);
end
%
%%save results
cd(resultDir);
fileName = sprintf('cirStrainSlice');
print(h1, fileName, '-dpng');
fileName = sprintf('radStrainSlice');
print(h2, fileName, '-dpng');

pause(1);
close(h1);
close(h2);



%%%output the results in a text file
if MiddleSliceB == 1
    fileName = sprintf('cirStrainSlice.txt');
    fid = fopen(fileName,'w');
    fprintf(fid, 'Trigger\t InfSept\t AntSept\t Ant\t Antlat\t InfLat\t inf \t global\n');
    
    %%%global mean circumferential strain 
    cir_global = (cirInfSeptTotal + cirAntSeptTotal + cirAntTotal + cirAntLatTotal + cirInfLatTotal + cirInfTotal)./6;
    
    for i = 1 : length(cirInfSeptTotal)
        
        %%%now need to extract the scanning time 
        imInfo = patient_slice_data.SXSlice(i,1).imInfo;
        triggerTime = imInfo.TriggerTime;
        triggerTimeSequence(i) = triggerTime;
        fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t %f\n',triggerTime, cirInfSeptTotal(i), cirAntSeptTotal(i), ...
            cirAntTotal(i), cirAntLatTotal(i),cirInfLatTotal(i), cirInfTotal(i), cir_global(i));
    end
    
    %%%calculate the min value 
    [cirInfSeptTotal_max, cirInfSeptTotal_maxID] = min(cirInfSeptTotal);
    [cirAntSeptTotal_max, cirAntSeptTotal_maxID] = min(cirAntSeptTotal);
    [cirAntTotal_max, cirAntTotal_maxID] = min(cirAntTotal);
    [cirAntLatTotal_max, cirAntLatTotal_maxID] = min(cirAntLatTotal);
    [cirInfLatTotal_max, cirInfLatTotal_maxID] = min(cirInfLatTotal);
    [cirInfTotal_max, cirInfTotal_maxID] = min(cirInfTotal);
    [cir_global_max, cir_global_maxID] = min(cir_global);
    fprintf(fid, 'max regional strain value\n');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\t %f\t %f\n',cirInfSeptTotal_max(1),cirAntSeptTotal_max(1), ...
                                                    cirAntTotal_max(1), cirAntLatTotal_max(1), ...
                                                    cirInfLatTotal_max(1), cirInfTotal_max(1), ...
                                                    cir_global_max(1));
    fprintf(fid, 'timing of the peaks (ms)\n ');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\t %f\t %f\n',triggerTimeSequence(cirInfSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirAntSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirAntTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirAntLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirInfLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirInfTotal_maxID(1)), ...
                                                     triggerTimeSequence(cir_global_maxID(1)));
    
    
    fclose(fid);
    
    
    
    
    
    %%%global mean radial  strain 
    rad_global = (radInfSeptTotal + radAntSeptTotal + radAntTotal + radAntLatTotal + radInfLatTotal + radInfTotal)./6;
    fileName = sprintf('radStrainSlice.txt');
    fid = fopen(fileName,'w');
    fprintf(fid, 'Trigger\t InfSept\t AntSept\t Ant\t Antlat\t InfLat\t inf\n');
    for i = 1 : length(radInfSeptTotal)
        %%%now need to extract the scanning time 
        imInfo = patient_slice_data.SXSlice(i,1).imInfo;
        triggerTime = imInfo.TriggerTime;
        triggerTimeSequence(i) = triggerTime;
        
        fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t %f\n',triggerTime, radInfSeptTotal(i), radAntSeptTotal(i), ...
           radAntTotal(i), radAntLatTotal(i),radInfLatTotal(i), radInfTotal(i), rad_global(i));
    end
    
    
    %%%calculate the maximum value 
    [radInfSeptTotal_max, radInfSeptTotal_maxID] = max(radInfSeptTotal);
    [radAntSeptTotal_max, radAntSeptTotal_maxID] = max(radAntSeptTotal);
    [radAntTotal_max, radAntTotal_maxID] = max(radAntTotal);
    [radAntLatTotal_max, radAntLatTotal_maxID] = max(radAntLatTotal);
    [radInfLatTotal_max, radInfLatTotal_maxID] = max(radInfLatTotal);
    [radInfTotal_max, radInfTotal_maxID] = max(radInfTotal);
    [rad_global_max, rad_global_maxID] = max(rad_global);
    fprintf(fid, 'max regional strain value\n');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\t %f\t %f\n',radInfSeptTotal_max(1),radAntSeptTotal_max(1), ...
                                                    radAntTotal_max(1), radAntLatTotal_max(1), ...
                                                    radInfLatTotal_max(1), radInfTotal_max(1), ...
                                                    rad_global_max(1));
    fprintf(fid, 'timing of the peaks (ms)\n ');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\t %f\t %f\n',triggerTimeSequence(radInfSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(radAntSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(radAntTotal_maxID(1)), ...
                                                     triggerTimeSequence(radAntLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(radInfLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(radInfTotal_maxID(1)), ...
                                                     triggerTimeSequence(rad_global_maxID(1)));
    
    
    
    
    fclose(fid);
    
    
else %%this for apical slices
    fileName = sprintf('cirStrainSlice.txt');
    fid = fopen(fileName,'w');
    fprintf(fid, 'Trigger\t Sept\t Ant\t lat\t inf \t global\n');
    
    %%%global mean circumferential strain 
    cir_global = (cirSeptTotal + cirAntTotal + cirLatTotal + cirInfTotal)./4;
    
    for i = 1 : length(cirSeptTotal)
        
        %%%now need to extract the scanning time 
        imInfo = patient_slice_data.SXSlice(i,1).imInfo;
        triggerTime = imInfo.TriggerTime;
        triggerTimeSequence(i) = triggerTime;
        fprintf(fid, '%f\t %f\t%f\t%f\t%f\t %f\n',triggerTime, cirSeptTotal(i), cirAntTotal(i), ...
            cirLatTotal(i), cirInfTotal(i), cir_global(i));
    end
    
    %%%calculate the min value 
    [cirSeptTotal_max, cirSeptTotal_maxID] = min(cirSeptTotal);
    [cirAntTotal_max, cirAntTotal_maxID] = min(cirAntTotal);
    [cirLatTotal_max, cirLatTotal_maxID] = min(cirLatTotal);
    [cirInfTotal_max, cirInfTotal_maxID] = min(cirInfTotal);
    [cir_global_max, cir_global_maxID] = min(cir_global);
    fprintf(fid, 'max regional strain value\n');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\n',cirSeptTotal_max(1), ...
                                                    cirAntTotal_max(1), cirLatTotal_max(1), ...
                                                    cirInfTotal_max(1), ...
                                                    cir_global_max(1));
    fprintf(fid, 'timing of the peaks (ms)\n ');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\n',triggerTimeSequence(cirSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirAntTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(cirInfTotal_maxID(1)), ...
                                                     triggerTimeSequence(cir_global_maxID(1)));
    
    
    fclose(fid);
    
    
    
    
    
    %%%global mean radial  strain 
    rad_global = (radSeptTotal + radAntTotal + radLatTotal +  radInfTotal)./4;
    fileName = sprintf('radStrainSlice.txt');
    fid = fopen(fileName,'w');
    fprintf(fid, 'Trigger\t Sept\t Ant\t lat\t  inf\n');
    for i = 1 : length(radSeptTotal)
        %%%now need to extract the scanning time 
        imInfo = patient_slice_data.SXSlice(i,1).imInfo;
        triggerTime = imInfo.TriggerTime;
        triggerTimeSequence(i) = triggerTime;
        
        fprintf(fid, '%f\t %f\t%f\t%f\t%f\t %f\n',triggerTime, radSeptTotal(i),  ...
           radAntTotal(i), radLatTotal(i), radInfTotal(i), rad_global(i));
    end
    
    
    %%%calculate the maximum value 
    [radSeptTotal_max, radSeptTotal_maxID] = max(radSeptTotal);
    [radAntTotal_max, radAntTotal_maxID] = max(radAntTotal);
    [radLatTotal_max, radLatTotal_maxID] = max(radLatTotal);
    [radInfTotal_max, radInfTotal_maxID] = max(radInfTotal);
    [rad_global_max, rad_global_maxID] = max(rad_global);
    fprintf(fid, 'max regional strain value\n');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t %f\n',radSeptTotal_max(1), ...
                                                    radAntTotal_max(1), radLatTotal_max(1), ...
                                                     radInfTotal_max(1), ...
                                                    rad_global_max(1));
    fprintf(fid, 'timing of the peaks (ms)\n ');
    fprintf(fid, '\t  %f\t %f\t %f\t %f\t  %f\n',triggerTimeSequence(radSeptTotal_maxID(1)), ...
                                                     triggerTimeSequence(radAntTotal_maxID(1)), ...
                                                     triggerTimeSequence(radLatTotal_maxID(1)), ...
                                                     triggerTimeSequence(radInfTotal_maxID(1)), ...
                                                     triggerTimeSequence(rad_global_maxID(1)));
    
    
    
    
    fclose(fid);
    
end

% 
if MiddleSliceB == 1
    save BsplineResult_slice cirInfSeptTotal cirAntSeptTotal cirAntTotal ...
     cirAntLatTotal cirInfLatTotal cirInfTotal radInfSeptTotal radAntSeptTotal  ...
     radAntTotal  radAntLatTotal  radInfLatTotal   radInfTotal;
     
else
    save BsplineResult_slice  cirAntTotal ...
        cirInfTotal     radInfTotal ...
        radAntTotal      ...
        cirSeptTotal cirLatTotal ...
        radSeptTotal radLatTotal;
end

cd(workingDir)