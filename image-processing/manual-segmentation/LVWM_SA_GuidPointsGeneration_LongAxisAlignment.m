function LVWM_SA_GuidPointsGeneration_LongAxisAlignment(projectConfig_dir,...
    projectConfig_name)

close all;clc;
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
AutoApexDefintionB = 1; %%decide whether we will use manually defined apex location

cd(resultDir);
load imDesired;
load DataSegSA;
load DataSegLA;
load DataSegSA_AlignWithLongAxis;
cd(workingDir); 








% if reversedSequence
%     for imIndex = 1 : usuableSXSlice
%         DataSegSAT(usuableSXSlice-imIndex+1) = DataSegSA(imIndex);
%     end
%     DataSegSA = DataSegSAT;
%     sliceToBeSkipped = usuableSXSlice +1 - sliceToBeSkipped;
% end


cd(resultDir);
fidinner = fopen('innerGuidePoints.dat','w');
fidouter = fopen('outerGuidePoints.dat','w');
cd(workingDir);

%using the updated aligned boundary data, mainly for the frist basal plane
DataSegSA = DataSegSA_AlignWithLongAxis;
%%add the long axial image data as a short axis image data
usuableSXSlice = size(DataSegSA,2);
lastSABool = questdlg('would you include the last SA slice','SA slice');
if strcmp(lastSABool, 'No')
    usuableSXSlice = usuableSXSlice - 1;
end
usuableLXSlice = size(DataSegLA,2); %% for HV13,HV67, HV77, HV82, need to use -1
nubmerOfSlices = usuableSXSlice-length(sliceToBeSkipped) + usuableLXSlice - length(sliceToBeSkippedLA);


fprintf(fidinner, '%d\t number of slices \n', nubmerOfSlices);
fprintf(fidouter, '%d\t number of slices \n', nubmerOfSlices);


% % %%moving basal plane towards the apecial point
% if abs(basalMovingDistance)>1.0e-6 && basalMoving == 1 
%     disp('basal will be moved down towards apex');
%     
%     basalMovingDistance = abs(basalMovingDistance);
%     sliceDistanceTemp = DataSegSA(1,1).endo_cReal(3,1) - DataSegSA(1,2).endo_cReal(3,1);
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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find apex center projection on basal plane %Wchen 2016
% 
% p1 = DataSegSA(1).endo_cReal(:,1);
% p2 = DataSegSA(1).endo_cReal(:,15);
% p3 = DataSegSA(1).endo_cReal(:,30);
% [a, b, c, d] = getplane(p1,p2,p3);
% 
% disMax = 0.0;
% for imLA = 1 : usuableLXSlice
%     endo_c = DataSegLA(imLA).endo_cReal;
%     for imIndex = 1: size(endo_c,2)
%         pt(1) = endo_c(1,imIndex);
%         pt(2) = endo_c(2,imIndex);
%         pt(3) = endo_c(3,imIndex);
%         dis = abs(disP2Plane( pt, a, b, c, d));
%         if dis > disMax
%             Pmax = pt;
%             disMax = dis;
%         end
%     end
% end
% disMax=disMax*1.0;%Wchen
% Pnew = GetProjection(Pmax, a, b, c, d);
% UpCenter = [mean(DataSegSA(1,1).endo_cReal(1,:)) mean(DataSegSA(1,1).endo_cReal(2,:)) mean(DataSegSA(1,1).endo_cReal(3,:))];
% Sdis = sqrt((Pnew(1)-UpCenter(1))^2+(Pnew(2)-UpCenter(2))^2+(Pnew(3)-UpCenter(3))^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%updates in 2016, the LVUpperCenter is still the same, but the
%%%normal z axis will be defined only through the basal plane, so this will
%%%be consistent with MRI scan protocol
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
    SAYVec = cross(LAVec, SAXVec); %%point to the j direction in the image coordinate
    SAXVec = cross(SAYVec, LAVec); %%point to the -i direction in the image coordinate
    
    
    if  MRIimageFlipB== 1
        disp('flip the coordinate sytem because of image orientation');
        SAXVecTem = SAXVec;
        SAXVec = SAYVec;
        SAYVec = -1*SAXVecTem;
    end
    

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
    
	cd(resultDir);
	save rotationConfig LVUpperCenter LVApexCenter RotationMatrix;
	cd(workingDir);
end


%     Pnew = RotationMatrix * (Pnew-LVUpperCenter)';%Wchen
%     UpCenter = RotationMatrix * (UpCenter-LVUpperCenter)'; %Wchen
%     Xdis = abs(Pnew(1)-UpCenter(1));
%     Ydis = abs(Pnew(2)-UpCenter(2));
%     Sdis = sqrt((Pnew(1)-UpCenter(1))^2+(Pnew(2)-UpCenter(2))^2+(Pnew(3)-UpCenter(3))^2); %Wchen

DataSegSATranslated = DataSegSA;
h1 = figure(); hold on;
for imIndex = 1 : usuableSXSlice
    if isempty(find(sliceToBeSkipped==imIndex, 1))    
        endo_c = DataSegSA(imIndex).endo_cReal;
        epi_c = DataSegSA(imIndex).epi_cReal;

        %%%translation and rotation for endocardial boundary
        endo_cT(1,:) = endo_c(1,:)-LVUpperCenter(1);
        endo_cT(2,:) = endo_c(2,:)-LVUpperCenter(2);
        endo_cT(3,:) = endo_c(3,:)-LVUpperCenter(3);
        endo_c = RotationMatrix*endo_cT;
        
        

        %%translation and rotation for epicardial boundary
        epi_cT(1,:) = epi_c(1,:)-LVUpperCenter(1);
        epi_cT(2,:) = epi_c(2,:)-LVUpperCenter(2);
        epi_cT(3,:) = epi_c(3,:)-LVUpperCenter(3);
        epi_c = RotationMatrix*epi_cT;
        
        DataSegSATranslated(imIndex).endo_cReal = endo_c;
        DataSegSATranslated(imIndex).epi_cReal = epi_c;
        
        
    end
         
end


%%output for guide points
for imIndex = 1 : usuableSXSlice
        endo_c = DataSegSATranslated(imIndex).endo_cReal;
        epi_c = DataSegSATranslated(imIndex).epi_cReal;
        
        if imIndex == 1
           basalCentre = [mean(endo_c(1,:)),mean(endo_c(2,:)),mean(endo_c(3,:))] ;
        end
        
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;

        fprintf(fidinner, '%d\t points on slice \t%d \n', size(endo_c,2), imIndex);
        for pIndex = 1 : size(endo_c,2)
%             endo_c(1,pIndex) = endo_c(1,pIndex) + abs(endo_c(3,pIndex))/disMax*Xdis; %Wchen 2016
%             endo_c(2,pIndex) = endo_c(2,pIndex) - abs(endo_c(3,pIndex))/disMax*Ydis; %Wchen 2016
            fprintf(fidinner, '\t %f \t %f \t %f \n', endo_c(1,pIndex)*scaleCM,endo_c(2,pIndex)*scaleCM, endo_c(3,pIndex)*scaleCM);
        end

        fprintf(fidouter, '%d\t points on slice \t%d \n', size(epi_c,2), imIndex);
        for pIndex = 1 : size(epi_c,2)
%              epi_c(1,pIndex) =  epi_c(1,pIndex) + abs(epi_c(3,pIndex))/disMax*Xdis; %Wchen 2016
%              epi_c(2,pIndex) =  epi_c(2,pIndex) - abs(epi_c(3,pIndex))/disMax*Ydis; %Wchen 2016
            fprintf(fidouter, '\t %f \t %f \t %f \n', epi_c(1,pIndex)*scaleCM,epi_c(2,pIndex)*scaleCM, epi_c(3,pIndex)*scaleCM);
        end    
    
end



cd(resultDir);
if exist('Apex_location.mat', 'file')
    load Apex_location;
    AutoApexDefintionB = 1; 
else
    AutoApexDefintionB = 0;
end
cd(workingDir);


%%now output the LX data 
apexInnerMan = [0 0 0];
apexOuterMan = [0 0 0];

if AutoApexDefintionB 
    apexInner_c = [];
    apexOutter_c = [];
    for i = 1 : size(Apex_endo,2)
        apexInner_c = [apexInner_c, Apex_endo(1,i).endo_cReal];
        apexOutter_c = [apexOutter_c, Apex_epi(1,i).epi_cReal];
    end
    
            apex_endo_cT(1,:) = apexInner_c(1,:)-LVUpperCenter(1);
            apex_endo_cT(2,:) = apexInner_c(2,:)-LVUpperCenter(2);
            apex_endo_cT(3,:) = apexInner_c(3,:)-LVUpperCenter(3);
            apex_endo_cOri = RotationMatrix*apex_endo_cT;
            
            apex_epi_cT(1,:) = apexOutter_c(1,:)-LVUpperCenter(1);
            apex_epi_cT(2,:) = apexOutter_c(2,:)-LVUpperCenter(2);
            apex_epi_cT(3,:) = apexOutter_c(3,:)-LVUpperCenter(3);
            apex_epi_cOri = RotationMatrix*apex_epi_cT;
    
             apexInnerMan = [mean(apex_endo_cOri(1,:)), mean(apex_endo_cOri(2,:)), mean(apex_endo_cOri(3,:))];
             apexOuterMan = [mean(apex_epi_cOri(1,:)), mean(apex_epi_cOri(2,:)), mean(apex_epi_cOri(3,:))];
    
    
end

apexInner = [0 0 0];
apexOuter = [0 0 0];
for imIndex = 1 : usuableLXSlice  
        if isempty(find(sliceToBeSkippedLA==imIndex, 1)) 
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
                    apexInner = endo_cOri(:,i)';%%find the lowest point
                end
            end

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

            plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);hold on;
            plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);hold on;

            fprintf(fidinner, '%d\t points on slice \t%d \n', size(endo_c,2), imIndex+usuableSXSlice);
            for pIndex = 1 : size(endo_c,2)
    %             endo_c(1,pIndex) = endo_c(1,pIndex) + abs(endo_c(3,pIndex))/disMax*Xdis; %Wchen 2016
    %             endo_c(2,pIndex) = endo_c(2,pIndex) - abs(endo_c(3,pIndex))/disMax*Ydis; %Wchen 2016
                fprintf(fidinner, '\t %f \t %f \t %f \n', endo_c(1,pIndex)*scaleCM,endo_c(2,pIndex)*scaleCM, endo_c(3,pIndex)*scaleCM);
            end

            fprintf(fidouter, '%d\t points on slice \t%d \n', size(epi_c,2), imIndex+usuableSXSlice);
            for pIndex = 1 : size(epi_c,2)
    %             epi_c(1,pIndex) = epi_c(1,pIndex) + abs(epi_c(3,pIndex))/disMax*Xdis;  %Wchen 2016
    %             epi_c(2,pIndex) = epi_c(2,pIndex) - abs(epi_c(3,pIndex))/disMax*Ydis;  %Wchen 2016
                fprintf(fidouter, '\t %f \t %f \t %f \n', epi_c(1,pIndex)*scaleCM,epi_c(2,pIndex)*scaleCM, epi_c(3,pIndex)*scaleCM);
            end

        end
end
    




% %%%now need to add the apex location half of the slice distance with 5mm
% %%%thickness
% % usuableSXSlice = usuableSXSlice + 1; %%this is for alex data
% updatedLVApexCenter = [mean(endo_c(1,:)) mean(endo_c(2,:)) mean(endo_c(3,:))];
% LAVec_apex = NormalizationVec([0 0 0] - updatedLVApexCenter);
% sliceDistance = ( (DataSegSA(1,usuableSXSlice).epi_cReal(3,1) - DataSegSA(1,usuableSXSlice-1).epi_cReal(3,1))^2 + ...
%                    (DataSegSA(1,usuableSXSlice).epi_cReal(1,1) - DataSegSA(1,usuableSXSlice-1).epi_cReal(1,1))^2 + ...
%                    (DataSegSA(1,usuableSXSlice).epi_cReal(2,1) - DataSegSA(1,usuableSXSlice-1).epi_cReal(2,1))^2 )^0.5;
% % sliceDistance = SASliceDistance;
% apexInnerDis = mean( epi_c(3,:) ) - 0.5*sliceDistance;
% %apexOuterDis = apexInnerDis-0.8*sliceDistance;
% %apexInner = LAVec_apex*apexInnerDis;
% %apexOuter = LAVec_apex*apexOuterDis;
% apexInner = [mean(epi_c(1,:)), mean(epi_c(2,:)), mean(epi_c(3,:))- 0.5*sliceDistance];
% apexOuter = apexInner + [0 0 -0.3*sliceDistance];


if AutoApexDefintionB
    apexInner = apexInnerMan;
    apexOuter = apexOuterMan;
end
plot3(apexInner(1), apexInner(2), apexInner(3), 'Marker','+', 'MarkerFaceColor', 'b');
plot3(apexOuter(1), apexOuter(2), apexOuter(3), 'Marker', '*', 'MarkerFaceColor', 'r');


%%if we donot output apex point
fprintf(fidinner, '1\t This last point is inner apex point \n');
% apexInner(1) = apexInner(1)  +  abs(apexInner(3))/disMax*Xdis; %Wchen 2016
% apexInner(2) = apexInner(2)  -  abs(apexInner(3))/disMax*Ydis; %Wchen 2016
fprintf(fidinner, '\t %f \t%f \t%f \n', apexInner(1)*scaleCM, apexInner(2)*scaleCM, apexInner(3)*scaleCM);

fprintf(fidouter, '1\t This last point is outer apex point \n');
% apexOuter(1) = apexOuter(1)  +  abs(apexOuter(3))/disMax*Xdis; %Wchen 2016
% apexOuter(2) = apexOuter(2)  -  abs(apexOuter(3))/disMax*Ydis; %Wchen 2016

fprintf(fidouter, '\t %f \t%f \t%f \n', apexOuter(1)*scaleCM, apexOuter(2)*scaleCM, apexOuter(3)*scaleCM);

fclose(fidinner);
fclose(fidouter);

% MappingBack = [Xdis Ydis disMax];
% save MappingBack.dat MappingBack -ascii;


figure(h1); axis equal;





    
    