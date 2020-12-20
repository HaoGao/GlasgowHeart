%%%normal direction by avarage
function NormalPA = NormalDirectionEndoSurf_HexMesh(abaqusInputDir, workingDir, dataResult)

cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);
cd(dataResult);
load NormalP;
cd(workingDir);

epiB = -2; 
endoB = 2; 
innerB = 0;

[heart_node, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_node, epiB, endoB);


Ver = heart_node(:,2:4);
EndoMesh = endoSurf;
NoofPoints = size(Ver,1);
CenterPoint = [0 0 max(heart_node(:,4))];

% SurfacePlot(heart_node,endoSurf,epiSurf,1);hold on;
NormalPA = NormalP;

for verInd = 1 : NoofPoints
    if heart_node(verInd,5)== endoB || heart_node(verInd,5)==epiB   
            rV = CenterPoint-Ver(verInd,:);
            NormalPA(verInd,:)=sign(dot(rV,NormalP(verInd,:))).*NormalP(verInd,:);
    end      
end

%%% for output with tecplot
NormalPATec = NormalPA;
for verInd = 1 : NoofPoints
    if heart_node(verInd,5)==epiB   
             NormalPATec(verInd,:)=-NormalPATec(verInd,:);
%               NormalPATec(verInd,:)=[0 0 0];  
    end      
end
   


TecplotMeshGenVec_HexMesh(heart_node, heart_ele,NormalPATec, 'NormalPATec', dataResult);
cd(dataResult);
save NormalPA NormalPA;
cd(workingDir);            