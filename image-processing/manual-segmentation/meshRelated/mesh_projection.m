clear all; close all; clc

workingDir = pwd();
result_dir = '../MI_Models/MR-IMR-71-bsl-23-9-11/earlyDiastole';

ID_label_myocardium = 1;
ID_label_cavity = 2;

cd(result_dir);
load abaqusInputData;
cd(workingDir);

node = abaqusInputData.node;
elem = abaqusInputData.elem;

NElem = size(elem, 1);

ConnectivityList = zeros([NElem*10, 4]);
el = 0;
for elemIndex = 1 : NElem
    elem_T = elem(elemIndex,:);
    node_x = node(elem_T,1);
    node_y = node(elem_T,2);
    node_z = node(elem_T,3);
    %if elemIndex == 1
        DTT = delaunayTriangulation(node_x, node_y, node_z);
        CT = DTT.ConnectivityList;
    %end
    %%DT.points, DT.ConnectivityList
    
    for i = 1 : size(CT,1)
        el = el + 1;
        ConnectivityList(el,:) = [ elem_T(CT(i,1)), elem_T(CT(i,2)), ...
                            elem_T(CT(i,3)), elem_T(CT(i,4))];
    end
    
    
end

 ConnectivityList = ConnectivityList(1:el,:);
% 
%  h = figure; 
 TR = triangulation(ConnectivityList, node(:,1), node(:,2), node(:,3));
%  tetramesh(TR);

%% use function to check whether a point is in a triangulatoin pointLocation
%% ID contains NaN values for points that are not located in a triangle or 
%% tetrahedron of the triangulation.
%% . ID = pointLocation(TR,x,y,z)


%%here we will creat a 101x101x100 cm matrix,
KMax = 100; IMax = 101; JMax = 101;
PixelResolution = 0.1;%%cm
ImgMatrix= zeros([IMax JMax KMax]);


I_centre = (IMax-1)/2;
J_centre = (JMax-1)/2;
K_top = KMax;

%% the centre of the top plane is (I_centre, J_centre, K_top) is the 
%% physical original
%% point (0,0,0), each voxel has a dimension PixelResolution cm x
%% PixelResolution cm x PixelResolution cm

mesh_x_min = min(node(:,1));
mesh_x_max = max(node(:,1));

mesh_y_min = min(node(:,2));
mesh_y_max = max(node(:,2));

mesh_z_min = min(node(:,3));
mesh_z_max = max(node(:,3));

gridCoor = zeros([IMax*JMax*KMax, 3]);
gridIndex = 0;
for k = 1 : KMax
    for j = 1 : JMax
        for i = 1 : IMax
           
           icoor = (i-I_centre)*PixelResolution;
           jcoor = (j-J_centre)*PixelResolution;
           kcoor = (k-KMax)*PixelResolution;
           if (   icoor >= mesh_x_min && icoor <= mesh_x_max ...
               && jcoor >= mesh_y_min && jcoor <= mesh_y_max ...
               && kcoor >= mesh_z_min && kcoor <= mesh_z_max)
           
               gridIndex = gridIndex + 1;
               gridCoor(gridIndex, 1:3) = ...
                   [ (i-I_centre)*PixelResolution, ... 
                   (j-J_centre)*PixelResolution, ...
                   (k-KMax)*PixelResolution];
           end   
           
        end
    end  
end
gridCoor = gridCoor(1:gridIndex,:);

%%now we can detect whether a point is in the mesh 
[ID_detected, barCentre]= pointLocation(TR,gridCoor);

%%now we can assing value to ImgMatrix according to ID_detected, for
%%ventricular wall
for idIndex = 1 : length(ID_detected)
    
     if ~isnan(ID_detected(idIndex))
           icoor = gridCoor(idIndex,1);
           jcoor = gridCoor(idIndex,2);
           kcoor = gridCoor(idIndex,3);
           
           i = floor(icoor/PixelResolution+I_centre);
           j = floor(jcoor/PixelResolution+J_centre);
           k = floor(kcoor/PixelResolution+KMax);
           
           ImgMatrix(i, j, k) = ID_label_myocardium;
           
           i = ceil(icoor/PixelResolution+I_centre);
           j = ceil(jcoor/PixelResolution+J_centre);
           k = ceil(kcoor/PixelResolution+KMax);
           ImgMatrix(i, j, k) = ID_label_myocardium;
                
     end
end



%% now detect the cavity region 
endoNodes = (abaqusInputData.endoNodes)';
%% construct a node coord to include all endo node
coor_endo = node(endoNodes, 1:3);
%% adding the centre one in 
coor_endo = [coor_endo; 0, 0 , 0];
%% triangualtion 
DT_endo = delaunayTriangulation(coor_endo(:,1), coor_endo(:,2) ,coor_endo(:,3));

[ID_detected_endo, barCentre_endo]= pointLocation(DT_endo,gridCoor);

for idIndex = 1 : length(ID_detected_endo)
    
     if ~isnan(ID_detected_endo(idIndex))
           icoor = gridCoor(idIndex,1);
           jcoor = gridCoor(idIndex,2);
           kcoor = gridCoor(idIndex,3);
           
           i = floor(icoor/PixelResolution+I_centre);
           j = floor(jcoor/PixelResolution+J_centre);
           k = floor(kcoor/PixelResolution+KMax);
           
           if ImgMatrix(i, j, k) ~= ID_label_myocardium
                ImgMatrix(i, j, k) = ID_label_cavity;
           end
           
           i = ceil(icoor/PixelResolution+I_centre);
           j = ceil(jcoor/PixelResolution+J_centre);
           k = ceil(kcoor/PixelResolution+KMax);
           if ImgMatrix(i, j, k) ~= ID_label_myocardium 
                ImgMatrix(i, j, k) = ID_label_cavity;
           end
                
     end
end

volumeViewer(ImgMatrix);
% [f,v] = isosurface(ImgMatrix,0.9);
% patch('Faces',f,'Vertices',v)
            
save ImgMatrix ImgMatrix;

