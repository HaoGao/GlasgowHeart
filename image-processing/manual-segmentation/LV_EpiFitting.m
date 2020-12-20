function LV_EpiFitting(projectConfig_dir,projectConfig_name)
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

%%%only for cubic spline
if(kS ~=4)
    disp('The program is ONLY for Cubic B-Spline with kS=4');
    disp('Please change kS in setparameters back to kS=4');
    stop;
end

%%%this does not need to do due to the endo fitting has done
% %%%pre_processing, from segmentated boundary data
% readGuidePoints_preProcessing(outterGuidePointsFileName, innerGuidePointsFileName,...
%                 outterGuide4FittingFileName,innerGuide4FittingFileName, ...
%                 prolateParametersFileName, resultDir);

 % c=======read geometry of the reference prolate spheriodal surface
disp('read geometry of the reference prolate spheriod');
[alpha0, w0, umax] = readGeometry_Epi(resultDir, prolateParametersFileName);


%%%make standard mesh
disp('Make standard mesh of the fitting surface');
[uvnode, NNode,Nelement,ElementNode,neReg, nnReg, naReg] = PartitionUV(umax, w0, alpha0, NuMesh, NvMesh);

PlotInitialSurfaceMesh(NuMesh, NvMesh, uvnode, ElementNode, NNode,Nelement, w0, alpha0, resultDir, Epi_PlotFitSurfaceFileName);

% c========= read guide points of the ventricular surface==========
disp('read guide points of the ventricular surface');
[xyzGuide, uGuide, vGuide, pGuide, weightGP, NPoints] = readGuidePoints_uvw(resultDir, outterGuide4FittingFileName);

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
                                      resultDir, Epi_FitparameterFileName);
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
                                 resultDir, xyzGuide, Epi_PlotFittedEpiSurfaceFileName, 0);

try                              
PlotFittingSurfaceMeshInMRICoor(uvnode, NNode, Nelement, ElementNode ,...
                                 nptsu, nptsv, uknot, vknot, kS, alpha0, AH,...
                                 resultDir, xyzGuide, Epi_PlotFittedEpiSurfaceFileName, 0);
catch 
    disp('MRI coor is not provided');
end

%%%here is for output for solidwork reconstruction                              
[XYZEpi,  XYZEpiApex]   = readGuidPointsInSlices(resultDir, outterGuidePointsFileName);
[XYZEpiFitted, XYZEpiApexFitted, XYZEpiApex] = GuidePointsFitted(XYZEpi, XYZEpiApex,nptsu, nptsv, uknot, vknot, kS,alpha0, AH, resultDir);  

cd(resultDir);
save XYZEpiFitted XYZEpiFitted XYZEpiApexFitted XYZEpiApex neReg nnReg naReg;
cd(workingDir);


                             
                             
                             