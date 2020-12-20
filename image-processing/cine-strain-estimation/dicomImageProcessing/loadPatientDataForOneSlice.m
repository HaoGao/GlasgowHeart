function   patient_slice_data = loadPatientDataForOneSlice(patient_config)

%%first save patient_config 
patient_slice_data.patientConfig = patient_config;

workingDir = pwd();
dicomDir = sprintf('%s//%s', patient_config.dir, patient_config.SAMidImgDir);

fileList = scanFilesInDir(dicomDir);
BloadImageData = 1;
SXSlice = cineImageExtract(fileList, dicomDir, BloadImageData); 

patient_slice_data.SXSlice = SXSlice;

