function [sendo, sepi, abaqusInputData] = load_LVGeoData(result_dir, workingDir)

cd(result_dir);
load abaqusInputData;
cd(workingDir);
[sendo, sepi] = extract_endo_epi(abaqusInputData);
cd(workingDir);
