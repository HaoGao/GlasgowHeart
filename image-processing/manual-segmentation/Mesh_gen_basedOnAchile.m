function Mesh_gen_basedOnAchile()

%%%whole lv manual segmentation configuration
if ispc
    path(path, '.\segmentation');
    path(path, '.\BSplineFitting');
    path(path, '.\meshRelated');
end

if ismac
    path(path, './segmentation');
    path(path, './BSplineFitting');
    path(path, './meshRelated');
end


% clear all; 
close all; clc;

workingDir = pwd();
resultDir = 'E:\HaoGao\owncloud\Shared\segmentations_mi\PCALVModelAnalysis_HG\Results\idealizedLV';

projectConfig_dir = resultDir; %%it is not to going to use it anyway
projectConfig_name = 'idealizedLV_config';


%%this is based on the paper from Gaussian Process regressions for inverse
%%problems and parameter searches in models of ventricular mechanics

%% 6 parameters 
%% Rb : the outer radius at the bas 
%% Z  : the length of longigtudinal semi-axis of the outer spheroid 
%% L  : wall thickness at base
%% H  : wall thickness at apex
%% e  : sphericity [0 1]
%% psi0 : the trancation angle

Rb = 3.0; %% cm
Z = 6.39; %% cm
L = 1; %% cm
H = 0.5; %% cm
e = 0.8; 
psi0 = -pi/8; %% this needs to be fixed because of our assumpsion in mesh generation

%%generating the boundary points
psi_max = pi/2; 
N_psi = 20;
psi_range = psi0: (psi_max - psi0)/N_psi: psi_max;

phi_max = 2*pi;
N_phi = 50;
phi_range = 0 : phi_max/N_phi: phi_max - phi_max/N_phi;


[points_epi, points_endo] = generating_surface(psi_range, phi_range,... 
                                             Rb, Z, L, H, e, psi0, ...
                                             psi_max, N_psi);
                                         
h3d = figure(); hold on;
x_endo = points_endo(:,1); 
y_endo = points_endo(:,2);
z_endo = points_endo(:,3);

x_epi = points_epi(:,1); 
y_epi = points_epi(:,2);
z_epi = points_epi(:,3);


plot3(x_endo, y_endo, z_endo, 'LineStyle', 'none', 'Marker', '.','MarkerEdgeColor', 'r' ); hold on;
plot3(x_epi, y_epi, z_epi, 'LineStyle', 'none', 'Marker', '.','MarkerEdgeColor', 'b' );
 

% %% need to think about how to do it properly
% %%generate a 3D matrix which can be used to compare the overlap 
N = 121;
pixel_reso = 1; %%mm each pixle is 1mm
% basal_centre = [61 61 121];
project_shape_matrix(N, psi_range, phi_range,... 
                                             Rb, Z, L, H, e, psi0, ...
                                             psi_max, N_psi,pixel_reso)

                                         
                                         
%% now need to output the coordinates for mesh generation 
%% GuidePointsGeneration(resultDir, points_epi, points_endo)


%% LV_EndoFitting(projectConfig_dir,projectConfig_name);
%% LV_EpiFitting(projectConfig_dir,projectConfig_name);
%% LV_WholeMesh(projectConfig_dir,projectConfig_name)
%

pause;

function [points_epi, points_endo] = generating_surface(psi_range, phi_range,... 
                                             Rb, Z, L, H, e, psi0, ...
                                             psi_max, N_psi)
 points_epi = [];
 points_endo = [];
 
%  if abs(psi0-0) > 1.0e-5
%      disp('psi0 is not zero, check');
%  end
     
 pindex = 0;
 for i = 1 : length(psi_range)
     
     psi = psi_range(i);
     psi_endo = asin(Z/(Z-H)*sin(psi)); %%to make sure the endo and epi the top plane has same z value
     %%skip several values near pi/2
     if abs(psi - psi_max)< 1.0e-6
         %%output one points
         phi = 0.0;
         rho_epi = Rb*(e*cos(psi) + (1-e)*(1-sin(psi))  );
         eta_epi = -Z*(sin(psi));
         
         rho_endo = (Rb - L)*( e*cos(psi_endo) + (1-e)*(1-sin(psi_endo) ) );
         eta_endo = -(Z-H)*(sin(psi_endo));
         
         p_epi = [rho_epi*cos(phi), rho_epi*sin(phi), eta_epi];
         p_endo = [rho_endo*cos(phi), rho_endo*sin(phi), eta_endo];
         
         pindex = pindex + 1;
         points_epi(pindex, :) = p_epi;
         points_endo(pindex, :) = p_endo;
      
     elseif i == N_psi-1 || i == N_psi-2 || i == N_psi-2 || i == N_psi-4
         continue; 
     else
        
             for j = 1 : length(phi_range)


                 phi = phi_range(j);
                 rho_epi = Rb*(e*cos(psi) + (1-e)*(1-sin(psi))  );
                 eta_epi = -Z*(sin(psi));

                 rho_endo = (Rb - L)*( e*cos(psi_endo) + (1-e)*(1-sin(psi_endo) ) );
                 eta_endo = -(Z-H)*(sin(psi_endo));

                 p_epi = [rho_epi*cos(phi), rho_epi*sin(phi), eta_epi];
                 p_endo = [rho_endo*cos(phi), rho_endo*sin(phi), eta_endo];

                 pindex = pindex + 1;
                 points_epi(pindex, :) = p_epi;
                 points_endo(pindex, :) = p_endo;

             end
         
     end
 end
 
 
 
 
function GuidePointsGeneration(resultDir, points_epi, points_endo)
        
workingDir = pwd();      
cd(resultDir);
fidinner = fopen('innerGuidePoints.dat','w');
fidouter = fopen('outerGuidePoints.dat','w');
cd(workingDir);

nubmerOfSlices = 1;
%%here we will assume only one slice, and the first point is the apex 
fprintf(fidinner, '%d\t number of slices \n', nubmerOfSlices);
fprintf(fidouter, '%d\t number of slices \n', nubmerOfSlices);

imIndex = 1;
fprintf(fidinner, '%d\t points on slice \t%d \n', size(points_endo,1) - 1, imIndex);
for pIndex = 1 : size(points_endo,1)-1
    fprintf(fidinner, '\t %f \t %f \t %f \n', points_endo(pIndex,1),points_endo(pIndex,2), points_endo(pIndex,3));
end

fprintf(fidouter, '%d\t points on slice \t%d \n', size(points_epi,1) - 1, imIndex);
for pIndex = 1 : size(points_epi,1)-1
    fprintf(fidouter, '\t %f \t %f \t %f \n', points_epi(pIndex,1),points_epi(pIndex,2), points_epi(pIndex,3));
end


fprintf(fidinner, '1\t This last point is inner apex point \n');
fprintf(fidinner, '\t %f \t%f \t%f \n', points_endo(end,1), points_endo(end,2), points_endo(end,3));

fprintf(fidouter, '1\t This last point is outer apex point \n');
fprintf(fidouter, '\t %f \t%f \t%f \n', points_epi(end,1), points_epi(end,2), points_epi(end,3));


fclose(fidinner);
fclose(fidouter);

 
 
 
function project_shape_matrix(N, basal_centre, psi_range, phi_range,... 
                                             Rb, Z, L, H, e, psi0, ...
                                             psi_max, N_psi, pixel_reso)
 LV_sym = zeros([N, N, N]);    
 
 
 
 
 
 for k = 1 : N
     z = k-N; %%z coordinate to the top basal plane;
     
     
     
     for j = 1 : N
         for i = 1 : N
             
             
         end
     end
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
