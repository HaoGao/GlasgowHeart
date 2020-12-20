function loadedData = loadMatFiles(resultDir, strName)

workingDir = pwd();
cd(resultDir);

fullFileName  = sprintf('%s.mat', strName);
if exist(fullFileName, 'file')
    loadedData = load(fullFileName);
else
    errormsg = sprintf('%s is not found!', fullFileName);
    errordlg(errormsg, 'File Error');
end
cd(workingDir);