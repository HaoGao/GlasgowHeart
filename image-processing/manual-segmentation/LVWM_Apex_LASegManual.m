function LVWM_Apex_LASegManual()

%%%SA segmentation
clear all;
close all;
clc;

% LVWM_config;
LVWM_config;
segB = 1;

cd(resultDir);
load imDesired;
load DataSegLAOri;
cd(workingDir); 


totalSXSliceLocation = size(SXSliceSorted,2);
timeInstanceSelected = patientConfigs.timeInstanceSelected;
sampleN = patientConfigs.sampleN;
totalLASliceLocation = size(LVOTSliceSorted,2);

%%%now only consider one slice per position, usually the first one
if segB == 1
   %%%initialize 
    
   

    
    %%%then do the segmentation 
    for imIndex = 1 : totalLASliceLocation
        imData =  LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imData;
        imInfo1 = LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imInfo;
        imInfo = infoExtract(imInfo1);
        DataSeg = LAManualSegFunction(imData, imInfo);
        
        
        Apex_endo(imIndex).endo_c = DataSeg.endo_c;
        Apex_epi(imIndex).epi_c = DataSeg.epi_c;
        Apex_endo(imIndex).endo_cReal = DataSeg.endo_cReal;
        Apex_epi(imIndex).epi_cReal = DataSeg.epi_cReal ;
        
        
        
        
    end
    cd(resultDir);
    save Apex_location Apex_endo Apex_epi;
    cd(workingDir); 

else
    cd(resultDir);
    load Apex_location;
    cd(workingDir);    
end

%%%to show the boundaries in 3D with short axis views
imData = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imData;
imInfo1 = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imInfo;
imInfo = infoExtract(imInfo1);
imData = MRIMapToRealWithImageAndHeadData(imData, imInfo);

h3D = figure(); hold on;
DicomeRealDisplay(h3D, imData);

for imIndex = 1 : totalLASliceLocation
% for imIndex = 3:3
    endo_c = DataSegLA(imIndex).endo_cReal;
    epi_c = DataSegLA(imIndex).epi_cReal;
    %%%%plot 3D curves
    plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
    plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);

    apex_endo_c = Apex_endo(imIndex).endo_cReal;
    apex_epi_c = Apex_epi(imIndex).epi_cReal;
    plot3(apex_endo_c(1), apex_endo_c(2),apex_endo_c(3), 'Marker', 'o', 'MarkerFaceColor', 'b');
    plot3(apex_epi_c(1), apex_epi_c(2),apex_epi_c(3), 'Marker', '+', 'MarkerFaceColor', 'r');


end






    

function DataSegSA = LAManualSegFunction(imData, imInfo)
%     imData = Slice(TimeInstanceSelected,1).imData;
%     imInfo1 = Slice(TimeInstanceSelected,1).imInfo;
%     imInfo = infoExtract(imInfo1);
    [imCropData, rect] = imcrop(imData,[]);

        h1=figure();
        imshow(imCropData,[]);hold on;

        endo_c=[];
        epi_c=[];
        endo_cc=[];
        epi_cc=[];
        endo_sample=[];
        epi_sample=[];

 
        
         [x, y]=ginput(1);
         plot(x,y,'b.');hold on;
         endo_c(1,1)=x;
         endo_c(2,1)=y;
        
%         ni=[];nni=[];
%         ni=1:length(endo_c(1,:));
%         nni=1:0.5:length(endo_c(1,:));
%         endo_cc(1,:)=spline(ni,endo_c(1,:) , nni);
%         endo_cc(2,:)=spline(ni,endo_c(2,:) , nni);

%         while but==1
            [x, y ]=ginput(1);
            plot(x,y,'r.');hold on;
            epi_c(1,1)=x;
            epi_c(2,1)=y;
%             n=n+1;
%         end
%         nei=[];nnei=[];
%         nei=1:length(epi_c(1,:));
%         nnei=1:0.5:length(epi_c(1,:));
%         epi_cc(1,:)=spline(nei,epi_c(1,:), nnei);
%         epi_cc(2,:)=spline(nei,epi_c(2,:) , nnei);

%         [endo_sample, epi_sample] = samplingBCWithoutIm(endo_cc, epi_cc,sampleN);

        endo_sample(1,:) = endo_c(1,:) +rect(1);
        endo_sample(2,:) = endo_c(2,:) +rect(2);
        epi_sample(1,:) = epi_c(1,:) +rect(1);
        epi_sample(2,:) = epi_c(2,:) +rect(2);

%         h1=figure();
%         imshow(imData,[]); hold on;
%         plot(endo_sample(1,:),endo_sample(2,:),'b');
%         plot(epi_sample(1,:),epi_sample(2,:),'r');

        pause;
        close all;

        endo_cReal = TransformCurvesFromImToRealSpace(endo_sample,imInfo);
        epi_cReal = TransformCurvesFromImToRealSpace(epi_sample,imInfo);


        DataSegSA.endo_c = endo_sample;
        DataSegSA.epi_c = epi_sample;
        DataSegSA.endo_cReal = endo_cReal;
        DataSegSA.epi_cReal = epi_cReal;
        







