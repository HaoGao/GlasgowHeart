%%%now need to post processing the strain results with each study
%%%output as a excel file for further postprocessing
%%%including the regional maximum value and global maximum value
function RegionaGloballMaxiumStrainValueOutput(handles)

	patientConfigs = handles.patientConfigs;
	projectResultDir = handles.projectResultDir;
	workingDir = handles.workingDir;
	MiddleSliceB = handles.MiddleSliceB;
	
	totalPatientNo = size(patientConfigs,1);
	for patientIndex = 1 : totalPatientNo
		patientT = patientConfigs(patientIndex,1);
		patientName = patientT.name;
		
		totalStudyNo = size(patientT.studyName,1);
		for studyIndex = 1 : totalStudyNo
			studyName = patientT.studyName(studyIndex,1).studyName;
			
			%%%now figure out what is the result dir
			resultDir = sprintf('%s\\%s\\%s', handles.projectResultDir, patientName, studyName);
            cirRegionalStrain = readStrainDataTxtFile(resultDir, 'cirStrainSlice');
			radRegionalStrain = readStrainDataTxtFile(resultDir, 'radStrainSlice');

			
			
			
		end     
	end