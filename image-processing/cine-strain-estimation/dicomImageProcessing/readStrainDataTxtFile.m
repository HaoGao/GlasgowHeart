function loadedData = readStrainDataTxtFile(resultDir, strName)

workingDir = pwd();
cd(resultDir);

fullFileName  = sprintf('%s.txt', strName);
if exist(fullFileName, 'file')
    %%%read the data
	fid  = fopen(fullFileName, 'r');
	tline = fgetl(fid); % skip the first line
	
	
	dataIndex = 0;
	while ~eof(fid)
		tline = fgetl(fid);
		if strcmp(tline(1:3), 'max')
		    %%%end of reading
			break;
		else
			strainData = sscanf('%f %f %f %f %f %f %f %f', tline);
			dataIndex = dataIndex + 1;
			Timing(dataIndex,1) = strainData(1);
			InfSept(dataIndex,1) = strainData(2);
			AntSept(dataIndex,1) = strainData(3);
			Ant(dataIndex,1) = strainData(4);	 
			AntLat(dataIndex,1) = strainData(5);	 
			InfLat(dataIndex,1) = strainData(6);	 
			inf(dataIndex,1) = strainData(7); 	 
			strainGlobal(dataIndex,1) = strainData(8);
		end	
	end
	
	loadedData.Timing = Timing;
	loadedData.InfSept = InfSept;
	loadedData.AntSept = AntSept;
	loadedData.Ant     = Ant;
	loadedData.AntLat  = AntLat;
	loadedData.InfLat  = InfLat;
	loadedData.inf     = inf;
	loadedData.strainGlobal = strainGlobal;
	
else
    errormsg = sprintf('%s is not found!', fullFileName);
    errordlg(errormsg, 'File Error');
end
cd(workingDir);