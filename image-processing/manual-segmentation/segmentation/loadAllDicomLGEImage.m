function LGESASlice = loadAllDicomLGEImage(dicomDir)


workingDir = pwd();
imageList = scanFilesInDir(dicomDir);

imgTotalNo = size(imageList,2);
dicomImageIndex = 0;

cd(dicomDir);
for imgIndex = 1 : imgTotalNo    
    imName = imageList(imgIndex).name;
    imInfo = dicominfo(imName);
     
    %%%decide whether this image is a dicom or not
    if strcmp (imInfo.Format,'DICOM')
        dicomImageIndex = dicomImageIndex + 1;
        LGESASlice(dicomImageIndex,1).imData = dicomread(imName);
        LGESASlice(dicomImageIndex,1).imInfo = imInfo;
        LGESASlice(dicomImageIndex,1).name = imName;
    end
   
end
cd(workingDir);

if dicomImageIndex > 0
    msgstr = sprintf('%d LGE images are loaded from %s', dicomImageIndex, dicomDir);
    disp(msgstr);
end