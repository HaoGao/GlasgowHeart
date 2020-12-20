function [LAshorten, apical_twist]=long_axial_shortening_twist_calculation(dis)
%% as indicated by the function name
%% dis is the vector of the deformation

% global node_ori abaqusInputData sliceRegions options;

global options;

workingDir = pwd();

FiberGenerationDir = options.FiberGenerationDir;
abaqusDir = options.abaqusDir;
%strainData = options.strainData ;
abaqus_dis_out_filename = options.abaqus_dis_out_filename ;
abaqus_input_main_filename = options.abaqus_input_main_filename ;
pythonOriginalFilesDir = options.pythonOriginalFilesDir;
pythonfilename = options.pythonfilename;
lineNoForODBName = options.lineNoForODBName ;
lineNoForDisName = options.lineNoForDisName ;
%LVVolume = options.LVVolume ;
% sliceRegions = options.sliceRegions;
AHALVMeshDivision = options.AHALVMeshDivision;

%%%the orginal mesh file
cd(options.abaqusDir_pca);
load(options.abaqus_input_name); 
cd(workingDir);
%%%some updates to the abaqusInputData structure
node_ori = abaqusInputPCAReconstruction.node(:,1:3);
node_ori(:,1) = node_ori(:,1)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,2) = node_ori(:,2)*abaqusInputPCAReconstruction.scaleTomm;
node_ori(:,3) = node_ori(:,3)*abaqusInputPCAReconstruction.scaleTomm;

if isfield(abaqusInputPCAReconstruction, 'endoNodes')
  nodeIndex_endo = abaqusInputPCAReconstruction.endoNodes;
else
   disp('abaqusInputPCAReconstruction is not in the right formate');
end

node_def = node_ori + dis;


%%% here also we only consdier the endocardial surface
endoNodesList = abaqusInputPCAReconstruction.endoNodes;


%% find the index which will be used for calculating the long-axis, 
% most negative z, this is based on mesh format
endoNodes_ori = node_ori(endoNodesList,:);
endoNodes_def = node_def(endoNodesList,:);
endoNodes_ori_z = endoNodes_ori(:,3);
[~, indx] = sort(endoNodes_ori_z,'ascend');
nodeIndex_selected = indx(1:10); %% chosen the ten nodes
node_def_selected = endoNodes_def(nodeIndex_selected,:);
node_ori_selected = endoNodes_ori(nodeIndex_selected,:);
xapex_def = mean(node_def_selected(:,1));
yapex_def = mean(node_def_selected(:,2));
zapex_def = mean(node_def_selected(:,3));

xapex_ori = mean(node_ori_selected(:,1));
yapex_ori = mean(node_ori_selected(:,2));
zapex_ori = mean(node_ori_selected(:,3));

long_axis_def = (xapex_def^2 + yapex_def^2 + zapex_def^2)^0.5;
long_axis_ori = (xapex_ori^2 + yapex_ori^2 + zapex_ori^2)^0.5;
long_axis_shortening = (long_axis_ori - long_axis_def)/long_axis_def;
LAshorten.long_axis_end_diastole = long_axis_def;
LAshorten.long_axis_early_diastole = long_axis_ori;
LAshorten.long_axis_shortening = long_axis_shortening;

%%% now calculating the apical shortening, the averaged twist for the whole
%%% apical region within 10 mm
[min_z, ~] = min(endoNodes_ori_z);
indx_selected = [];
for i = 1 : length(endoNodes_ori_z)
   if endoNodes_ori_z(i) < min_z+10.0 && endoNodes_ori_z(i) > min_z +5
       indx_selected = [indx_selected, i];
   end
end

twist_angles = [];
for i = 1 : length(indx_selected)
    %% need to project to z plane
    x_def = endoNodes_def(indx_selected(i), 1);
    y_def = endoNodes_def(indx_selected(i), 2);
    
    x_ori = endoNodes_ori(indx_selected(i),1);
    y_ori = endoNodes_ori(indx_selected(i),2);
    
    %% check if either is less than 1mm, then no calculation
    l_def = (x_def^2 + y_def^2)^0.5;
    l_ori = (x_ori^2 + y_ori^2)^0.5;
    
    %% only calcualte certain degree
    if l_def > 1 && l_ori > 1
        cos_def_ori = (x_def*x_ori + y_def*y_ori)/(l_def*l_ori);
        angle_t = acos(cos_def_ori)*180/pi; %% in degree
        def_u = [x_def, y_def, 0];
        ori_u = [x_ori, y_ori, 0];
        def_ori_z = cross(def_u, ori_u);
        ori_z = [0 0 1];
        if dot(def_ori_z, ori_z)>=0
            angle_t = -angle_t;
        end
        
        twist_angles = [twist_angles; angle_t];
        
    end
    
end
apical_twist.twist_angles = twist_angles;
apical_twist.apical_twist_angle = mean(twist_angles);







