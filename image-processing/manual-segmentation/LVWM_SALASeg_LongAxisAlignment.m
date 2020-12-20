function LVWM_SALASeg_LongAxisAlignment(projectConfig_dir,projectConfig_name)
close all;clc;
workingDir = pwd();

%%%this code will generate input file for LV prolate fitting, need to
%%rotate the coordinate system from ij to be xy, x is in j direction, y is
%%in -i direction, and z is pointing from apex to base

workingDir = pwd();
% LVWM_config;
if ~exist('projectConfig_name', 'var')
    LVWM_config; %% that is for standalone run
else
    cd(projectConfig_dir);
    run(projectConfig_name);
    cd(workingDir);
end


cd(resultDir);
load imDesired;
cd(workingDir); 


% % usuableSXSlice = usuableSXSlice - length(sliceToBeSkipped);
% reversedSequence = 1; %%%if the first slice is in apex, then need to reverse

scaleCM = 0.1;
Brotation = 1; %%whether rotate, it should be 1 always

cd(resultDir);
load imDesired;
load DataSegSA;
load DataSegLA;
cd(workingDir); 




%%add the long axial image data as a short axis image data
usuableSXSlice = size(DataSegSA,2);
usuableLXSlice = size(DataSegLA,2);


%%need to adjust the basal moving
%%still in the original MRI scanner 3D system
% if  BasalMovingB == 1  && abs(basalMovingDistance)>1.0e-6
%     disp('basal will be moved down towards apex');
%     
%     basalMovingDistance = abs(basalMovingDistance);
%     sliceDistanceTemp = (DataSegSA(1,1).endo_cReal(3,1) - DataSegSA(1,2).endo_cReal(3,1))^2 + ...
%                         (DataSegSA(1,1).endo_cReal(2,1) - DataSegSA(1,2).endo_cReal(2,1))^2 + ...
%                         (DataSegSA(1,1).endo_cReal(1,1) - DataSegSA(1,2).endo_cReal(1,1))^2;
%     sliceDistanceTemp = sliceDistanceTemp^0.5;                
%     ratio = basalMovingDistance/sliceDistanceTemp;
%     
%     DataSegSA(1,1).endo_cReal(1,:) = DataSegSA(1,1).endo_cReal(1,:)*(1-ratio) + DataSegSA(1,2).endo_cReal(1,:)*ratio;
%     DataSegSA(1,1).endo_cReal(2,:) = DataSegSA(1,1).endo_cReal(2,:)*(1-ratio) + DataSegSA(1,2).endo_cReal(2,:)*ratio;
%     DataSegSA(1,1).endo_cReal(3,:) = DataSegSA(1,1).endo_cReal(3,:)*(1-ratio) + DataSegSA(1,2).endo_cReal(3,:)*ratio;
%     
%     DataSegSA(1,1).epi_cReal(1,:) = DataSegSA(1,1).epi_cReal(1,:)*(1-ratio) + DataSegSA(1,2).epi_cReal(1,:)*ratio;
%     DataSegSA(1,1).epi_cReal(2,:) = DataSegSA(1,1).epi_cReal(2,:)*(1-ratio) + DataSegSA(1,2).epi_cReal(2,:)*ratio;
%     DataSegSA(1,1).epi_cReal(3,:) = DataSegSA(1,1).epi_cReal(3,:)*(1-ratio) + DataSegSA(1,2).epi_cReal(3,:)*ratio;
% else
%     disp('there is no need to move the basal plane.');
%     
% end



DataSegSA_AlignWithLongAxis = DataSegSA;

%%updates in 2016, the LVUpperCenter is still the same, but the
%%%normal z axis will be defined only through the basal plane, so this will
%%%be consistent with MRI scan protocol
%%%this is the first rotation to find out the apex and center of the basal
%%%plane
if Brotation
    %%%rotation porcedure;
    LVUpperCenter = [mean(DataSegSA(1,1).endo_cReal(1,:)) mean(DataSegSA(1,1).endo_cReal(2,:)) mean(DataSegSA(1,1).endo_cReal(3,:))];
    
    LVApexCenter = [mean(DataSegSA(1,usuableSXSlice).endo_cReal(1,:)) mean(DataSegSA(1,usuableSXSlice).endo_cReal(2,:)) mean(DataSegSA(1,usuableSXSlice).endo_cReal(3,:))];
    LAVec = NormalizationVec(LVUpperCenter - LVApexCenter);
    %%this LAVec is only used for reference, but not for the whole LV
    %%geometry
    
    SAXVec = NormalizationVec(DataSegSA(1,1).endo_cReal(:,1)'-LVUpperCenter);
    SAXVec_t = NormalizationVec(DataSegSA(1,1).endo_cReal(:,10)'-LVUpperCenter);
    LAVec_t = NormalizationVec(cross(SAXVec,SAXVec_t));
    
    %%assign the normal direction from the basal plane to the whole LV
    %%geometry
    if dot(LAVec,LAVec_t) <0
        LAVec = - LAVec_t;
    else
        LAVec = LAVec_t;
    end
    
    %%ensure the system is orthogonal 
    SAYVec = NormalizationVec( cross(LAVec, SAXVec) ); %%point to the j direction in the image coordinate
    SAXVec = NormalizationVec( cross(SAYVec, LAVec) ); %%point to the -i direction in the image coordinate
    
    

    leftM = [SAXVec(1) SAYVec(1) LAVec(1);
             SAXVec(2) SAYVec(2) LAVec(2);
             SAXVec(3) SAYVec(3) LAVec(3)];
    rightM = [1 0 0;
              0 1 0;
              0 0 1];
    RotationMatrix = rightM/leftM;
    
    if abs(det(RotationMatrix)-1)>0.01
       disp('determination of RotationMatrix is not 1');
       stop;
    end
% 	cd(resultDir);
% 	save rotationConfig LVUpperCenter LVApexCenter RotationMatrix;
% 	cd(workingDir);
end

h = figure; hold on;

for imIndex = 1 : usuableSXSlice
    if isempty(find(sliceToBeSkipped==imIndex, 1))    
        endo_c = DataSegSA(imIndex).endo_cReal;
        epi_c = DataSegSA(imIndex).epi_cReal;

        %%%translation and rotation for endocardial boundary
        endo_cT(1,:) = endo_c(1,:)-LVUpperCenter(1);
        endo_cT(2,:) = endo_c(2,:)-LVUpperCenter(2);
        endo_cT(3,:) = endo_c(3,:)-LVUpperCenter(3);
        endo_c = RotationMatrix*endo_cT;
        
        if imIndex == 1
           basalCentre = [mean(endo_c(1,:)),mean(endo_c(2,:)),mean(endo_c(3,:))] ;
        end

        %%translation and rotation for epicardial boundary
        epi_cT(1,:) = epi_c(1,:)-LVUpperCenter(1);
        epi_cT(2,:) = epi_c(2,:)-LVUpperCenter(2);
        epi_cT(3,:) = epi_c(3,:)-LVUpperCenter(3);
        epi_c = RotationMatrix*epi_cT;


        
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;
    
        DataSegSA_AlignWithLongAxis(imIndex).endo_cReal = endo_c;
        DataSegSA_AlignWithLongAxis(imIndex).epi_cReal = epi_c;
    
     end
         
end

figure(h); axis equal;

%%decide whether we use automated apex point defintion
cd(resultDir);
if exist('Apex_location.mat', 'file')
    load Apex_location;
    AutoApexDefintionB = 0; 
else
    AutoApexDefintionB = 1;
end
cd(workingDir);


%%now output the LX data 
apexInnerFinal = [];
apexOutterFinal = [];
for imIndex = 1 : usuableLXSlice  
    if isempty(find(sliceToBeSkippedLA==imIndex, 1)) 
        apexInner = [0 0 0];
        apexOuter = [0 0 0];

        endo_c = DataSegLA(imIndex).endo_cReal;
        epi_c = DataSegLA(imIndex).epi_cReal;

        %%%translation and rotation for endocardial boundary
        clear endo_cT
        endo_cT(1,:) = endo_c(1,:)-LVUpperCenter(1);
        endo_cT(2,:) = endo_c(2,:)-LVUpperCenter(2);
        endo_cT(3,:) = endo_c(3,:)-LVUpperCenter(3);
        endo_cOri = RotationMatrix*endo_cT;

        %%translation and rotation for epicardial boundary
        clear epi_cT
        epi_cT(1,:) = epi_c(1,:)-LVUpperCenter(1);
        epi_cT(2,:) = epi_c(2,:)-LVUpperCenter(2);
        epi_cT(3,:) = epi_c(3,:)-LVUpperCenter(3);
        epi_cOri = RotationMatrix*epi_cT;

        %%%now need to get rid of the points higher than the basal plane
        nodeIndexAdded = 0;
        endo_c = [];
        for i = 1 : size(endo_cOri,2)
            if  endo_cOri(3,i)<basalCentre(3)-0.5
                nodeIndexAdded = nodeIndexAdded + 1;
                endo_c(1,nodeIndexAdded) = endo_cOri(1,i);
                endo_c(2,nodeIndexAdded) = endo_cOri(2,i);
                endo_c(3,nodeIndexAdded) = endo_cOri(3,i);
            end
            
            if apexInner(3)>endo_cOri(3,i)
                apexInner= endo_cOri(:,i)';%%find the lowest point
            end
        end
        apexInnerFinal(imIndex,:) = apexInner;
        
        nodeIndexAdded = 0;
        epi_c = [];
        for i = 1 : size(epi_cOri,2)
            if  epi_cOri(3,i)<basalCentre(3)-0.5
                nodeIndexAdded = nodeIndexAdded + 1;
                epi_c(1,nodeIndexAdded) = epi_cOri(1,i);
                epi_c(2,nodeIndexAdded) = epi_cOri(2,i);
                epi_c(3,nodeIndexAdded) = epi_cOri(3,i);
            end
            
            if apexOuter(3)>epi_cOri(3,i)
                apexOuter = epi_cOri(:,i)';%%find the lowest point
            end
        end
        apexOutterFinal(imIndex,:) = apexOuter;
        
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;
                
    end
end

apexInner_point = mean(apexInnerFinal);
apexOutter_point = mean(apexOutterFinal);

%%so the long axis is the lowest point, not from the fitted one
%%we have apex_endo and apex_epi, no need to use the automatic one
%Apex_endo
%Apex_epi
% apexInnerFinal = [];
% apexOutterFinal = [];
% clear endo_cT;
% clear epi_cT;
% for i = 1 : size(Apex_endo,2)
%     endo_c = Apex_endo(1,i).endo_cReal;
%     endo_cT(1,:) = endo_c(1,:)-LVUpperCenter(1);
%     endo_cT(2,:) = endo_c(2,:)-LVUpperCenter(2);
%     endo_cT(3,:) = endo_c(3,:)-LVUpperCenter(3);
%     endo_cOri = RotationMatrix*endo_cT;
%     apexInnerFinal(:,i) = endo_cOri;
%     
%     epi_c = Apex_epi(1,i).epi_cReal;
%     epi_cT(1,:) = epi_c(1,:)-LVUpperCenter(1);
%     epi_cT(2,:) = epi_c(2,:)-LVUpperCenter(2);
%     epi_cT(3,:) = epi_c(3,:)-LVUpperCenter(3);
%     epi_cOri = RotationMatrix*endo_cT;
%     apexOutterFinal(:,i) = epi_cOri;
% end
% 
% apexInner_point = mean(apexInnerFinal');
% apexOutter_point = mean(apexOutterFinal');


hold on; 
line([0 0], [0 0], [0 -7/scaleCM], 'LineWidth', 2, 'color', 'k')
plot3(apexInner_point(1), apexInner_point(2), apexInner_point(3), 'Marker', '+', 'MarkerFaceColor', 'b');
plot3(apexOutter_point(1), apexOutter_point(2), apexOutter_point(3), 'Marker', '+', 'MarkerFaceColor', 'r');

axis equal;


apex_point_axis = (apexInner_point+apexOutter_point)./2;
line([0 apex_point_axis(1)], [0 apex_point_axis(2)], [0 apex_point_axis(3)], 'LineWidth', 2, 'color', 'k', 'LineStyle', '--')
line([0 DataSegSA_AlignWithLongAxis(1).endo_cReal(1,1)], [0 DataSegSA_AlignWithLongAxis(1).endo_cReal(2,1)], [0 DataSegSA_AlignWithLongAxis(1).endo_cReal(3,1)], 'LineWidth', 2, 'color', 'k', 'LineStyle', '--')

norm_longaxis =  NormalizationVec([0 0 0] - apex_point_axis);
%%the plane cross [0 0 0] with normal direction norm_longaxis is 
% norm_longaxis \cdot [x y z] = 0;


endo_c = DataSegSA_AlignWithLongAxis(1).endo_cReal;
epi_c = DataSegSA_AlignWithLongAxis(1).epi_cReal;
endo_cT_first = [];
for i = 1 : size(endo_c, 2)
    p = [ endo_c(1,i) endo_c(2,i) endo_c(3,i)];
    pT = project3DPointOnAPlaneDefOrignNormal(p,[0 0 0],norm_longaxis);
    endo_cT_first(1,i) = pT(1);
    endo_cT_first(2,i) = pT(2);
    endo_cT_first(3,i) = pT(3);
    
    
    p = [ epi_c(1,i) epi_c(2,i) epi_c(3,i)];
    pT = project3DPointOnAPlaneDefOrignNormal(p,[0 0 0],norm_longaxis);
    epi_cT_first(1,i) = pT(1);
    epi_cT_first(2,i) = pT(2);
    epi_cT_first(3,i) = pT(3);
    
end
% plot3(endo_cT_first(1,:),endo_cT_first(2,:), endo_cT_first(3,:),'LineStyle', '--', 'Color', 'k', 'LineWidth',2, 'Marker', '*');hold on;
% plot3(epi_cT_first(1,:),epi_cT_first(2,:), epi_cT_first(3,:),'LineStyle', '--', 'Color', 'k', 'LineWidth',2, 'Marker', '+');hold on;
% plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2, 'Marker', '*');hold on;
%%a different way to do maybe rotate the plane rather than projection

% norm_longaxis
SAXVecNew = NormalizationVec(endo_cT_first(:,1)'-[0 0 0]); 
LAXVecNew = norm_longaxis;
LAXVecNew = NormalizationVec(LAXVecNew);
SAYVecNew = NormalizationVec(cross(LAXVecNew,SAXVecNew));
SAXVecNew = NormalizationVec(cross(SAYVecNew,LAXVecNew));

    rightM = [1 0 0;
              0 1 0;
              0 0 1];
    leftM = [SAXVecNew(1) SAYVecNew(1) LAXVecNew(1);
             SAXVecNew(2) SAYVecNew(2) LAXVecNew(2);
             SAXVecNew(3) SAYVecNew(3) LAXVecNew(3)];
    
    RotationMatrixNew = rightM/leftM;
    if abs( det(RotationMatrixNew)-1)>0.1
        disp('determination of RotationMatrixNew is not 1');
        stop;
    end
endo_cT_first_rotate = endo_cT_first;  %%using rotation, not projection, endo_cT_first is projected 
epi_cT_first_rotate = epi_cT_first;
for i = 1 : size(endo_cT_first,2)
     p = [ endo_c(1,i); endo_c(2,i); endo_c(3,i)];
     pT = inv(RotationMatrixNew)*p;
     endo_cT_first_rotate(1,i) = pT(1);
     endo_cT_first_rotate(2,i) = pT(2);
     endo_cT_first_rotate(3,i) = pT(3);
     
     p = [ epi_c(1,i); epi_c(2,i); epi_c(3,i)];
     pT = inv(RotationMatrixNew)*p;
     epi_cT_first_rotate(1,i) = pT(1);
     epi_cT_first_rotate(2,i) = pT(2);
     epi_cT_first_rotate(3,i) = pT(3);
end

plot3(endo_cT_first_rotate(1,:),endo_cT_first_rotate(2,:), endo_cT_first_rotate(3,:),'LineStyle', '--', 'Color', 'y', 'LineWidth',2, 'Marker', '*');hold on;
plot3(epi_cT_first_rotate(1,:),epi_cT_first_rotate(2,:), epi_cT_first_rotate(3,:),'LineStyle', '--', 'Color', 'y', 'LineWidth',2, 'Marker', '+');hold on;




%%so now we need to get it back to CMR coordinate system
h2 = figure; hold on;
for imIndex = 1 : usuableSXSlice
    if isempty(find(sliceToBeSkipped==imIndex, 1))    
        endo_c = DataSegSA(imIndex).endo_cReal;
        epi_c = DataSegSA(imIndex).epi_cReal;
        
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;
    end
end
axis equal;
for imIndex = 1 : usuableLXSlice  
    if isempty(find(sliceToBeSkippedLA==imIndex, 1)) 
        endo_c = DataSegLA(imIndex).endo_cReal;
        epi_c = DataSegLA(imIndex).epi_cReal;
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;
    end
end
        
axis equal;

apex_point_axis_c = inv(RotationMatrix)*(apex_point_axis');
apex_point_axis_c = apex_point_axis_c'+ LVUpperCenter;
plot3(LVUpperCenter(1), LVUpperCenter(2), LVUpperCenter(3), 'Marker', '+', 'MarkerFaceColor', 'r');
plot3(apex_point_axis_c(1), apex_point_axis_c(2), apex_point_axis_c(3), 'Marker', '+', 'MarkerFaceColor', 'r');

%%project back the first plane into the the plane with long axis as the
%%normal
endo_cT_first_project = [];
epi_cT_first_project = [];
for i = 1 : size(endo_cT_first,2)
    pT = [endo_cT_first_rotate(1,i); endo_cT_first_rotate(2,i);endo_cT_first_rotate(3,i);];
    pT = inv(RotationMatrix)*pT;
    pT = pT'+LVUpperCenter;
    
    endo_cT_first_project(1,i) = pT(1);
    endo_cT_first_project(2,i) = pT(2);
    endo_cT_first_project(3,i) = pT(3);
    
    pT = [epi_cT_first_rotate(1,i); epi_cT_first_rotate(2,i);epi_cT_first_rotate(3,i);];
    pT = inv(RotationMatrix)*pT;
    pT = pT'+LVUpperCenter;
    
    epi_cT_first_project(1,i) = pT(1);
    epi_cT_first_project(2,i) = pT(2);
    epi_cT_first_project(3,i) = pT(3);
    
end
plot3(endo_cT_first_project(1,:),endo_cT_first_project(2,:), endo_cT_first_project(3,:),'LineStyle', '--', 'Color', 'k', 'LineWidth',2, 'Marker', '*');hold on;
plot3(epi_cT_first_project(1,:),epi_cT_first_project(2,:), epi_cT_first_project(3,:),'LineStyle', '--', 'Color', 'r', 'LineWidth',2, 'Marker', '*');hold on;

line([LVUpperCenter(1) apex_point_axis_c(1)], [LVUpperCenter(2) apex_point_axis_c(2)], [LVUpperCenter(3) apex_point_axis_c(3)], 'LineWidth', 2, 'color', 'k', 'LineStyle', '--')
line([LVUpperCenter(1) endo_cT_first_project(1,1)], [LVUpperCenter(2) endo_cT_first_project(2,1)], [LVUpperCenter(3) endo_cT_first_project(3,1)], 'LineWidth', 2, 'color', 'k', 'LineStyle', '--')


SAXVecNew = NormalizationVec(endo_cT_first_project(:,1)'-LVUpperCenter); 
LAXVecNew = [LVUpperCenter(1)- apex_point_axis_c(1), LVUpperCenter(2)-apex_point_axis_c(2),LVUpperCenter(3)-apex_point_axis_c(3)];
LAXVecNew = NormalizationVec(LAXVecNew);
SAYVecNew = NormalizationVec( cross(LAXVecNew,SAXVecNew));
SAXVecNew = NormalizationVec( cross(SAYVecNew,LAXVecNew));



LVUpperCenterNew = [mean(endo_cT_first_project(1,:)) mean(endo_cT_first_project(2,:)) mean(endo_cT_first_project(3,:))];

%%we only need to replace the first short axial slice 
DataSegSA_AlignWithLongAxis = DataSegSA;
DataSegSA_AlignWithLongAxis(1).endo_cReal =  endo_cT_first_project;
DataSegSA_AlignWithLongAxis(1).epi_cReal =  epi_cT_first_project;

cd(resultDir);
save DataSegSA_AlignWithLongAxis DataSegSA_AlignWithLongAxis;
cd(workingDir);

