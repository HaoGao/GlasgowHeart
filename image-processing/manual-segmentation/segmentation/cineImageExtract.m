%%%short cine images store according to the instance time 

function SXSlice = cineImageExtract(imageList,dicomDir, BoolImData)

workingDir = pwd();
cd(dicomDir);

% SXSlice = struct([]);

imgTotalNo = size(imageList,2);

dicomImageIndex = 0;

for imgIndex = 1 : imgTotalNo    
    imName = imageList(imgIndex).name;
    imInfo = dicominfo(imName);
     
    %%%decide whether this image is a dicom or not
    if strcmp (imInfo.Format,'DICOM')
       TimeInstance = imInfo.InstanceNumber;
        if BoolImData
            imData = dicomread(imName);
            imageList(imgIndex).imData = imData;
            imageList(imgIndex).imInfo = imInfo;
            imageList(imgIndex).name = imName;
            SXSlice(TimeInstance,1) = imageList(imgIndex);
            dicomImageIndex = dicomImageIndex + 1;
        else
           % SXSlice(TimeInstance,1).imData = [];
           % SXSlice(TimeInstance,1).imInfo = [];
        end

    end
   
end

if dicomImageIndex > 0
    msgstr = sprintf('%d dicom images are loaded from %s', dicomImageIndex, dicomDir);
    disp(msgstr);
end

if ~exist('SXSlice', 'var')
    errstr = sprintf('no dicom image found in %s, please specify the right folder', dicomDir);
    SXSlice = struct([]);
    errordlg(errstr);
end
        
cd(workingDir)