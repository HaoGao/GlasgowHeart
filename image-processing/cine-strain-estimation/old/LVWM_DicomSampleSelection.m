%%%%select the proper dicom images for short axis and long axis
clear all; 
close all;
clc;


LVWM_config;


%%%for short axis
protocolName = 'tf2d12_retro_iPAT_6mm';
scanTimeSeries(1) = 153142;
scanTimeSeries(2) = 153522;
scanTimeSeries(3) = 153613;
scanTimeSeries(4) = 153701;
scanTimeSeries(5) = 153740;
scanTimeSeries(6) = 153912;
scanTimeSeries(7) = 153953;
scanTimeSeries(8) = 154125;

%%%for LVOT
protocolName_LVOT = 'tf2d12_retro_iPAT_6mm_lvot';
% protocolName_4Ch = 'tf2d12_retro_iPAT_6mm_4ch';
scanTimeSeries_LVOT(1) = 155745;
scanTimeSeries_LVOT(2) = 155959;
scanTimeSeries_LVOT(3) = 160102;
scanTimeSeries_LVOT(4) = 160241;
scanTimeSeries_LVOT(5) = 160326;
scanTimeSeries_LVOT(6) = 160404;
scanTimeSeries_LVOT(7) = 160447;



imageList = dir(dicomDir);
imageList = imageList(3:end,:);
imTotalNo = size(imageList,1);



cd(dicomDir);
imNumber = 1;
for imNo = 1 : imTotalNo
    imName = imageList(imNo).name;
    imInfo = dicominfo(imName);
    scanTime = imInfo.SeriesTime(1:6);
    scanTime = str2num(scanTime);
    
    %%%for short axis
    if strcmp(imInfo.ProtocolName,protocolName) == 1
        for SXSliceIndex = 1 : totalSXSliceLocation
            if scanTime == scanTimeSeries(SXSliceIndex)
                TimeInstance = imInfo.InstanceNumber;
                SXSlice(SXSliceIndex).Time(TimeInstance).name = imName;
            end
        end
%     elseif strcmp(imInfo.ProtocolName,protocolName_LVOT) == 1 || strcmp(imInfo.ProtocolName,protocolName_4Ch)==1
    elseif strcmp(imInfo.ProtocolName,protocolName_LVOT) == 1 
         for LVOTSliceIndex = 1 : totalLVOTSliceLocation
            if scanTime == scanTimeSeries_LVOT(LVOTSliceIndex)
                TimeInstance = imInfo.InstanceNumber;
                LVOTSlice(LVOTSliceIndex).Time(TimeInstance).name = imName;
            end
        end
    end
end

%%%sort according to the location
for SXSliceIndex = 1 : totalSXSliceLocation
    imName = SXSlice(SXSliceIndex).Time(1).name;
    imInfo = dicominfo(imName);
    SXSliceLocation(SXSliceIndex) = imInfo.SliceLocation;
end
[SXSliceLocationSorted, SXID] = sort(SXSliceLocation);
for SXSliceIndex = 1 : totalSXSliceLocation
    SXSliceSorted(SXSliceIndex) = SXSlice(SXID(SXSliceIndex));
end
%%%for LVOT
for LVOTSliceIndex = 1 : totalLVOTSliceLocation
    imName = LVOTSlice(LVOTSliceIndex).Time(1).name;
    imInfo = dicominfo(imName);
    LVOTSliceLocation(LVOTSliceIndex) = imInfo.SliceLocation;
end
[LVOTSliceLocationSorted, LVOTID] = sort(LVOTSliceLocation);
for LVOTSliceIndex = 1 : totalLVOTSliceLocation
    LVOTSliceSorted(LVOTSliceIndex) = LVOTSlice(LVOTID(LVOTSliceIndex));
end



cd(workingDir);
cd(resultDir);
save imDesired SXSlice LVOTSlice SXSliceSorted LVOTSliceSorted;
cd(workingDir);    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
