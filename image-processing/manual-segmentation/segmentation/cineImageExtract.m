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
    %%% anolymise the data 
    if isfield(imInfo, 'PhysicianOfRecord')
        imInfo.PhysicianOfRecord = ' ';
    end
    if isfield(imInfo, 'InstitutionName')
        imInfo.InstitutionName=' ';
    end
    if isfield(imInfo, 'InstitutionAddress' )
        imInfo.InstitutionAddress = 'GlasgowHeart';
    end
    if isfield(imInfo, 'PatientName' )
        imInfo.PatientName = 'Anonymous Patient';
        imInfo.PatientID = 'Anonymous Patient ID';
        imInfo.PatientBirthData = '19000101';
        imInfo.Sex = 'O';
        imInfo.PatientAge = '120Y';
        imInfo.PatientWeight = '12.0';
        imInfo.PatientSize = '12.0';
    end
    
     
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