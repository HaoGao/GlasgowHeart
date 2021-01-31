function LV_WholeMesh_FibreGeneration(a_fibre_endo, a_fibre_epi, a_sheet, ...
                                    wall_thickness_calculated, ...
                                    abaqusInputDir,abaqusFibreDir,abaqusDir)
workingDir = pwd();

str_msg = sprintf('generating fiber in directory: %s from the directory: %s', ...
                    abaqusFibreDir, abaqusInputDir);
disp(str_msg);

AbaqusInputToTetGen_HexMesh(abaqusInputDir,workingDir);

DisanceMain_HexMesh(a_fibre_endo, a_fibre_epi, a_sheet, ...
                    wall_thickness_calculated, ...
                    abaqusInputDir, workingDir, abaqusFibreDir);

CurvatureCalculation_HexMesh(abaqusInputDir, workingDir, abaqusFibreDir);

NormalDirectionEndoSurf_HexMesh(abaqusInputDir, workingDir, abaqusFibreDir);

LocalCoordinateDirection_HexMesh(abaqusInputDir, workingDir, abaqusFibreDir);

FibreConstructionEndo_HexMesh(abaqusInputDir, workingDir, abaqusFibreDir);

AbaqusCodeGenerationForOrientationAndSection_HexMesh(abaqusInputDir, ...
                                              workingDir, abaqusFibreDir, ...
                                              abaqusDir);
