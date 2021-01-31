function strainData = readStrainAfterBsplineRecovery(fid)
%%%the file has been well organized each for lines for one short-axis

tline = fgetl(fid);
sliceIndex = 1;
while ~feof(fid)
    tline_data = sscanf(tline,'%d,%f,%f,%f,%f,%f,%f');
    tline = fgetl(fid);
    tline_dataB = sscanf(tline, '%d,%f,%f,%f,%f,%f,%f');
    strainDataT.sliceNo = tline_data(1);
    strainDataT.segStrain = tline_data(2:end);
    strainDataT.segStrainB= tline_dataB(2:end);
    tline = fgetl(fid); %%one blank line
    tline = fgetl(fid); %%one blank line
    strainData(sliceIndex) = strainDataT;
    sliceIndex = sliceIndex + 1;
    
    tline = fgetl(fid);
end

    