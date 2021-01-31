%%%parameters for optimization 
abaqus_input_main_original_filename = 'heartLVmainG3F60S45P08';
abaqus_input_main_filename = 'heartLVmainG3F60S45P08Run';
abaqus_input_mesh_filename = 'hexheartLVmeshF60S45';
abaqus_input_fiber_filename= 'fibTotal';
abaqus_input_user_subroutine = 'myuanisohyper_inv.for';

abaqus_dis_out_filename = 'abaqus_displacement.rpt';

opt_log_filename = 'optca_cb_sweeping.log';

%%%this file needs to be prepared within image processing
%part after b-spline strain recovery for each short-axis slice
%current verion only include circumferential strain

straininvivoMRI_filename = 'deformResAllSlices.dat';
fiberDir_filename = 'fiberDir.txt';
sheetDir_filename = 'sheetDir.txt';




%%%parameters, this is from Wang's paper
mpara.A = 0.23619;
mpara.B = 10.810;
mpara.Af = 20.037;
mpara.Bf = 14.154;
mpara.As = 3.7245;
mpara.Bs = 5.1645;
mpara.Afs = 0.41088;
mpara.Bfs = 11.300;

%% from 2017 Gao's paper
%mpara.A = 0.18;
%mpara.B = 2.6;
%mpara.Af = 3.34;
%mpara.Bf = 2.73;
%mpara.As = 0.69;
%mpara.Bs = 1.11;
%mpara.Afs = 0.31;
%mpara.Bfs = 2.58;

materialParam_startLine = 19;
pressure_loadingLine = 14;

eplsion = 0.01;




