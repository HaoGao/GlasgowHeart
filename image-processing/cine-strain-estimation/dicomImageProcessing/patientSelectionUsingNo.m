function [patient_config, patientNameSelected, studyNameSelected]= patientSelectionUsingNo(patientConfigs, patientID)

% patientConfigs = handles.patientConfigs;
% workingDir = pwd();
totalPatientNo = size(patientConfigs,1);
studyListIndex = 0;
patientFound = 0;

for patientIndex = 1 : totalPatientNo
    patientName = patientConfigs(patientIndex,1).name;
    totalStudyNo = size(patientConfigs(patientIndex,1).studyName,1);
        for studyIndex = 1 : totalStudyNo
            studyName = patientConfigs(patientIndex,1).studyName(studyIndex,1).studyName;

            studyListIndex = studyListIndex + 1;
            if studyListIndex == patientID   %%%find the right data
                 patient_config = patientStudyConfigExtraction(patientConfigs, patientName, studyName);
                 patientNameSelected = patientName;
                 studyNameSelected = studyName;
                 patientFound = 1;
            end

        end
end

if patientFound == 0
     errorstrT = sprintf('the required patient is not found\n');
     errordlg(errorstrT, 'File Error');
end


