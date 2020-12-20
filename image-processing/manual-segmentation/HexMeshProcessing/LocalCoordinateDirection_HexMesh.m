function localCorSys = LocalCoordinateDirection_HexMesh(heart_node,endoSurf, epiSurf,endoB,epiB,NormalPA)
clear all; close all; clc;
DirConfig;
workingDir = pwd();

cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);
cd(dataResult);
load NormalPA;
cd(workingDir);


epiB = -2; 
endoB = 2; 
innerB = 0;

[heart_node, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_node, epiB, endoB);

Ver = heart_node(:,2:4);
EndoMesh = endoSurf;
NoofPoints = size(Ver,1);
CenterPoint = [0 0 max(heart_node(:,4))];

% %%% 1/8 region will be defined as the apex region, no fiber orientation
% %%% will be calculated
% minZThr = min(Ver(:,3))*(1-1/4); 
% 
% %%% out put the new data set of NormalPA
% for i = 1 : NoofPoints
%     if Ver(i,3)<=minZThr 
%         NormalPA(i,:)=[0 0 0];
%     end
% end
% % TecplotMeshGenVec(heart_node, heart_ele,NormalPA);

%%%to define the circumferentail direction, here we assume it is in the z
%%%xy plane, therefore nz=0
CirPA = zeros(size(NormalPA));
AxialPA = zeros(size(NormalPA));
for i = 1 : NoofPoints
    if heart_node(i,5)==endoB || heart_node(i,5)==epiB
       if abs(NormalPA(i,2))+abs(NormalPA(i,1))>=0.01
            CirPA(i,1)=-NormalPA(i,2);
            CirPA(i,2)=NormalPA(i,1);
            CirPA(i,3)=0;
    %     CirPA(i,:)=-CirPA(i,:); %% - to make the other one up
            AxialPA(i,:) = -cross(CirPA(i,:), NormalPA(i,:));%%
       else
           CirPA(i,:)=[1 0 0];
           AxialPA(i,:)=[0 1 0];
%            NormalPA(i,:)
%            pause;
       end
    end
       
end

TecplotMeshGenVec_HexMesh(heart_node, heart_ele,CirPA,'CirPA', dataResult);
TecplotMeshGenVec_HexMesh(heart_node, heart_ele,AxialPA,'AxialPA', dataResult);

localCorSys.NormalPA = NormalPA;
localCorSys.CirPA = CirPA;
localCorSys.AxialPA = AxialPA;

cd(dataResult);
save localCorSys localCorSys;
cd(workingDir);




