%%%this is used to divide LV into different regions
clear all; 
close all; 
clc;

% LVWM_config;%%%Hao yu jue
LVWM_config;
cd(resultDir);
load AHADefinition;
load abaqusInputData;
load XYZEndoFitted;
cd(workingDir);

totalSASlices = length(basalSlices) + length(middlSlices) + length(apicaSlices);
slices_with_6regions = [basalSlices middlSlices];
slices_with_4regions = apicaSlices;

for i = 1 : totalSASlices
   u_slices(i) = mean(XYZEndoFitted(1,i).u); %%this is in radian, from 0 to -pi/2
end

%%now setup the degree boundary for each slices 
for i = 1 : totalSASlices
   if i == 1
       u_up = u_slices(i);
       u_bo = (u_slices(i+1)+u_slices(i))/2;
       u_slices_bc(i,:)=[u_up u_bo]*180/pi;
   elseif i==totalSASlices
       u_up = (u_slices(i)+u_slices(i-1))/2;
       u_bo = u_slices(i) + (u_slices(i)-u_slices(i-1))/2; 
       u_slices_bc(i,:)=[u_up u_bo]*180/pi;
   else
       u_up = (u_slices(i)+u_slices(i-1))/2;
       u_bo = (u_slices(i+1)+u_slices(i))/2;
       u_slices_bc(i,:)=[u_up u_bo]*180/pi;
   end
    
end

%%%first we will need to divide each node into different slices
node=abaqusInputData.node;
for ni = 1 : size(node,1)
    slice_index_node = 0;
    u_node = node(ni,4);%%in degree
    for sliceIndex = 1 : totalSASlices
        u_up = u_slices_bc(sliceIndex,1);
        u_bo = u_slices_bc(sliceIndex,2);
        if u_node > u_bo && u_node <= u_up
            slice_index_node = sliceIndex;
            break;
        end
    end
    slice_No_assigned_Node(ni,1) = slice_index_node;
end

%%now we know the node associating with which plane, then we can assign the
%%regions
for ni = 1 : size(node,1)
   sliceIndex = slice_No_assigned_Node(ni,1);
   k6 = find(slices_with_6regions==sliceIndex);
   k4 = find(slices_with_4regions==sliceIndex);
   theta = node(ni,5);%%in degree the circumferential degree
   if ~isempty(k6) %%6 region definition
       AHAMidConfig = BaseMidConfig(1,k6);
       regionValue = assignSegAccordingToThetaForMiddleRegion(theta,AHAMidConfig);
       segRegions(ni,1)=regionValue;
   end
   if~isempty(k4) %%4 region definition
      AHAApexConfig = ApexConfig(1,k4); 
      regionValue = assignSegAccordingToThetaForApexRegion(theta,AHAApexConfig);
      segRegions(ni,1)=regionValue;
   end
   if isempty(k6) && isempty(k4)
       regionValue = 0;
       segRegions(ni,1)=regionValue;
   end   
end

%%output for check
cd(resultDir);
load rotationConfig;
cd(workingDir);

nodeMat  = abaqusInputData.node;
elemMat = abaqusInputData.elem;
NodeMat(:,2) = nodeMat(:,1)*abaqusInputData.scaleTomm;
NodeMat(:,3) = nodeMat(:,2)*abaqusInputData.scaleTomm;
NodeMat(:,4) = nodeMat(:,3)*abaqusInputData.scaleTomm;
uvw = nodeMat(:,4:6);
nodeMatMRI = rotationBackToMRICoordinateSystemt(NodeMat,resultDir);

cd(resultDir);
fid = fopen('LVMesh_AHADefinition.dat','w');
cd(workingDir);
uvw(:,1) = slice_No_assigned_Node;
uvw(:,2) = segRegions;
uvw(:,3) = 0;
TecplotHexMeshVec(nodeMatMRI, elemMat,uvw,fid);%ouput the v degree from the fitting
fclose(fid);


%%%now we figure out the node id sequence for each region using AHA17
%%%definition
basa_InfSept=[];basa_AntSept=[];basa_Ant=[];base_AntLat=[];base_InfLat=[];base_Inf=[];
midd_InfSept=[];midd_AntSept=[];midd_Ant=[];midd_AntLat=[];midd_InfLat=[];midd_Inf=[];
apex_Sept=[];apex_Ant=[];apex_Lat=[];apex_Inf=[];
apicalRegion = [];
for ni = 1 : size(node,1)
   sliceIndex = slice_No_assigned_Node(ni,1);
   k_base = find(basalSlices==sliceIndex);
   k_mid = find(middlSlices==sliceIndex);
   k_apex = find(apicaSlices==sliceIndex);
   regionValue = segRegions(ni,1);
   
   if ~isempty(k_base)
       if regionValue == 1
           basa_InfSept = [basa_InfSept; ni];
       elseif regionValue == 2
           basa_AntSept = [basa_AntSept; ni];
       elseif regionValue == 3
           basa_Ant = [basa_Ant; ni];
       elseif regionValue == 4
           base_AntLat = [base_AntLat; ni];
       elseif regionValue == 5
           base_InfLat = [base_InfLat; ni];
       elseif regionValue == 6
            base_Inf = [base_Inf; ni];
       end   
   end %%k_base
   
   if ~isempty(k_mid)
       if regionValue == 1
           midd_InfSept = [midd_InfSept; ni];
       elseif regionValue == 2
           midd_AntSept = [midd_AntSept; ni];
       elseif regionValue == 3
           midd_Ant = [midd_Ant; ni];
       elseif regionValue == 4
           midd_AntLat = [midd_AntLat; ni];
       elseif regionValue == 5
           midd_InfLat = [midd_InfLat; ni];
       elseif regionValue == 6
            midd_Inf = [midd_Inf; ni];
       end   
   end %%k_base
   
   if ~isempty(k_apex)
       if regionValue == 1
           apex_Sept = [apex_Sept; ni];
       elseif regionValue == 3
           apex_Ant = [apex_Ant; ni];
       elseif regionValue == 4
           apex_Lat = [apex_Lat; ni];
       elseif regionValue == 6
           apex_Inf = [apex_Inf; ni];
       end
   end%%k_apex
   
   if regionValue == 0
       apicalRegion = [apicalRegion; ni];
   end
   
end

AHALVMeshDivision.basa_InfSept = basa_InfSept;
AHALVMeshDivision.basa_AntSept = basa_AntSept;
AHALVMeshDivision.basa_Ant     = basa_Ant;
AHALVMeshDivision.base_AntLat  = base_AntLat;
AHALVMeshDivision.base_InfLat  = base_InfLat;
AHALVMeshDivision.base_Inf     = base_Inf;

AHALVMeshDivision.midd_InfSept = midd_InfSept;
AHALVMeshDivision.midd_AntSept = midd_AntSept;
AHALVMeshDivision.midd_Ant     = midd_Ant;
AHALVMeshDivision.midd_AntLat  = midd_AntLat;
AHALVMeshDivision.midd_InfLat  = midd_InfLat;
AHALVMeshDivision.midd_Inf     = midd_Inf;

AHALVMeshDivision.apex_Sept = apex_Sept;
AHALVMeshDivision.apex_Ant = apex_Ant;
AHALVMeshDivision.apex_Lat = apex_Lat;
AHALVMeshDivision.apex_Inf = apex_Inf;

AHALVMeshDivision.apicalRegion = apicalRegion;



%%for element
%%%now we figure out the elem id sequence for each region using AHA17
%%%definition
elem = abaqusInputData.elem;
elem_basa_InfSept=[];elem_basa_AntSept=[];elem_basa_Ant=[];elem_base_AntLat=[];elem_base_InfLat=[];elem_base_Inf=[];
elem_midd_InfSept=[];elem_midd_AntSept=[];elem_midd_Ant=[];elem_midd_AntLat=[];elem_midd_InfLat=[];elem_midd_Inf=[];
elem_apex_Sept=[];elem_apex_Ant=[];elem_apex_Lat=[];elem_apex_Inf=[];
elem_apicalRegion = [];
for eli = 1 : size(elem,1)
   el_nodes_ID = elem(eli,:);
   sliceIndex_nodes = slice_No_assigned_Node(el_nodes_ID,1);
   sliceIndex = round(mean(sliceIndex_nodes));
   k_base = find(basalSlices==sliceIndex);
   k_mid = find(middlSlices==sliceIndex);
   k_apex = find(apicaSlices==sliceIndex);
   
   regionValue_nodes = segRegions(el_nodes_ID,1);
   regionValue = (mean(regionValue_nodes));
   
   if ~isempty(k_base)
       if regionValue < 1.5
           elem_basa_InfSept = [elem_basa_InfSept; eli];
       elseif regionValue >=1.5 && regionValue<2.5 
           elem_basa_AntSept = [elem_basa_AntSept; eli];
       elseif regionValue >=2.5 && regionValue < 3.5
           elem_basa_Ant = [elem_basa_Ant; eli];
       elseif regionValue >=3.5 && regionValue < 4.5
           elem_base_AntLat = [elem_base_AntLat; eli];
       elseif regionValue >=4.5 && regionValue <5.5
           elem_base_InfLat = [elem_base_InfLat; eli];
       elseif regionValue >=5.5 && regionValue <=6.5
            elem_base_Inf = [elem_base_Inf; eli];
       end   
   end %%k_base
   
   if ~isempty(k_mid)
       if regionValue  < 1.5
           elem_midd_InfSept = [elem_midd_InfSept; eli];
       elseif regionValue >=1.5 && regionValue<2.5 
           elem_midd_AntSept = [elem_midd_AntSept; eli];
       elseif regionValue >=2.5 && regionValue < 3.5
           elem_midd_Ant = [elem_midd_Ant; eli];
       elseif regionValue >=3.5 && regionValue < 4.5
           elem_midd_AntLat = [elem_midd_AntLat; eli];
       elseif regionValue >=4.5 && regionValue <5.5
           elem_midd_InfLat = [elem_midd_InfLat; eli];
       elseif regionValue >=5.5 && regionValue <=6.5
            elem_midd_Inf = [elem_midd_Inf; eli];
       end   
   end %%k_base
   
   if ~isempty(k_apex)
       if regionValue < 2 
           elem_apex_Sept = [elem_apex_Sept; eli];
       elseif regionValue >=2 && regionValue <3.5
           elem_apex_Ant = [elem_apex_Ant; eli];
       elseif regionValue >=3.5 && regionValue < 5
           elem_apex_Lat = [elem_apex_Lat; eli];
       elseif regionValue >= 5 && regionValue < 6.5
           elem_apex_Inf = [elem_apex_Inf; eli];
       end
   end%%k_apex
   
   if regionValue == 0
       elem_apicalRegion = [elem_apicalRegion; eli];
   end
   
end

AHALVMeshDivision.basa_InfSept = basa_InfSept;
AHALVMeshDivision.basa_AntSept = basa_AntSept;
AHALVMeshDivision.basa_Ant     = basa_Ant;
AHALVMeshDivision.base_AntLat  = base_AntLat;
AHALVMeshDivision.base_InfLat  = base_InfLat;
AHALVMeshDivision.base_Inf     = base_Inf;

AHALVMeshDivision.midd_InfSept = midd_InfSept;
AHALVMeshDivision.midd_AntSept = midd_AntSept;
AHALVMeshDivision.midd_Ant     = midd_Ant;
AHALVMeshDivision.midd_AntLat  = midd_AntLat;
AHALVMeshDivision.midd_InfLat  = midd_InfLat;
AHALVMeshDivision.midd_Inf     = midd_Inf;

AHALVMeshDivision.apex_Sept = apex_Sept;
AHALVMeshDivision.apex_Ant = apex_Ant;
AHALVMeshDivision.apex_Lat = apex_Lat;
AHALVMeshDivision.apex_Inf = apex_Inf;

AHALVMeshDivision.apicalRegion = apicalRegion;

%%for element based 
AHALVMeshDivision.elem_basa_InfSept = elem_basa_InfSept;
AHALVMeshDivision.elem_basa_AntSept = elem_basa_AntSept;
AHALVMeshDivision.elem_basa_Ant     = elem_basa_Ant;
AHALVMeshDivision.elem_base_AntLat  = elem_base_AntLat;
AHALVMeshDivision.elem_base_InfLat  = elem_base_InfLat;
AHALVMeshDivision.elem_base_Inf     = elem_base_Inf;

AHALVMeshDivision.elem_midd_InfSept = elem_midd_InfSept;
AHALVMeshDivision.elem_midd_AntSept = elem_midd_AntSept;
AHALVMeshDivision.elem_midd_Ant     = elem_midd_Ant;
AHALVMeshDivision.elem_midd_AntLat  = elem_midd_AntLat;
AHALVMeshDivision.elem_midd_InfLat  = elem_midd_InfLat;
AHALVMeshDivision.elem_midd_Inf     = elem_midd_Inf;

AHALVMeshDivision.elem_apex_Sept = elem_apex_Sept;
AHALVMeshDivision.elem_apex_Ant = elem_apex_Ant;
AHALVMeshDivision.elem_apex_Lat = elem_apex_Lat;
AHALVMeshDivision.elem_apex_Inf = elem_apex_Inf;

AHALVMeshDivision.elem_apicalRegion = elem_apicalRegion;








AHALVMeshDivision.segRegions = segRegions;
AHALVMeshDivision.slice_No_assigned_Node = slice_No_assigned_Node;


cd(resultDir);
save AHALVMeshDivision AHALVMeshDivision;
cd(workingDir);





