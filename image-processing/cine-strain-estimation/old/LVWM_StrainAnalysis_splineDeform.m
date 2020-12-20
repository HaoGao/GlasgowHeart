%%%this is the main APP sing bspline deformable registration
%%%currently it only works with 6 pre-defined regions 
clear all; clc; close all
% LVWM_config; %%this is a general set up
LVWM_config;

path(path,'./bsplineDeform');
path(path, './demonCode');

sliceSelected = 3; %%% the range is from 1 to usableSXSlice
% if reversedSequence
%     sliceSelected = usuableSXSlice - sliceSelected + 1;
% end
imcropBool = 0;
bsplineDeformBool = 0;
EndoEpiBCManualSegBool = 0;
ImgDivisionManualB = 0;
sampleN = 100;

%%%setup a result dir for deformable image Registration 
cd(resultDir);
dirName = sprintf('deformRes_slice%d', sliceSelected);
if ~exist(dirName,'dir')
    mkdir(dirName);
end
cd(dirName);
ResDefDir = pwd();
cd(workingDir);

cd(resultDir);
load imDesired;
cd(workingDir);

cd(dicomDir);
%totalInstanceNum = timeInstanceSelected - timeInstanceSelectedDiastile +1;
totalInstanceNum = totalTimeInstance;
% InstanceSelectedSeries = timeInstanceSelectedDiastile : 1: timeInstanceSelected;
for InstanceNo = 1 : totalInstanceNum
%     imInstance = InstanceSelectedSeries(InstanceNo);
    imName = SXSliceSorted(1,sliceSelected).Time(1,InstanceNo).name;
    imData = dicomread(imName);
    imInfo = dicominfo(imName);
    
    imgList(InstanceNo,1).imName = imName;
    imgList(InstanceNo,1).imData = imData;
    imgList(InstanceNo,1).imInfo = imInfo;
end
    
cd(workingDir);

%%total Img no
imgTotalNo = size(imgList,1);

% %%%we can show the images are the required images 
h = figure; hold on; 
for imNo = 1 : imgTotalNo
    imshow(imgList(imNo,1).imData,[]); 
    titleStr = sprintf('slice Position %d, image %d (%d)' ,sliceSelected, imNo,totalInstanceNum);
    title(titleStr);
    pause(0.1);
end

pause(1); 
if exist('h','var')
  close(h);
end

%%% we need to crop the images to reduce the computational time
if imcropBool == 1
    h = figure();
    imshow(imgList(1,1).imData,[]); 
    titleStr= sprintf('zoom into LV and drag a region of interest!');
    title(titleStr);
    [I1Crop rect] = imcrop(h);
    if exist('h','var')
    close(h);
end
else
    cd(ResDefDir);
    load imgDeformedBsplineRe;
    clear imgDeformed;
    cd(workingDir);
end

 
 options.type='sd';
 options.centralgrad=false;
 options.penaltypercentage=0.01;
 options.interpolation='cubic';

 Spacing=[8 8];
 
% %%now deform
if bsplineDeformBool == 1
    for imNo = 1 : imgTotalNo-1
        I1 = imgList(imNo,1).imData;
        I2 = imgList(imNo+1,1).imData;

        I1Crop = imcrop(I1,rect);
        I2Crop = imcrop(I2,rect);
        close all;

        [I1 I2] = NormalizeImageLinear(I1Crop, I2Crop);
        [Tx Ty] = BsplineDeformHG(I1, I2, options, Spacing);

        imgDeformed(imNo,1).Tx = Tx;
        imgDeformed(imNo,1).Ty = Ty;
        imgDeformed(imNo,1).rect = rect;

    end
end


if bsplineDeformBool == 1
    cd(ResDefDir);
    save imgDeformedBsplineRe imgDeformed rect;
    cd(workingDir);
end

 %%v%now tracking the bcs
 cd(ResDefDir);
 load imgDeformedBsplineRe;
 cd(workingDir)

 %%%segment the first image
 imNo = 1;
 
if EndoEpiBCManualSegBool == 1
    [endoT epiT]= manualSegEndoEpi(imcrop(imgList(imNo,1).imData,imgDeformed(imNo,1).rect), sampleN);
    cd(ResDefDir);
    save EndoEpiBc endoT epiT;
    cd(workingDir);
end

cd(ResDefDir);
load EndoEpiBc;
cd(workingDir);

shapex = mean(endoT(:,1));
shapey = mean(endoT(:,2));

 h1 = figure; hold on;
 imshow(imcrop(imgList(imNo,1).imData,imgDeformed(imNo,1).rect),[]);hold on;
 plot(endoT(:,1),endoT(:,2),'-');
 plot(epiT(:,1),epiT(:,2),'-');
 F(imNo) = getframe;
 
 %%%mesh generation
[LVMesh LVPoints] = EndoEpiMeshGeneration(endoT,epiT,sampleN);
LVMeshShow(LVPoints,LVMesh,h1);
LVPointsTotalPhases(1).LVPoints = LVPoints;
 
 for imNo = 1 : imgTotalNo-1
    Tx = imgDeformed(imNo,1).Tx;
    Ty = imgDeformed(imNo,1).Ty;
    
    %endoTN = boundaryTrackingWithoutCutoff(endoT, Tx, Ty);
    %epiTN =  boundaryTrackingWithoutCutoff(epiT, Tx, Ty);
    endoTN = boundaryTracking_floatingPoint(endoT, Tx, Ty);
    epiTN =  boundaryTracking_floatingPoint(epiT, Tx, Ty);
    endoT = endoTN;
    epiT = epiTN;
    
    %%LVpoints update
    LVPointsUpdate = [endoT; epiT];
    LVPointsTotalPhases(imNo+1).LVPoints = LVPointsUpdate;
    
    pause(0.1);
%     pause;
    imshow(imcrop(imgList(imNo+1,1).imData,imgDeformed(imNo,1).rect),[]);
    plot(endoT(:,1),endoT(:,2),'-');
    plot(epiT(:,1),epiT(:,2),'r-');
    LVMeshShow(LVPointsUpdate,LVMesh,h1);
    F(imNo+1) = getframe; 
    titleStr = sprintf('image %d (%d)', imNo+1,imgTotalNo );
    title(titleStr);
    
    %%%strain calculation
    LVStrain = FiniteStrainForRect(LVMesh,LVPointsUpdate,LVPointsTotalPhases(1).LVPoints,shapex,shapey);
    
    for pindex = 1 : sampleN
        E11(pindex) = LVStrain(1,pindex).strain(1,1);
        E22(pindex) = LVStrain(1,pindex).strain(2,2);
        rad(pindex) = LVStrain(1,pindex).crstrain(1,1);
        cir(pindex) = LVStrain(1,pindex).crstrain(2,2);
    end
    
    LVStrainTotal(imNo+1).E11 = E11;
    LVStrainTotal(imNo+1).E22 = E22;
    LVStrainTotal(imNo+1).rad = rad;
    LVStrainTotal(imNo+1).cir = cir;
 end
 
 if exist('h1', 'var')
     close(h1);
 end
 
 
% movie(F,3);
% cd(ResDefDir);
% movie2avi(F,'tracedMotion.avi');
% cd(workingDir);

%%%strain map for circumferential and radial strain
imNoShow = timeInstanceSelectedSystole;
hCContour=figure();
hRContour=figure();
RectPlot(LVPointsTotalPhases(imNoShow).LVPoints,LVMesh,LVStrainTotal(imNoShow).cir,imcrop(imgList(imNoShow,1).imData,imgDeformed(imNoShow-1,1).rect),hCContour);
RectPlot(LVPointsTotalPhases(imNoShow).LVPoints,LVMesh,LVStrainTotal(imNoShow).rad,imcrop(imgList(imNoShow,1).imData,imgDeformed(imNoShow-1,1).rect),hRContour);
figure(hCContour);
title('circumferential strain map at end systole');
figure(hRContour);
title('radial strain map at end systole');


%%%decide the slice postion is in apical or not
if sliceSelected < SASlicePositionApex 
    MiddleSliceB = 1;
else
    MiddleSliceB = 0;
end

% %%%now need to summarize strain at difference regions
if ImgDivisionManualB == 1
    [MidConfig, ApexConfig] = AHADefinitionManual(imgList(1,1).imData, MiddleSliceB);
    cd(ResDefDir);
    save DivisionConfig MidConfig ApexConfig;
    cd(workingDir);
else
    cd(ResDefDir); 
    load DivisionConfig;
    cd(workingDir);
end
% 
% % centerP = mean(LVPoints);
% % for nodeIndex = 1 : size(LVPoints,1)
% %     theta = degreeCalculationPointBased(p,centerPoint);
% %     value = assignSegAccordingToThetaForMiddleRegion(theta,MidConfig);
% %     segRegions(nodeIndex) = value;
% % end
centerP = mean(LVPoints);
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
            value = assignSegAccordingToThetaForMiddleRegion(theta,MidConfig);
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
            value = assignSegAccordingToThetaForApicalRegion(theta,ApexConfig);
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
imshow(imcrop(imgList(imNo,1).imData,imgDeformed(imNo,1).rect),[]);hold on;
LVMeshShowcolorStr(LVPoints,LVMeshCor,hLVmeshDvision); 
titleStr = sprintf('LV division illustration');
title(titleStr);
cd(ResDefDir);
fileName = sprintf('LVDivision%d',sliceSelected);
print(hLVmeshDvision, fileName, '-dpng');
cd(workingDir);

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
cd(ResDefDir);
fileName = sprintf('cirStrainSlice%d',sliceSelected);
print(h1, fileName, '-dpng');
fileName = sprintf('radStrainSlice%d',sliceSelected);
print(h2, fileName, '-dpng');


%%%output the results in a text file
if MiddleSliceB == 1
    fileName = sprintf('cirStrainSlice%d.txt',sliceSelected);
    fid = fopen(fileName,'w');
    fprintf(fid, 'InfSept\t AntSept\t Ant\t Antlat\t InfLat\t inf\n');
    for i = 1 : length(cirInfSeptTotal)
        fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\n',cirInfSeptTotal(i), cirAntSeptTotal(i), ...
            cirAntTotal(i), cirAntLatTotal(i),cirInfLatTotal(i), cirInfTotal(i));
    end
    fclose(fid);

    fileName = sprintf('radStrainSlice%d.txt',sliceSelected);
    fid = fopen(fileName,'w');
    fprintf(fid, 'InfSept\t AntSept\t Ant\t Antlat\t InfLat\t inf\n');
    for i = 1 : length(radInfSeptTotal)
        fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\n',radInfSeptTotal(i), radAntSeptTotal(i), ...
           radAntTotal(i), radAntLatTotal(i),radInfLatTotal(i), radInfTotal(i));
    end
    fclose(fid);
else
    fileName = sprintf('cirStrainSlice%d.txt',sliceSelected);
    fid = fopen(fileName,'w');
    fprintf(fid, 'Sept\t Ant\t lat\t  inf\n');
    for i = 1 : length(cirSeptTotal)
        fprintf(fid, '%f\t%f\t%f\t%f\n',cirSeptTotal(i), cirAntTotal(i), ...
            cirLatTotal(i), cirInfTotal(i));
    end
    fclose(fid);

    fileName = sprintf('radStrainSlice%d.txt',sliceSelected);
    fid = fopen(fileName,'w');
    fprintf(fid, 'Sept\t  Ant\t lat\t  inf\n');
    for i = 1 : length(radSeptTotal)
        fprintf(fid, '%f\t%f\t%f\t%f\n',radSeptTotal(i),  ...
           radAntTotal(i), radLatTotal(i), radInfTotal(i));
    end
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

 
 
%%%strain map calculation
StrainMapTotal = strainMapCalculation(imgList(imNo,1).imData, imgDeformed, endoT, epiT);
%%%superimpose the strain value on LV wall
hCirStrainMap= figure();hold on;
imshow(StrainMapTotal(timeInstanceSelectedSystole).CirStrainLV,[]);hold on;
colormap('jet')
caxis([-0.3 0.1]);
colorbar;
axis 'tight'
% contour(LVRoi,[0 0], 'Color','k');
% h= imshow(I1OG,[]);
% hold off;
% alpha_data = LVRoi;
% set(h,'AlphaData',alpha_data);
hRadStrainMap= figure();hold on;
imshow(StrainMapTotal(timeInstanceSelectedSystole).RadStrainLV,[]);hold on;
colormap('jet')
caxis([-0.1 0.6]);
colorbar;
axis 'tight'
% contour(LVRoi,[0 0], 'Color','k');

%%save results
cd(ResDefDir);
fileName = sprintf('cirStrainMap%dFrame%d',sliceSelected,timeInstanceSelectedSystole);
print(hCirStrainMap, fileName, '-dpng');
fileName = sprintf('radStrainMap%dFrame%d',sliceSelected,timeInstanceSelectedSystole);
print(hRadStrainMap, fileName, '-dpng');
cd(workingDir);



 