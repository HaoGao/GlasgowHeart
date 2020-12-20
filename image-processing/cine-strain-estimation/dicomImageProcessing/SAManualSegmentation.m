%%%SAmanual segmentation
% function SAManualSegmentation(resultDir, hWindow)
clear all; close all; clc;

resultDir = 'C:\Users\Hao_2\Google Drive\paper_writing\LV_material_parameters\bSplineStrainAnalysis\sampleResults\LVModelGeneration\MR-IMR-201-24hours';
workingDir = pwd();


cd(resultDir);
if exist('imDesired.mat', 'file')
    load imDesired;
    SXSlice = imDesired.SXSlice;
    clear imDesired;
else
    errordlg('imDesired has not been loaded properly, please check!');
end
cd(workingDir);

totalSXSliceLocation = size(SXSlice,2);
TotalTimeInstance =  size(SXSlice(1,1).SXSlice, 1);


TimeSelected = sprintf('%d', 15);
SlicePositionSelectedBeginning = sprintf('%d', 1);
SlicePositionSelectedEnd       = sprintf('%d', totalSXSliceLocation);
sampleN = 50;

%%%if hWindow exist, then we will plot the segmenation in 3D
prompt = {'select the time for segmentation','select the starting position', 'the end position'};
dlg_title = 'Input for peaks function';
num_lines = 1;
def = {TimeSelected,SlicePositionSelectedBeginning, SlicePositionSelectedEnd};
answer = inputdlg(prompt,dlg_title,num_lines,def);


TimeSelected = str2num(answer{1});
SlicePositionSelectedBeginning = str2num(answer{2});
SlicePositionSelectedEnd = str2num(answer{3});

%%%now set up the data structure for boundary segmentation
cd(resultDir);
if exist('DataSegSA.mat', 'file')
    load DataSegSACardiacCycle;
else 
    data.rect= [];
    data.endo_c = [];
    data.epi_c = [];
    for timeIndex = 1 : TotalTimeInstance
        for imIndex = 1 : totalSXSliceLocation
            DataSegSA(imIndex)=data;
        end
        DataSegSACardiacCycle(timeIndex).DataSegSA = DataSegSA;
        clear DataSegSA;
    end
    clear data;
    
    save DataSegSACardiacCycle DataSegSACardiacCycle;
    cd(workingDir);
end

%%%now do the segmentation 
DataSegSA = DataSegSACardiacCycle(TimeSelected).DataSegSA;
for imIndex = SlicePositionSelectedBeginning : SlicePositionSelectedEnd  
    
    imData = SXSlice(1,imIndex).SXSlice(TimeSelected,1).imData;
    imInfo1 = SXSlice(1,imIndex).SXSlice(TimeSelected,1).imInfo;
    imInfo = infoExtract(imInfo1);
    
    [imCropData rect] = imcrop(imData,[]);
    
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

        figure(h1); hold off;
        imshow(imData,[]); hold on;
        sliceLocationStr = sprintf('slice  %d', imIndex);
        title(sliceLocationStr);
        plot(endo_sample(1,:),endo_sample(2,:),'b');
        plot(epi_sample(1,:),epi_sample(2,:),'r');

        pause;
        close(h1);

        endo_cReal = TransformCurvesFromImToRealSpace(endo_sample,imInfo);
        epi_cReal = TransformCurvesFromImToRealSpace(epi_sample,imInfo);


        DataSegSA(imIndex).endo_c = endo_sample;
        DataSegSA(imIndex).epi_c = epi_sample;
        DataSegSA(imIndex).endo_cReal = endo_cReal;
        DataSegSA(imIndex).epi_cReal = epi_cReal;

        
end
DataSegSACardiacCycle(TimeSelected).DataSegSA = DataSegSA;

%%now update the segmented data 
cd(resultDir);
save DataSegSACardiacCycle DataSegSACardiacCycle;
cd(workingDir);

%%%to show the boundaries in 3D with long axis views
% imFileName = LVOTSliceSorted(3).Time(timeInstanceSelected).name;
imDataT = SXSlice(1,floor(totalSXSliceLocation/2)).SXSlice(TimeSelected,1).imData;
imInfo1 = SXSlice(1,floor(totalSXSliceLocation/2)).SXSlice(TimeSelected,1).imInfo;
imInfo = infoExtract(imInfo1);
imData = MRIMapToRealWithImageAndHeadData(imDataT, imInfo);
clear imDataT;
clear imInfo1;


%%%now show the figures 
if exist('h3D', 'var')
    figure(h3D); hold on;
    DicomeRealDisplay(h3D, imData);

    for imIndex = 1 : totalSXSliceLocation
    % for imIndex = 3:3
        endo_c = DataSegSA(imIndex).endo_cReal;
        epi_c = DataSegSA(imIndex).epi_cReal;
        if ~isempty(endo_c)
        %%%%plot 3D curves
            plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
        end
        if ~isempty(epi_c)
            plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
        end
    end
end
   






