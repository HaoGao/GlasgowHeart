%%%SetParameter.f
%%%dir related
% resultDir = './';
% workingDir = pwd();
% cd(resultDir);
% resultDir = pwd();
% cd(workingDir);

disp('using default setting up for b-spline fitting');

%%%filenames
outterGuidePointsFileName = 'outerGuidePoints.dat';
innerGuidePointsFileName = 'innerGuidePoints.dat';
outterGuide4FittingFileName = 'GuidePoint4Fitting_outer.dat';
innerGuide4FittingFileName = 'GuidePoint4Fitting_inner.dat';
prolateParametersFileName = 'ProlateParameters.dat';
%%%for result file
Endo_PlotFitSurfaceFileName = 'Endo_PlotFitSurface.dat';
Endo_PlotFittedEndoSurfaceFileName = 'fittedEndoSurface.dat';
Epi_PlotFitSurfaceFileName  = 'Epi_PlotFitSurface.dat';
Epi_PlotFittedEpiSurfaceFileName = 'fittedEpiSurface.dat';
Endo_FitparameterFileName = 'Endo_FitParameters.dat';
Epi_FitparameterFileName = 'Epi_FitParameters.dat';
FittedLVMeshFileName  = 'VentricleMesh.dat';
AbaLVHexMeshFileName = 'LVMeshHex_update.inp';

%%%control points and cubic spline
nptsu = 10; 
nptsv = 10;
nptsw = 6; 
kS = 4;

% c*  npts: number of verticespoints,6
% c*  kS: degree:  kS=2--->line, kS=3-->2nd order, kS=4---> cubic etc. (kS is the 'p' in my word files)
% c*  (nptsv-kS+1) is because Ks+1 points are overlapped
% c*  (nptsu-3)+1+2+3 is because of the smoothness constraint on the apex
NH = nptsu*nptsu;
Nx = (nptsv-kS + 1)*(nptsu-kS+1) + 1 + 2 + 3;

% % % these are for linear solver
LDA = Nx; 
LDFAC = Nx;
FacH = zeros([LDFAC,LDFAC]);
ResH = zeros([Nx,1]);
xguess = zeros([Nx,1]);

%%%this is for regularization
Nureg=100;
Nvreg=100;
Nwreg=11;
NReg=Nureg*Nvreg;

% !c*  These are for Standard Meshes
NuMesh=50; NvMesh=60; NwMesh=1;

% Weights for Regularization terms
wt_rr = 0.0025*0.5;  
wt_ru = 0.00075*0.5;
wt_rv = 0.00075*0.5;	
wt_ruu = 0.00025*0.5;	
wt_rvv = 0.00025*0.5;	
wt_ruv = 0.00025*0.5;

%%%some constants
ling = 0.0;
yi = 1.0;
Pi = pi;

