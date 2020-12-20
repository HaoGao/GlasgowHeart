function DisanceMain_HexMesh(a_fibre_endo, a_fibre_epi, a_sheet, ...
                            wall_thickness_calculated, ...
                            abaqusInputDir, workingDir, dataResult)
%%%before processing, the datafile *.face and *.node need to be deleted in
%%% for the first line
%% -2: epi surface; 1: base; 2: endo surface; 0 inside
cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_Node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);

epiB = -2; endoB = 2;innerB = 0;
[heart_node, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_Node, epiB, endoB);

TecplotMeshGenWithFileName_HexMesh(heart_node, heart_ele,heart_node(:,5), heart_node(:,5), dataResult,'NodeClassification');


%%%%plot the surface for better 
%%%just for checking
% SurfacePlot(heart_node,endoSurf,epiSurf);

%%% calculate the degree according to 
%%% a comparison of monodomian and bidomain reaction-diffusion models for
%%% action potential propagation in the human heart. IEEE transactions on
%%% biomedical engineering, 53(12), 2006 by Mark Potse
%%% equation 1 and 2
if ~wall_thickness_calculated
    disp('calculating the wall thickness....');
    nodeDistance = ShortestDistanceByGreedySearch_HexMesh(heart_node,endoSurf,epiSurf, epiB, endoB, innerB);
    disp('calculating the wall thickness done!')
else
    disp('load the wall thickness result');
    cd(dataResult);
    load nodeDistance nodeDistance;
    cd(workingDir);
end
% R = 80*pi/180;


% helixAngle = -R.*(1-2.*nodeDistance(:,1)).^1;
%%% for linear changes 
% Rendo = 60*pi/180; Repi = 60*pi/180;
% for i = 1 : size(nodeDistance,1)
%     if nodeDistance(i,1)<=0.5
%         helixAngle(i,1)=-Rendo*(1-2*nodeDistance(i,1)).^1;
%     else
%         helixAngle(i,1)=-Repi*(1-2*nodeDistance(i,1)).^1;
%     end
% end


%% redefine the angle using 
% Rendo = -60*pi/180;  %% negative in the endocardial surface
% Repi = 60*pi/180;    %% opositive in the epicardial surface
% Rsheet = pi/4;

Rendo = a_fibre_endo;  %% negative in the endocardial surface
Repi = a_fibre_epi;    %% opositive in the epicardial surface
Rsheet = a_sheet;

for i = 1 : size(nodeDistance, 1)
    helixAngle(i,1) = Rendo*(1-nodeDistance(i,1))+Repi*nodeDistance(i,1);
end



sheetAngle = Rsheet.*(1-2.*nodeDistance(:,1)).^1;



cd(dataResult);
save helixAngle helixAngle sheetAngle;
if ~wall_thickness_calculated
    save nodeDistance nodeDistance;
end
cd(workingDir);
% %%%normal calculation
% NormalP=CurvatureCalculationNorVer2(heart_node,endoSurf, epiSurf,endoB)



%%%output the datafie for tecplot
TecplotMeshGen_HexMesh(heart_node, heart_ele,nodeDistance, helixAngle', dataResult);
TecplotMeshGenWithFileName_HexMesh(heart_node, heart_ele,nodeDistance, sheetAngle', dataResult,'SheetAngle');
%%%%output normal 
% TecplotMeshGenVec(heart_node, heart_ele,NormalP);
 
 
 
 