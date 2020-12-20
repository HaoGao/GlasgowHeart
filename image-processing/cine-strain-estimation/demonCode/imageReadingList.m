%%%imageLoading list
function imgList = imageReadingList(imgDir, resultDir, workingDir)

cd(imgDir);
imgListT = dir(imgDir);
imgListT = imgListT(3:end,:);

imTotalNo = size(imgListT,1);

for imNo = 1 : imTotalNo
    imName = imgListT(imNo,1).name;
    imInfo = dicominfo(imName);
    imData = dicomread(imName);
    
    %%%now sortout the imgList according to the InstanceNumber
    imInstance = imInfo.InstanceNumber;
    imgList(imInstance,1).imName = imName;
    imgList(imInstance,1).imData = imData;
    imgList(imInstance,1).imInfo = imInfo;
end
cd(workingDir);

cd(resultDir); 
save imgList imgList;
cd(workingDir);


