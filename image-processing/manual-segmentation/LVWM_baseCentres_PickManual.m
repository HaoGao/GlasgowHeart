function LVWM_baseCentres_PickManual()

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
totalLASliceLocation = size(LVOTSliceSorted,2);

%%%now only consider one slice per position, usually the first one
if segB == 1
   %%%initialize 
   
    %%% determine the short axis base centre, the first image 
     imData = SXSliceSorted(1,1).SXSlice(timeInstanceSelected).imData;
     imInfo1 = SXSliceSorted(1,1).SXSlice(timeInstanceSelected).imInfo;
     imInfo = infoExtract(imInfo1);
     BSA = 1;
     DataSeg = ManualPickFunction(imData, imInfo, BSA); % click twice, first for endo and then for epi
     BaseSACentre.endo_c = DataSeg.endo_c;
     BaseSACentre.epi_c  = DataSeg.epi_c;
     BaseSACentre.endo_cReal = DataSeg.endo_cReal;
     BaseSACentre.epi_cReal = DataSeg.epi_cReal;
     
    
    %%%then do the segmentation 
    for imIndex = 1 : totalLASliceLocation
        imData =  LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imData;
        imInfo1 = LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imInfo;
        imInfo = infoExtract(imInfo1);
        BSA = 0;
        DataSeg = ManualPickFunction(imData, imInfo, BSA); % two points for endo and two points for epi
               
        LABaseStartEnd(imIndex).endo_c = DataSeg.endo_c;
        LABaseStartEnd(imIndex).epi_c = DataSeg.epi_c;
        LABaseStartEnd(imIndex).endo_cReal = DataSeg.endo_cReal;
        LABaseStartEnd(imIndex).epi_cReal = DataSeg.epi_cReal ;    
    end
    
    
    cd(resultDir);
    save BaseSACentre BaseSACentre;
    save LABaseStartEnd LABaseStartEnd;
    cd(workingDir); 
    
   
    
    

else
    cd(resultDir);
    load BaseSACentre;
    load LABaseStartEnd;
    cd(workingDir);    
end



%plot the short axis image 
imData = SXSliceSorted(1,1).SXSlice(timeInstanceSelected).imData;
hSA = figure; 
imshow(imData, []); hold on;
plot(BaseSACentre.endo_c(1,1), BaseSACentre.endo_c(2,1), 'r+'); hold on;
plot(BaseSACentre.epi_c(1,1), BaseSACentre.epi_c(2,1), 'b*'); hold on;

for imIndex = 1 : totalLASliceLocation
    imData =  LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imData;
    figure();
    imshow(imData,[]); hold on;
    plot(LABaseStartEnd(imIndex).endo_c(1,1), LABaseStartEnd(imIndex).endo_c(2,1), 'r+'); hold on;
    plot(LABaseStartEnd(imIndex).endo_c(1,2), LABaseStartEnd(imIndex).endo_c(2,2), 'r+'); hold on;
    plot(LABaseStartEnd(imIndex).epi_c(1,1), LABaseStartEnd(imIndex).epi_c(2,1), 'b*'); hold on;
    plot(LABaseStartEnd(imIndex).epi_c(1,2), LABaseStartEnd(imIndex).epi_c(2,2), 'b*'); hold on;
    
end









    

function DataSegSA = ManualPickFunction(imData, imInfo, BSA)
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

 
        if BSA
             [x, y]=ginput(1);
             plot(x,y,'b.');hold on;
             endo_c(1,1)=x;
             endo_c(2,1)=y;

             [x, y ]=ginput(1);
             plot(x,y,'r.');hold on;
             epi_c(1,1)=x;
             epi_c(2,1)=y;
        else % for long axis, first two for endo and then for epi
             
            [x, y]=ginput(1);
             plot(x,y,'b.');hold on;
             endo_c(1,1)=x;
             endo_c(2,1)=y;
             
             [x, y]=ginput(1);
             plot(x,y,'b.');hold on;
             endo_c(1,2)=x;
             endo_c(2,2)=y;
             

             [x, y ]=ginput(1);
             plot(x,y,'r.');hold on;
             epi_c(1,1)=x;
             epi_c(2,1)=y;
             
             [x, y ]=ginput(1);
             plot(x,y,'r.');hold on;
             epi_c(1,2)=x;
             epi_c(2,2)=y;
            
            
        end
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
        







