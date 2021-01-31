%%%this is the main APP sing bspline deformable registration
%%%currently it only works with 6 pre-defined regions 
clear all; clc; close all
restoredefaultpath;

% LVWM_config; %%this is a general set up
LVWM_config;

path(path,'./bsplineDeform');
path(path, './demonCode');

sliceSelected = 1; %%% the range is from 1 to usuableSXSlice
% if reversedSequence
%     sliceSelected = usuableSXSlice - sliceSelected + 1;
% end
imcropBool = 1;
bsplineDeformBool = 1;
EndoEpiBCManualSegBool = 1;
sampleN = 100;

%%%setup a result dir for deformable image Registration 
cd(resultDir);
dirName = sprintf('deformRes_slice_intra%d', sliceSelected);
if ~exist(dirName,'dir')
    mkdir(dirName);
end
cd(dirName);
ResDefDir = pwd();
cd(workingDir);

cd(resultDir);
load imDesired;
cd(workingDir);

%%%now need to extract the right data 
totalSXSliceLocation = size(imDesired.SXSlice, 2);
TimeEndOfSystole = imDesired.TimeEndOfSystole; 
TimeEndOfDiastole = imDesired.TimeEndOfDiastole; 
TimeEarlyOfDiastole =  imDesired.TimeEarlyOfDiastole;
%TimeInstanceSelected = TimeEndOfSystole;
TimeInstanceSelected = TimeEarlyOfDiastole;
% TimeInstanceSelected = 35;

SXSliceSorted = imDesired.SXSlice;

totalInstanceNum = TimeInstanceSelected - TimeEndOfDiastole +1;
InstanceSelectedSeries = TimeEndOfDiastole : 1: TimeInstanceSelected;

for InstanceNo = 1 : totalInstanceNum
    imInstance = InstanceSelectedSeries(InstanceNo);
    imData = SXSliceSorted(1,sliceSelected).SXSlice(imInstance,1).imData;
    imInfo = SXSliceSorted(1,sliceSelected).SXSlice(imInstance,1).imInfo;
    
    imgList(InstanceNo,1).imData = imData;
    imgList(InstanceNo,1).imInfo = imInfo;
end
    
cd(workingDir);

%%total Img no
imgTotalNo = size(imgList,1);

% %%%we can show the images are the required images 
% figure; hold on; 
% for imNo = 1 : imgTotalNo
%     imshow(imgList(imNo,1).imData,[]); 
%     pause;
% end

%%% we need to crop the images to reduce the computation time
 if imcropBool == 1
    [I1Crop rect] = imcrop(imgList(1,1).imData,[]);
 else
    cd(ResDefDir);
    load imgDeformedBsplineRe;
    clear imgDeformed;
    cd(workingDir);
 end
 close all;
 
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
    
    endoTN = boundaryTracking(endoT, Tx, Ty);
    epiTN = boundaryTracking(epiT, Tx, Ty);
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
 
% movie(F,3);
% cd(resultDir);
% movie2avi(F,'tracedMotion.avi');
% cd(workingDir);

%%%strain map for circumferential and radial strain
imNoShow = TimeInstanceSelected;
hCContour=figure();
hRContour=figure();
RectPlot(LVPointsTotalPhases(imNoShow).LVPoints,LVMesh,LVStrainTotal(imNoShow).cir,imcrop(imgList(imNoShow,1).imData,imgDeformed(imNoShow-1,1).rect),hCContour);
RectPlot(LVPointsTotalPhases(imNoShow).LVPoints,LVMesh,LVStrainTotal(imNoShow).rad,imcrop(imgList(imNoShow,1).imData,imgDeformed(imNoShow-1,1).rect),hRContour);

% %%%now need to summarize strain at difference regions
cd(resultDir); 
load DivisionConfig;
cd(workingDir);
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
    end
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
end

%%%%this is for validating the division blue: inferior septum; black =
%%%%anterior septum; red is in the fourth and sixth, depending on the 
hLVmeshDvision = figure();
imshow(imcrop(imgList(imNo,1).imData,imgDeformed(imNo,1).rect),[]);hold on;
LVMeshShowcolorStr(LVPoints,LVMeshCor,hLVmeshDvision); 


h1 = figure(); hold on; title('cir strian curves for one slice')
set(gca, 'FontSize',16);
showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(cirInfSeptTotal, cirAntSeptTotal,  cirAntTotal,  cirAntLatTotal,  cirInfLatTotal, cirInfTotal,h1);
%  
h2 = figure(); title('rad strian curves for one slice')
showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(radInfSeptTotal, radAntSeptTotal,  radAntTotal,  radAntLatTotal,  radInfLatTotal, radInfTotal,h2);
%
%%save results
cd(ResDefDir);
fileName = sprintf('cirStrainSlice%d',sliceSelected);
print(h1, fileName, '-dpng');
fileName = sprintf('radStrainSlice%d',sliceSelected);
print(h2, fileName, '-dpng');
% 
save BsplineResult_slice cirInfSeptTotal cirAntSeptTotal cirAntTotal cirAntLatTotal cirInfLatTotal cirInfTotal radInfSeptTotal radAntSeptTotal  radAntTotal  radAntLatTotal  radInfLatTotal   radInfTotal;
cd(workingDir)


close all;

 