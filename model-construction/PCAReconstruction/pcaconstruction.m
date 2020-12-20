function val=pcaconstruction(resultDir)
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
cd(fileparts(which('pcaconstruction')));
load 'LV_mean.mat';
load 'Eigvecs_HVMI.mat';
cd(resultDir)
load abaqusInputData.mat;
[sendo, sepi] = extract_endo_epi_1(abaqusInputData);
LV_surface=[sendo'; sepi']';
PCA_projection=(LV_surface*eigVecs)*eigVecs';
abaqusInputData.PCAReconstructed=PCA_projection;
save abaqusInputData1 abaqusInputData;
end
