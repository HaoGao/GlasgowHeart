%%%short cine images store according to the instance time 

function imageList = cineImageExtract(imageList,dicomDir)

workingDir = pwd();
cd(dicomDir);

imgTotalNo = size(imageList,1);

for imgIndex = 1 : imgTotalNo    
    imName = imageList(imgIndex).name;
    imInfo = dicominfo(imName);
    TimeInstance = imInfo.InstanceNumber;
    SXSlice(TimeInstance) = imageList(imgIndex);
end
        
cd(workingDir)