function strainComparison = strainComparisonAbaqusVsMRI()


% global node_ori abaqusInputData sliceRegions options;

global options;




workingDir = pwd();

FiberGenerationDir = options.FiberGenerationDir;
abaqusDir = options.abaqusDir;
%strainData = options.strainData ;
abaqus_dis_out_filename = options.abaqus_dis_out_filename ;
abaqus_input_main_filename = options.abaqus_input_main_filename ;
pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName ;
lineNoForDisName = options.lineNoForDisName ;
%LVVolume = options.LVVolume ;
% sliceRegions = options.sliceRegions;
AHALVMeshDivision = options.AHALVMeshDivision;

%%%the orginal mesh file
cd(options.abaqusDir_pca);
load(options.abaqus_input_name); 
cd(workingDir);
%%%some updates to the abaqusInputData structure
node_ori = abaqusInputPCAReconstruction.node(:,1:3);
node_ori(:,1) = node_ori(:,1)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,2) = node_ori(:,2)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,3) = node_ori(:,3)*abaqusInputPCAReconstruction.scaleTomm;

if isfield(abaqusInputPCAReconstruction, 'endoNodes')
  nodeIndex_endo = abaqusInputPCAReconstruction.endoNodes;
else
   disp('abaqusInputPCAReconstruction is not in the right format');
end



% %%%now try to extract logrithm strain from ODB file
% cd(abaqusDir);
% command=['!abaqus python abaqus_dis_up.py -odb', 'heartLVmainG3F60S45P08Run.odb'];
% eval(command);
% cd(workingDir);


DislacementExtractByPython(abaqusDir,abaqus_input_main_filename, ...
                                       pythonOriginalFilesDir, pythonfilename, ...
                                       lineNoForODBName, ...
                                       lineNoForDisName, abaqus_dis_out_filename);


%%%read in the strain 
% nodalStrainAbaqus = nodalStrainAbaqusExtraction(abaqus_strain_out_filename,abaqusDir);
% 
% 
% 
% %%%read in the fiber and sheet orientation for each node fiberDir, sheetDir
cd(FiberGenerationDir);
% load FiberDirection;
str_msg = sprintf('%s: load cir, fiber direction', FiberGenerationDir);
disp(str_msg);
cirDir = load('cirDir.txt');
radDir = load('radDir.txt');
fiberDir = load('fiberDir.txt');
sheetDir = load('sheetDir.txt');
cd(workingDir);

% 
% %%%strain rotation back to the cartisan coordinate system
% [nodalStrainAbaqusCartesian, fiberStrainTotal] = nodalStrainAbaqusTransformedToCartesian(fiberDir, sheetDir, nodalStrainAbaqus);

%%%deformation gradient calculation for each element based the nodal
%%%dispalcement
[fiberStrain_cra, dis, radialStrain_cra, longiStrain_cra, strain_tensor_cra] = ...
    strainCalculationFromNodalDisplacements_crl(abaqus_dis_out_filename,abaqusDir,node_ori,...
    abaqusInputPCAReconstruction.elem, cirDir, radDir, false);

%% strain in fsn
[fiberStrain_fsn, ~] = strainCalculationFromNodalDisplacements(abaqus_dis_out_filename,abaqusDir,node_ori,...
    abaqusInputPCAReconstruction.elem, fiberDir, sheetDir, true);


%%%now seg regions summarization
endoSummaryOnly = 1;
[strainDataAbaqusSegRegions, strainDataAbaqusOnEachSlices]= segRegionsStrainSummarization(AHALVMeshDivision, fiberStrain_cra, abaqusInputPCAReconstruction.elem,...
                                                           abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
                                                       
[strainDataAbaqusSegRegions_fsn,strainDataAbaqusOnEachSlices_fsn] = segRegionsStrainSummarization(AHALVMeshDivision, fiberStrain_fsn, abaqusInputPCAReconstruction.elem,...
                                                           abaqusInputPCAReconstruction.endoNodes,endoSummaryOnly);
                                                       
endoSummaryOnly = 1;
[strainDataAbaqusSegRegions_radial, strainDataAbaqusOnEachSlices_radial]= segRegionsStrainSummarization(AHALVMeshDivision, radialStrain_cra, abaqusInputPCAReconstruction.elem,...
                                                           abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
endoSummaryOnly = 1;                                                       
[strainDataAbaqusSegRegions_longi, strainDataAbaqusOnEachSlices_longi]= segRegionsStrainSummarization(AHALVMeshDivision, longiStrain_cra, abaqusInputPCAReconstruction.elem,...
                                                           abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
% the shear strain 
shear_c_r = strain_tensor_cra(:,4);
shear_r_l = strain_tensor_cra(:,5);
shear_c_l = strain_tensor_cra(:,6);
[strainDataAbaqusSegRegions_shear_c_r, strainDataAbaqusOnEachSlices_shear_c_r]= ...
                     segRegionsStrainSummarization(AHALVMeshDivision, shear_c_r, abaqusInputPCAReconstruction.elem,...
                     abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
[strainDataAbaqusSegRegions_shear_r_l, strainDataAbaqusOnEachSlices_shear_r_l]= ...
                     segRegionsStrainSummarization(AHALVMeshDivision, shear_r_l, abaqusInputPCAReconstruction.elem,...
                     abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
[strainDataAbaqusSegRegions_shear_c_l, strainDataAbaqusOnEachSlices_shear_c_l]= ...
                     segRegionsStrainSummarization(AHALVMeshDivision, shear_c_l, abaqusInputPCAReconstruction.elem,...
                     abaqusInputPCAReconstruction.endoNodes, endoSummaryOnly);
                                                       


strainComparison.strainAbaTotal = strainDataAbaqusSegRegions;
strainComparison.strainAbaTotal_fsn = strainDataAbaqusSegRegions_fsn;
strainComparison.strainAbaTotalOnEachSlice = strainDataAbaqusOnEachSlices;
strainComparison.strainAbaTotalOnEachSlice_fsn = strainDataAbaqusOnEachSlices_fsn;

%% added more strain
strainComparison.strainDataAbaqusSegRegions_radial = strainDataAbaqusSegRegions_radial;
strainComparison.strainDataAbaqusOnEachSlices_radial = strainDataAbaqusOnEachSlices_radial;

strainComparison.strainDataAbaqusSegRegions_longi = strainDataAbaqusSegRegions_longi;
strainComparison.strainDataAbaqusOnEachSlices_longi = strainDataAbaqusOnEachSlices_longi;

strainComparison.StrainDataAbaqusSegRegions_shear_c_r = strainDataAbaqusSegRegions_shear_c_r;
strainComparison.strainDataAbaqusOnEachSlices_shear_c_r = strainDataAbaqusOnEachSlices_shear_c_r;

strainComparison.StrainDataAbaqusSegRegions_shear_c_l = strainDataAbaqusSegRegions_shear_c_l;
strainComparison.strainDataAbaqusOnEachSlices_shear_c_l = strainDataAbaqusOnEachSlices_shear_c_l;

strainComparison.StrainDataAbaqusSegRegions_shear_r_l = strainDataAbaqusSegRegions_shear_r_l;
strainComparison.strainDataAbaqusOnEachSlices_shear_r_l = strainDataAbaqusOnEachSlices_shear_r_l;


%% we do not make comparison now
%% strainComparison = strainCompasrisonBasedOnSegs(strainData,strainDataAbaqusSegRegions);

nodeIndex_endo = abaqusInputPCAReconstruction.endoNodes;
[vol_ori,vol_update] = LVCavityVolumeCalculation(node_ori, nodeIndex_endo, abaqus_dis_out_filename, abaqusDir);
% vol_changes = [vol_ori/1.0e3 vol_update/1.0e3]; %%this is for command window output


strainComparison.LVVolumeAba = vol_update/1.0e3;
strainComparison.LVVolumeOri = vol_ori/1.0e3;
% strainComparison.LVVolumeMRI = LVVolume.endDiastole; 
strainComparison.dis = dis; %%%the full displacement fileds are output now
strainComparison.fiberStrain_cra = fiberStrain_cra;
strainComparison.fiberStrain_fsn = fiberStrain_fsn;
strainComparison.node_ori = node_ori;
strainComparison.elem =  abaqusInputPCAReconstruction.elem;
strainComparison.nodeIndex_endo = nodeIndex_endo;
strainComparison.strain_tensor_cra = strain_tensor_cra;
strainComparison.radialStrain_cra = radialStrain_cra;
strainComparison.longiStrain_cra   = longiStrain_cra;


