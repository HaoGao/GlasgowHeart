%%%%show the dicom in 3D together for one time instance
clear all;
close all;
clc;

LVWM_config;

cd(resultDir);
load imDesired;
cd(workingDir); 

totalSXSliceLocation = size(SXSliceSorted,2);
timeInstanceSelected = patientConfigs.timeInstanceSelected;
sampleN = patientConfigs.sampleN;
totalLVOTSliceLocation = size(LVOTSliceSorted,2);

LGESASlice = imDesired.LGESASlice; 
totalLGESliceLocation = size(LGESASlice,1);

timeInstance = timeInstanceSelected;

for imIndex = 1 : totalSXSliceLocation
    
    imDataTempory = SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imData;
    imInfo1 = SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imInfo;
    imInfo = infoExtract(imInfo1);
    imDataT = MRIMapToRealWithImageAndHeadData(imDataTempory, imInfo);

    imData(imIndex).im = imDataT;
    
    %%output to tecplot format
    tecFileName = sprintf('SASlice_%d_Tec.dat', imIndex);
    imgTecplotOutput(imDataT,tecFileName,resultDir);
    
    
    imDataT = [];
end

for imIndex = 1 : totalLVOTSliceLocation
    imDataTempory = LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imData;
    imInfo1 = LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imInfo;
    imInfo = infoExtract(imInfo1);
    imDataT = MRIMapToRealWithImageAndHeadData(imDataTempory, imInfo);
    
    imData(imIndex+totalSXSliceLocation).im = imDataT;
    
    %%output to tecplot format
    tecFileName = sprintf('LASlice_%d_Tec.dat', imIndex);
    imgTecplotOutput(imDataT,tecFileName,resultDir);
    
    imDataT = [];
end



%%output LGE image data 
for imIndex = 1 : totalLGESliceLocation
    imDataTempory = imDesired.LGESASlice(imIndex).imData;
    imInfo1 = imDesired.LGESASlice(imIndex).imInfo;
    imInfo = infoExtract(imInfo1);
    imDataT = MRIMapToRealWithImageAndHeadData(imDataTempory, imInfo);
    
    imData(imIndex+totalSXSliceLocation + totalLVOTSliceLocation).im = imDataT;
    
    %%output to tecplot format
    tecFileName = sprintf('LGE_MI_Slice_%d_Tec.dat', imIndex);
    imgTecplotOutput(imDataT,tecFileName,resultDir);
    
    imDataT = [];
    
end




%%% Display the Dicom image in 3D
h3D = figure(); hold on;
for imIndex = 1 : totalSXSliceLocation+floor(totalLVOTSliceLocation/2)
    imDataT = imData(imIndex).im;
    DicomeRealDisplay(h3D, imDataT);
end
%%%Display the segmented LV boundary from short Axis
h3D1 = figure(); hold on;
for imIndex = totalSXSliceLocation+1 : totalSXSliceLocation+floor(totalLVOTSliceLocation/2)
    imDataT = imData(imIndex).im;
    DicomeRealDisplay(h3D1, imDataT);
end

cd(resultDir);
load DataSegSA;
cd(workingDir);
for imIndex = 1 : totalSXSliceLocation
    endo_c = DataSegSA(imIndex).endo_cReal;
    epi_c = DataSegSA(imIndex).epi_cReal;
    %%%%plot 3D curves
    hold on;
    plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
    plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
end