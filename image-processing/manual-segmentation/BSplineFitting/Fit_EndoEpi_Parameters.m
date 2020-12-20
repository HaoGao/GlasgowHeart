function [uknot, vknot, AIJ_Endo, AIJ_Epi] =Fit_EndoEpi_Parameters(resultDir, Endo_FitparameterFileName, Epi_FitparameterFileName, ...
                               nptsu, nptsv, kS)


workingDir = pwd();
cd(resultDir); 
fid_endo = fopen(Endo_FitparameterFileName, 'r');
fid_epi =fopen(Epi_FitparameterFileName, 'r');
cd(workingDir);


tline = fgetl(fid_endo);
tline = fgetl(fid_endo);
tline = fgetl(fid_endo);
for i = 1 : nptsu+kS
	tline = fgetl(fid_endo);
    st = sscanf(tline, '%d %f');
    uknot(i) = st(2);
end
tline = fgetl(fid_endo);
for i=1: nptsv+kS
	tline = fgetl(fid_endo);
    st = sscanf(tline, '%d %f');
    vknot(i) = st(2);
end

tline = fgetl(fid_endo);
tline = fgetl(fid_endo);
tline = fgetl(fid_endo);
tline = fgetl(fid_endo);

for I=1: nptsu
	for J=1: nptsv
        tline = fgetl(fid_endo); 
        st = sscanf(tline, '%d%d%f');
        AIJ_Endo(I,J) = st(3);
    end
end
fclose(fid_endo);

tline = fgetl(fid_epi);
tline = fgetl(fid_epi);
tline = fgetl(fid_epi);
for i = 1 : nptsu+kS
	tline = fgetl(fid_epi);
    st = sscanf(tline, '%d %f');
    uknot(i) = st(2);
end
tline = fgetl(fid_epi);
for i=1: nptsv+kS
	tline = fgetl(fid_epi);
    st = sscanf(tline, '%d %f');
    vknot(i) = st(2);
end

tline = fgetl(fid_epi);
tline = fgetl(fid_epi);
tline = fgetl(fid_epi);
tline = fgetl(fid_epi);

for I=1: nptsu
	for J=1: nptsv
        tline = fgetl(fid_epi); 
        st = sscanf(tline, '%d%d%f');
        AIJ_Epi(I,J) = st(3);
    end
end
fclose(fid_epi);

	
