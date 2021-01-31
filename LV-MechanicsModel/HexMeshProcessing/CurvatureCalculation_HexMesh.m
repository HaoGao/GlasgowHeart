function NormalP=CurvatureCalculation_HexMesh(abaqusInputDir, workingDir, dataResult)


cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);

epiB = -2; 
endoB = 2; 
innerB = 0;

[heart_node, endoSurf, epiSurf] = NodeClassification_HexMesh(heart_face,heart_node, epiB, endoB);



Ver = heart_node(:,2:4);
EndoMesh = endoSurf;
NoofPoints = size(Ver,1);

bendoepi = 1;
% SurfacePlot(heart_node,endoSurf,epiSurf,bendoepi);


% SurfacePlot(heart_node,endoSurf,epiSurf,1);hold on;
NormalP = zeros([size(Ver,1),3]);

for verInd = 1 : NoofPoints
% for verInd = 142
    if heart_node(verInd,5)== endoB   
        [neighbour0  meshNeighbour]=Neighbour0Find(verInd,EndoMesh);
        %%%normal direction
        point_orign=[];
        points_sur = [];
        point_orign = Ver(neighbour0(1),:);
        points_sur = Ver(neighbour0,:);
        n=NormalCalculaiton(neighbour0,meshNeighbour,points_sur,Ver);
        NormalP(verInd,:)=n;
%         verInd
    elseif heart_node(verInd,5)== epiB
        [neighbour0  meshNeighbour]=Neighbour0Find(verInd,epiSurf);
        %%%normal direction
        point_orign=[];
        points_sur = [];
        point_orign = Ver(neighbour0(1),:);
        points_sur = Ver(neighbour0,:);
        n=NormalCalculaiton(neighbour0,meshNeighbour,points_sur,Ver);
        NormalP(verInd,:)=n;
%         verInd
    end
    
end

cd(dataResult);
save NormalP NormalP;
cd(workingDir);

TecplotMeshGenVec_HexMesh(heart_node, heart_ele,NormalP,'NormalP',dataResult);    
    
function [n]=GaussianCurvatureV(point_orign, points_sur)
%% reference: a comparison of local surface geometry estimation methods,
%% Machine vision and application(1997)10:17-26

points_sur(:,1) =points_sur(:,1)-point_orign(1);
points_sur(:,2)=points_sur(:,2)-point_orign(2);
points_sur(:,3)=points_sur(:,3)-point_orign(3);
point_orig = [0 0 0];

for i = 1 : size(points_sur,1)
    p=points_sur(i,1);
    q=points_sur(i,2);
    Z(i)=points_sur(i,3);
    C(i,1)=1;
    C(i,2)=p;
    C(i,3)=q;
    C(i,4)=p^2;
    C(i,5)=p*q;
    C(i,6)=q^2;
end


%%%calculate the weights
dmin = 100000;
for i = 2 : size(points_sur,1)
    d= (points_sur(i,1)-points_sur(1,1))^2+(points_sur(i,2)-points_sur(1,2))^2+(points_sur(i,3)-points_sur(1,3))^2;
    d = d^0.5;
    if d<dmin
        dmin = d;
    end
end

for i = 1 : size(points_sur,1)
    dweight(i)=(points_sur(i,1)-points_sur(1,1))^2+(points_sur(i,2)-points_sur(1,2))^2+(points_sur(i,3)-points_sur(1,3))^2;
    dweight(i)=exp(1-dweight(i)^0.5/dmin);
end

dweight = diag(dweight);   

% c=C\(Z');
c = inv(C'*dweight*C)*C'*dweight*Z';
a1=c(4);b1=c(5);c1=c(6);d1=c(2);e1=c(3);f1=c(1);

n=[-d1;-e1;1]/(1+d1^2+e1^2)^0.5;




function  n=NormalCalculaiton(neighbour0,meshNeighbour, points_sur,Ver)
%%%calculate the first normal from meshNeighbour
mesh1 = meshNeighbour(1,:);
centerP = neighbour0(1);
for i = 1 : length(mesh1)
    if mesh1(1) == centerP
        v1(1:3) = Ver(mesh1(2),:)-Ver(mesh1(1),:);
        v2(1:3) = Ver(mesh1(4),:)-Ver(mesh1(1),:);
        v12 = cross(v1,v2);
    elseif mesh1(2)==centerP
        v1(1:3) = Ver(mesh1(1),:)-Ver(mesh1(2),:);
        v2(1:3) = Ver(mesh1(3),:)-Ver(mesh1(2),:);
        v12 = cross(v2,v1);
    elseif mesh1(3)==centerP
        v1(1:3) = Ver(mesh1(4),:)-Ver(mesh1(3),:);
        v2(1:3) = Ver(mesh1(2),:)-Ver(mesh1(3),:);
        v12 = cross(v1,v2);
    elseif mesh1(4)==centerP
        v1(1:3) = Ver(mesh1(1),:)-Ver(mesh1(4),:);
        v2(1:3) = Ver(mesh1(3),:)-Ver(mesh1(4),:);
        v12 = cross(v1,v2);
    else
        disp('wrong');
    end
end
V12_original(1,1:3) = NormalizeV(v12);

%%%calculate the other normals and then aveage
V12_original(2:size(meshNeighbour,1),1:3)=0;
for imesh = 2 : size(meshNeighbour,1)
     mesh1 = meshNeighbour(imesh,:);
      for i = 1 : length(mesh1)
            if mesh1(1) == centerP
                v1(1:3) = Ver(mesh1(2),:)-Ver(mesh1(1),:);
                v2(1:3) = Ver(mesh1(4),:)-Ver(mesh1(1),:);
                v12 = cross(v1,v2);
            elseif mesh1(2)==centerP
                v1(1:3) = Ver(mesh1(1),:)-Ver(mesh1(2),:);
                v2(1:3) = Ver(mesh1(3),:)-Ver(mesh1(2),:);
                v12 = cross(v2,v1);
            elseif mesh1(3)==centerP
                v1(1:3) = Ver(mesh1(4),:)-Ver(mesh1(3),:);
                v2(1:3) = Ver(mesh1(2),:)-Ver(mesh1(3),:);
                v12 = cross(v1,v2);
            elseif mesh1(4)==centerP
                v1(1:3) = Ver(mesh1(1),:)-Ver(mesh1(4),:);
                v2(1:3) = Ver(mesh1(3),:)-Ver(mesh1(4),:);
                v12 = cross(v1,v2);
            else
                disp('wrong');
            end
      end
      if dot(V12_original(1,:),v12)<=0
          V12_original(imesh,:) = -v12;
      end
end
n=[ mean(V12_original(:,1)),mean(V12_original(:,2)),mean(V12_original(:,3))];
n=NormalizeV(n);

 
function V=NormalizeV(V)
d=0;
for i = 1 : length(V)
    d=d+V(i)^2;
end
V = V./(d^0.5);

