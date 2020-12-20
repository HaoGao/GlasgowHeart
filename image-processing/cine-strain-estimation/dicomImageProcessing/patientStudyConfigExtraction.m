function patient_config = patientStudyConfigExtraction(patientConfigs, patientName, studyName)

%%%extract one study from the saved project configure file
% patientName = 'HV12';
% studyName = 'GJH1.5T';


totalPatientNo = size(patientConfigs,1);

for patientIndex = 1 : totalPatientNo
    
    
    %%%find out the right patient 
    if strcmp(patientConfigs(patientIndex,1).name, patientName)
            patientTemp =  patientConfigs(patientIndex,1);
            patient_config.patientName = patientTemp.name;
            
            totalStudyNo = size(patientTemp.studyName,1);
            for studyIndex = 1 : totalStudyNo
                if strcmp ( patientTemp.studyName(studyIndex,1).studyName, studyName)
                    patient_config.dir = patientTemp.dir(studyIndex,1).studyDir;
                    patient_config.SAMidImgDir = patientTemp.dirMidSA(studyIndex,1).ImgDir;
                    patient_config.studyName = studyName;
                    if isfield(patientTemp,'slicePosition')
                        patient_config.slicePosition = patientTemp.slicePosition(studyIndex,1).position;
                    else
                        patient_config.slicePosition = 'SA_Mid'; %%the default value 
                    end
                end
            end   
    end
    
    
end




