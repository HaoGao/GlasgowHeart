%%%SA segmentation
clear all;
close all;
clc;

% LVWM_config;
LVWM_config;
segB = 1;

cd(resultDir);
load imDesired;
cd(workingDir); 

totalSXSliceLocation = size(SXSliceSorted,2);
timeInstanceSelected = patientConfigs.timeInstanceSelected;
sampleN = patientConfigs.sampleN;

if segB == 1
    %%%initialize 
    for imIndex = 1 : totalSXSliceLocation
        data.rect = [];
        data.endo_c = [];
        data.epi_c = [];
        DataSegSA(imIndex)=data;
    end
    clear data;
    % cd(resultDir);
    % save DataSegSA DataSegSA
    % cd(workingDir); 

    for imIndex = 1 : totalSXSliceLocation
%         imFileName = SXSliceSorted(imIndex).Time(timeInstanceSelected).name;
%         imFileName = sprintf('%s/%s',dicomDir,imFileName);
%         imData = dicomread(imFileName);
%         imInfo1 = dicominfo(imFileName);
        imData =  SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imData;
        imInfo1 = SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imInfo;
        imInfo = infoExtract(imInfo1);
        sliceLocationStr = sprintf('%s',imInfo.SliceLocation);
        [imCropData, rect] = imcrop(imData,[]);

        h1=figure();
        imshow(imCropData,[]);hold on;

        endo_c=[];
        epi_c=[];
        endo_cc=[];
        epi_cc=[];
        endo_sample=[];
        epi_sample=[];

        but = 1;
        n=1;
        while but ==1 
            [x y but]=ginput(1);
            plot(x,y,'b.');hold on;
            endo_c(1,n)=x;
            endo_c(2,n)=y;
            n=n+1;
        end
        ni=[];nni=[];
        ni=1:length(endo_c(1,:))+1;
        nni=1:0.1:length(endo_c(1,:))+1;
        endo_cc(1,:)=spline(ni,[endo_c(1,:) endo_c(1,1)], nni);
        endo_cc(2,:)=spline(ni,[endo_c(2,:) endo_c(2,1)], nni);

        n=1;but=1;
        while but==1
            [x y but]=ginput(1);
            plot(x,y,'r.');hold on;
            epi_c(1,n)=x;
            epi_c(2,n)=y;
            n=n+1;
        end
        nei=[];nnei=[];
        nei=1:length(epi_c(1,:))+1;
        nnei=1:0.1:length(epi_c(1,:))+1;
        epi_cc(1,:)=spline(nei,[epi_c(1,:) epi_c(1,1)], nnei);
        epi_cc(2,:)=spline(nei,[epi_c(2,:) epi_c(2,1)], nnei);

        [endo_sample, epi_sample] = samplingBCWithoutIm(endo_cc, epi_cc,sampleN);

        endo_sample(1,:) = endo_sample(1,:) +rect(1);
        endo_sample(2,:) = endo_sample(2,:) +rect(2);
        epi_sample(1,:) = epi_sample(1,:) +rect(1);
        epi_sample(2,:) = epi_sample(2,:) +rect(2);

        h1=figure();
        imshow(imData,[]); hold on;
        title(sliceLocationStr);
        plot(endo_sample(1,:),endo_sample(2,:),'b');
        plot(epi_sample(1,:),epi_sample(2,:),'r');

        pause;
        close all;

        endo_cReal = TransformCurvesFromImToRealSpace(endo_sample,imInfo);
        epi_cReal = TransformCurvesFromImToRealSpace(epi_sample,imInfo);


        DataSegSA(imIndex).endo_c = endo_sample;
        DataSegSA(imIndex).epi_c = epi_sample;
        DataSegSA(imIndex).endo_cReal = endo_cReal;
        DataSegSA(imIndex).epi_cReal = epi_cReal;


    end

    cd(resultDir);
    save DataSegSA DataSegSA;
    save DataSegSAOri DataSegSA;
    cd(workingDir); 

else
    cd(resultDir);
    load DataSegSA;
    cd(workingDir);
end

%%%to show the boundaries in 3D with long axis views
% imFileName = LVOTSliceSorted(3).Time(timeInstanceSelected).name;
% imFileName = SXSliceSorted(4).Time(timeInstanceSelected).name;
% imFileName = sprintf('%s/%s',dicomDir,imFileName);
% imData = MRIMapToReal(imFileName);

imData = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imData;
imInfo1 = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imInfo;
imInfo = infoExtract(imInfo1);
imData = MRIMapToRealWithImageAndHeadData(imData, imInfo);


h3D = figure(); hold on;
DicomeRealDisplay(h3D, imData);

for imIndex = 1 : totalSXSliceLocation
% for imIndex = 3:3
    endo_c = DataSegSA(imIndex).endo_cReal;
    epi_c = DataSegSA(imIndex).epi_cReal;
    %%%%plot 3D curves
    plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
    plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
end

imgTecplotOutput(imData,'SAslice3Tec.dat',resultDir);
%%%this is for apex info










