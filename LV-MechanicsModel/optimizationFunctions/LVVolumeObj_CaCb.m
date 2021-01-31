function ResRecord_iter = LVVolumeObj_CaCb(C_a, C_b, options)

%%%this function will calculate volume by using C_a, C_b coefficient
% workingDir = pwd();

abaqusDir = options.abaqusDir;
abaqus_input_main_filename = options.abaqus_input_main_filename;
abaqus_input_main_original_filename = options.abaqus_input_main_original_filename;
materialParam_startLine = options.materialParam_startLine;
mpara = options.mpara;
pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName;
lineNoForDisName = options.lineNoForDisName;
abaqus_dis_out_filename = options.abaqus_dis_out_filename;
node_ori = options.node_ori;
nodeIndex_endo = options.nodeIndex_endo;

abaqusInputFileUpdate_CaCbModel(abaqusDir,abaqus_input_main_filename, abaqus_input_main_original_filename, ...
                                            materialParam_startLine, mpara, C_a, C_b);
%%%call abaqus to run the simulation 
[status,result] = RunAbaqusJobFromMatlab(abaqusDir,abaqus_input_main_filename);

%%check whether the running is finished or not
SuccessB = AbaqusRunningSuccessOrNot(abaqusDir, abaqus_input_main_filename);
            %%%extract the displacement fileds for all nodes
DislacementExtractByPython(abaqusDir,abaqus_input_main_filename, ...
                                       pythonOriginalFilesDir, pythonfilename, ...
                                       lineNoForODBName, ...
                                       lineNoForDisName, abaqus_dis_out_filename);

        %     clc; %%LV cavity volume calculation
[vol_ori,vol_update] = LVCavityVolumeCalculation(node_ori, nodeIndex_endo, abaqus_dis_out_filename, abaqusDir);
vol_changes = [vol_ori/1.0e3 vol_update/1.0e3]; %%this is for command window output

ResRecord_iter.C_a = C_a;
ResRecord_iter.C_b = C_b;
ResRecord_iter.vol = vol_changes;
ResRecord_iter.SuccessB = SuccessB;
ResRecord_iter.status = status;
ResRecord_iter.result = result;

