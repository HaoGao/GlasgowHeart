%%% creat fiber direction in the endo surface 
function [fiberDir, sheetDir]= FibreConstructionEndo_HexMesh(abaqusInputDir, workingDir, dataResult)


cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);
cd(dataResult);
load localCorSys;
load helixAngle;
load nodeDistance;
cd(workingDir);


epiB = -2; 
endoB = 2; 
innerB = 0;

[heart_node, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_node, epiB, endoB);

Ver = heart_node(:,2:4);
EndoMesh = endoSurf;
NoofPoints = size(Ver,1);
CenterPoint = [0 0 max(heart_node(:,4))];
fiberDir = zeros([NoofPoints,3]);
sheetDir = zeros([NoofPoints,3]);

for verInd = 1 : NoofPoints
    if heart_node(verInd,5)== endoB  
       theta = helixAngle(verInd);
       v1 = localCorSys.CirPA(verInd,:);
       v2 = localCorSys.AxialPA(verInd,:);
       fiberDir(verInd,:)=NormalizationVec(cos(theta).*v1+sin(theta).*v2);
       %%%sheet angle
       thetaSheet = sheetAngle(verInd);
       fiberTemp = fiberDir(verInd,:);
       NormalTemp = -localCorSys.NormalPA(verInd,:);
       sheetTemp=NormalizationVec(cos(thetaSheet).*NormalTemp+sin(thetaSheet).*(-v2));
       axialTemp=NormalizationVec(cross(sheetTemp, fiberTemp));
       sheetTemp=NormalizationVec(cross(fiberTemp,axialTemp));
       sheetDir(verInd,:)=sheetTemp;
       %%%% if the direction is in the oppsite direction
       %fiberDir(verInd,:)=-cos(theta).*v1+sin(theta).*v2;
       %%%this is for cicumferential and radial directions
       circumDir(verInd,:) = v1;
       radialDir(verInd,:) = cross(v2,v1);
    elseif heart_node(verInd,5)==epiB
        theta = helixAngle(verInd);
        v1 = localCorSys.CirPA(verInd,:);
        v2 = localCorSys.AxialPA(verInd,:);
        fiberDir(verInd,:)=NormalizationVec(cos(theta).*v1+sin(theta).*v2);
        %%%sheet Dir
        thetaSheet = sheetAngle(verInd);
        fiberTemp = fiberDir(verInd,:);
        NormalTemp = -localCorSys.NormalPA(verInd,:);
        sheetTemp=NormalizationVec(cos(thetaSheet).*NormalTemp+sin(thetaSheet).*(-v2));
        axialTemp=NormalizationVec(cross(sheetTemp, fiberTemp));
        sheetTemp=NormalizationVec(cross(fiberTemp,axialTemp));
        sheetDir(verInd,:)=sheetTemp;
        %%%this is for cicumferential and radial directions
        circumDir(verInd,:) = v1;
        radialDir(verInd,:) = cross(v2,v1);
    elseif heart_node(verInd,5)==innerB
        %%% inner points
        theta = helixAngle(verInd);
        e=nodeDistance(verInd,1);
        pendo = nodeDistance(verInd,2);
        pepi = nodeDistance(verInd,3);
        v1endo = localCorSys.CirPA(pendo,:);
        v2endo = localCorSys.AxialPA(pendo,:);
        fiberEndo = cos(theta).*v1endo + sin(theta).*v2endo;
        v1epi = localCorSys.CirPA(pepi,:);
        v2epi = localCorSys.AxialPA(pepi,:);
        fiberEpi = cos(theta).*v1epi + sin(theta).*v2epi;
        fiberTemp = (1-e).*fiberEndo + e.*fiberEpi;
        fiberDir(verInd,:)=NormalizationVec(fiberTemp);
        v2 = (1-e).*v2endo + e.*v2epi;
        %%normal direction
        nendo = localCorSys.NormalPA(pendo,:);
        nepi = localCorSys.NormalPA(pepi,:);
        thetaSheet = sheetAngle(verInd);
        fiberTemp = fiberDir(verInd,:);
        NormalTemp = -((1-e).*nendo + e.*nepi);
        sheetTemp=NormalizationVec(cos(thetaSheet).*NormalTemp+sin(thetaSheet).*(-v2));
        axialTemp=NormalizationVec(cross(sheetTemp, fiberTemp));
        sheetTemp=NormalizationVec(cross(fiberTemp,axialTemp));
        sheetDir(verInd,:)=sheetTemp;
        %%%this is for cicumferential and radial directions
        v1 = (1-e).*v1endo + e.*v1epi;
        circumDir(verInd,:) = v1;
        radialDir(verInd,:) = cross(v2,v1);
        
    end
end

VerifyNormalVec(fiberDir);
VerifyNormalVec(sheetDir);


%%%%fiberDirection in the center of element
for eleIndex = 1 : size(heart_ele,1)
    pindex=heart_ele(eleIndex,2:9);
    for i = 1 : length(pindex)
        fiberEleT(i,:)=fiberDir(pindex(i),:);
        sheetEleT(i,:)=sheetDir(pindex(i),:);
        cirEleT(i,:) = circumDir(pindex(i),:);
        radEleT(i,:) = radialDir(pindex(i),:);
    end
    fiberEleA(1)=mean(fiberEleT(:,1));
    fiberEleA(2)=mean(fiberEleT(:,2));
    fiberEleA(3)=mean(fiberEleT(:,3));
    sheetEleA(1)=mean(sheetEleT(:,1));
    sheetEleA(2)=mean(sheetEleT(:,2));
    sheetEleA(3)=mean(sheetEleT(:,3));
    fiberEleA = NormalizationVec(fiberEleA);
    sheetEleA = NormalizationVec(sheetEleA);
    normalEleA = cross(fiberEleA, sheetEleA);
    
    cirEleA(1) = mean(cirEleT(:,1));
    cirEleA(2) = mean(cirEleT(:,2));
    cirEleA(3) = mean(cirEleT(:,3));
    radEleA(1) = mean(radEleT(:,1));
    radEleA(2) = mean(radEleT(:,2));
    radEleA(3) = mean(radEleT(:,3));
    cirEleA = NormalizationVec(cirEleA);
    radEleA = NormalizationVec(radEleA);
    
    sheetEleA = NormalizationVec(cross(normalEleA,fiberEleA));
    EleFiberDir(eleIndex).fiberEleA = fiberEleA;
    EleFiberDir(eleIndex).sheetEleA = sheetEleA;
    
    EleFiberDir(eleIndex).cirEleA = cirEleA;
    EleFiberDir(eleIndex).radEleA = radEleA;
    
end




%%%output for visualization
TecplotMeshGenVec_HexMesh(heart_node, heart_ele,fiberDir, 'fiberDir', dataResult);
TecplotMeshGenVec_HexMesh(heart_node, heart_ele,sheetDir, 'sheetDir', dataResult);
cd(dataResult);
save FiberDirection fiberDir sheetDir ;
save FiberDirectionCircum circumDir radialDir;
cd(workingDir);
%%%%dataoutput

cd(dataResult);
fidFiberfile = fopen('fiberDir.txt','w');
fidSheetfile = fopen('sheetDir.txt','w');
fidCirfile = fopen('cirDir.txt','w');
fidRadfile = fopen('radDir.txt','w');

for i = 1 : size(heart_ele,1)
    fprintf(fidFiberfile,'%d\t%f\t%f\t%f\n',i,EleFiberDir(i).fiberEleA(1),EleFiberDir(i).fiberEleA(2),EleFiberDir(i).fiberEleA(3));
    fprintf(fidSheetfile,'%d\t%f\t%f\t%f\n',i,EleFiberDir(i).sheetEleA(1),EleFiberDir(i).sheetEleA(2),EleFiberDir(i).sheetEleA(3));
    
    
    fprintf(fidCirfile,'%d\t%f\t%f\t%f\n',i,EleFiberDir(i).cirEleA(1),EleFiberDir(i).cirEleA(2),EleFiberDir(i).cirEleA(3));
    fprintf(fidRadfile,'%d\t%f\t%f\t%f\n',i,EleFiberDir(i).radEleA(1),EleFiberDir(i).radEleA(2),EleFiberDir(i).radEleA(3));
end
fclose(fidFiberfile);
fclose(fidSheetfile);
fclose(fidCirfile);
fclose(fidRadfile);
cd(workingDir);


function VerifyNormalVec(fiberDir)
for i = 1 : size(fiberDir(:,1))
    t1=fiberDir(i,1);
    t2=fiberDir(i,2);
    t3=fiberDir(i,3);
    if abs(t1^2+t2^2+t3^2-1)>=0.1
        disp('vector wrong');
        pause;
    end
end


