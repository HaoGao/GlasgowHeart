function BExisted = IsPatientAlreadyExisted(fid_readOnly, patientName, studyName)

BExisted = 0;
patientIndex = 1;
while ~feof(fid_readOnly)
     tline = fgetl(fid_readOnly);
     patientNameList(patientIndex,1).name = tline;
     tline = fgetl(fid_readOnly);
     studyNameList(patientIndex,1).name = tline;
     patientIndex = patientIndex + 1;
end

totalPatientIndex = size(patientNameList,1);

for patientIndex = 1 : totalPatientIndex
    if strcmp(patientNameList(patientIndex,1).name, patientName) && ...
            strcmp(studyNameList(patientIndex,1).name, studyName);
        BExisted = 1;
    end
end
