%%%tracking the boundaries for deformed mesh
function [LVStrainTotal, LVPointsTotalPhases] = LVMeshDeformed(patient_slice_data, imgDeformed, EndoEpiBc, LVPointsTotalPhases)
    
%imNo = 1;
%hmesh = figure; hold on;
%imshow(imcrop(patient_slice_data.SXSlice(imNo,1).imData,imgDeformed(imNo,1).rect),[]);hold on;
% plot(EndoEpiBc.endo(:,1),EndoEpiBc.endo(:,2),'-');
% plot(EndoEpiBc.epi(:,1),EndoEpiBc.epi(:,2),'-');
% F(imNo) = getframe;
 
%  %%%mesh generation
% [LVMesh LVPoints] = EndoEpiMeshGeneration(endoT,epiT,sampleN);
% LVMeshShow(LVPoints,LVMesh,h1);
% LVPointsTotalPhases(1).LVPoints = LVPoints;
LVPoints = LVPointsTotalPhases(1).LVPoints ;
shapex = LVPointsTotalPhases(1).shapex;
shapey = LVPointsTotalPhases(1).shapey;
LVMesh = LVPointsTotalPhases(1).LVMesh ;

endoT = EndoEpiBc.endo;
epiT = EndoEpiBc.epi;
sampleN = size(endoT,1);

imgTotalNo = size(patient_slice_data.SXSlice,1);
 for imNo = 1 : imgTotalNo-1
    Tx = imgDeformed(imNo,1).Tx;
    Ty = imgDeformed(imNo,1).Ty;
    
    %endoTN = boundaryTrackingWithoutCutoff(endoT, Tx, Ty);
    %epiTN =  boundaryTrackingWithoutCutoff(epiT, Tx, Ty);
    endoTN = boundaryTracking_floatingPoint(endoT, Tx, Ty);
    epiTN =  boundaryTracking_floatingPoint(epiT, Tx, Ty);
    endoT = endoTN;
    epiT = epiTN;
    
    %%LVpoints update
    LVPointsUpdate = [endoT; epiT];
    LVPointsTotalPhases(imNo+1).LVPoints = LVPointsUpdate;
    
  %  pause(0.1);

    %     pause;
    %imshow(imcrop(patient_slice_data.SXSlice(imNo+1,1).imData,imgDeformed(imNo,1).rect),[]);
    %plot(endoT(:,1),endoT(:,2),'-');
    %plot(epiT(:,1),epiT(:,2),'r-');
    %LVMeshShow(LVPointsUpdate,LVMesh,hmesh);
    %F(imNo+1) = getframe; 
    %titleStr = sprintf('image %d (%d)', imNo+1,imgTotalNo );
    %title(titleStr);
    
    %%%strain calculation
    LVStrain = FiniteStrainForRect(LVMesh,LVPointsUpdate,LVPointsTotalPhases(1).LVPoints,shapex,shapey);
    
    for pindex = 1 : sampleN
        E11(pindex) = LVStrain(1,pindex).strain(1,1);
        E22(pindex) = LVStrain(1,pindex).strain(2,2);
        rad(pindex) = LVStrain(1,pindex).crstrain(1,1);
        cir(pindex) = LVStrain(1,pindex).crstrain(2,2);
    end
    
    LVStrainTotal(imNo+1).E11 = E11;
    LVStrainTotal(imNo+1).E22 = E22;
    LVStrainTotal(imNo+1).rad = rad;
    LVStrainTotal(imNo+1).cir = cir;
 end
 
 %if exist('hmesh', 'var')
 %    close(hmesh);
 %end