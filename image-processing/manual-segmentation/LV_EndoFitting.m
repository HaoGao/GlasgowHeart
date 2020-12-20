function LV_EndoFitting(projectConfig_dir,projectConfig_name)

close all; clc;

workingDir = pwd();

% LVWM_config;
if ~exist('projectConfig_name', 'var')
    LVWM_config; %% that is for standalone run
else
    cd(projectConfig_dir);
    run(projectConfig_name);
    cd(workingDir);
end

%%%% load parameter for one study
cd(resultDir);
if exist('SetParameters.m', 'file')
    SetParameters;
    cd(workingDir);
else
    cd(workingDir);
    SetParametersDefault;
end

cd(resultDirRoot);
if exist('alpha0_global.mat', 'file')
    load alpha0_global;
    disp('load gobal alpha0_global');
else
    disp('global alpha0 is not defined yet');
    %stop;
end
cd(workingDir);

%%%only for cubic spline
if(kS ~=4)
    disp('The program is ONLY for Cubic B-Spline with kS=4');
    disp('Please change kS in setparameters back to kS=4');
    stop;
end

if exist('using_own_alpha0', 'var') 
    if using_own_alpha0 == 1
        using_global_alpha0 = 0;
    end
else
    using_global_alpha0 = 1;
end


%%%pre_processing, from segmentated boundary data
%%%an average alpha0 is used
if exist('alpha0_global', 'var') && using_global_alpha0 == 1
   readGuidePoints_preProcessingUsingGlobalAlpha0(outterGuidePointsFileName, ...
                innerGuidePointsFileName,...
                outterGuide4FittingFileName,innerGuide4FittingFileName, ...
                prolateParametersFileName, alpha0_global, resultDir);
else
    disp('alpha_0 is adjusted to the subject');
    readGuidePoints_preProcessing(outterGuidePointsFileName, ...
                innerGuidePointsFileName,...
                outterGuide4FittingFileName,innerGuide4FittingFileName, ...
                prolateParametersFileName, resultDir);
end

            
 % c=======read geometry of the reference prolate spheriodal surface
disp('read geometry of the reference prolate spheriod');
[alpha0, w0, umax] = readGeometry(resultDir, prolateParametersFileName);

%%%make standard mesh
disp('Make standard mesh of the fitting surface');
[uvnode, NNode,Nelement,ElementNode, neReg, nnReg, naReg] = PartitionUV(umax, w0, alpha0, NuMesh, NvMesh);

PlotInitialSurfaceMesh(NuMesh, NvMesh, uvnode, ElementNode, NNode,Nelement, w0, alpha0, resultDir, Endo_PlotFitSurfaceFileName);
 
% c========= read guide points of the ventricular surface==========
disp('read guide points of the ventricular surface');
[xyzGuide, uGuide, vGuide, pGuide, weightGP, NPoints] = readGuidePoints_uvw(resultDir, innerGuide4FittingFileName);

% c========= get knots for the BSplines============================
disp('get knots for the BSplines');
disp('    u knots----clamped on both ends');
uknot = knot_Clamped(nptsu,kS,-Pi/2, umax);
disp('    v knots---closed');
vknot = knot_Closed(nptsv,kS,0.0,2*Pi);

% c========= The constraint matrix
disp('Construct the constraint matrix');
QCon = ConstraintMatrix(nptsu, nptsv, kS);

% c========= Calculate the basic at guide points
disp('Calculate the basic at guide points');
% FittingErrParameters
[Herr, bN]=FittingErrParameters(nptsu, nptsv, kS, NH, uGuide, vGuide, weightGP, NPoints, uknot, vknot);
[berr, S0]= Fitting_brr_N_S0(weightGP, pGuide, NPoints, NH, bN);

% c========= Calculate the regularization terms
 disp('Calculate the regularization terms');
 disp('Waite, don"t move......');
 [uRegul, vRegul] = RegularizationPoints(umax, Nureg, Nvreg);
[Hreg, breg, H0] = RegularizationMatrices(w0, uRegul, vRegul, NReg, uknot, vknot, nptsu, nptsv,kS, ...
                               NH, wt_rr, wt_ru, wt_rv, wt_ruu, wt_rvv, wt_ruv);
                           
[Hessian, bterm] = OverallMatrices(NH, Nx, Hreg, Herr, berr, breg, QCon);

%%%find the solution of xguess
xguess = (Hessian)\(bterm');
xguess = xguess';
% xguess = load('xguess.dat');
% xguess = xguess';

AH = outputKnotsNGuidePoints(NH, Nx, QCon, xguess, ...
                                      uknot, vknot, nptsu, nptsv, kS, ...
                                      resultDir, Endo_FitparameterFileName);
% AH = load('AH.dat');
% AH = AH(:,3);
% AH = AH';
% QCon = load('QCon.dat');
% breg = load('breg.dat'); breg = breg';
% Hreg = load('Hreg.dat'); 
% berr = load('berr.dat'); berr = berr';
% Herr = load('Herr.dat');
% uvnode = load('uvnode.dat');

xguessIni = zeros(size(xguess));
ErrsTemp(xguessIni, NH, Nx, QCon, Herr, berr, Hreg, breg, S0, H0);
% AH1 = outputKnotsNGuidePoints(NH, Nx, QCon, xguess);
ErrsTemp(xguess, NH, Nx, QCon, Herr, berr, Hreg, breg, S0, H0);

PlotFittingSurfaceMesh(uvnode, NNode, Nelement, ElementNode ,...
                                 nptsu, nptsv, uknot, vknot, kS, alpha0, AH,...
                                 resultDir, xyzGuide, Endo_PlotFittedEndoSurfaceFileName, 1);
try                             
    PlotFittingSurfaceMeshInMRICoor(uvnode, NNode, Nelement, ElementNode ,...
                                 nptsu, nptsv, uknot, vknot, kS, alpha0, AH,...
                                 resultDir, xyzGuide, Endo_PlotFittedEndoSurfaceFileName, 1);
catch 
    disp('not MRI coor provided');
end
                             
%%%here is for output for solidwork reconstruction 
disp('output fitted boundary points for solidworks reconstruction');
[XYZEndo,  XYZEndoApex] = readGuidPointsInSlices(resultDir, innerGuidePointsFileName);
[XYZEndoFitted, XYZEndoApexFitted, XYZEndoApex] = GuidePointsFitted(XYZEndo, XYZEndoApex,nptsu, nptsv, uknot, vknot, kS,alpha0, AH, resultDir);
%%%do not use XYZEndoApexFitted, seems not good enough

save XYZEndo XYZEndo XYZEndoApex;

cd(resultDir);
save XYZEndoFitted XYZEndoFitted XYZEndoApexFitted XYZEndoApex neReg nnReg NNode Nelement NwMesh naReg;
cd(workingDir);


%%creat the z axis
hold on; line([0 0], [0 0], [0 -7], 'LineWidth', 2, 'color', 'k')

%%can we plot all the 3D curves with MRI images, say plot SA 2 with all
%%fitted endo boundaries;






