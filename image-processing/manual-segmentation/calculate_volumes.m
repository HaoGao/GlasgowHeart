% clear all; close all; clc;

% workingDir = pwd();
% [file,file_path] = uigetfile('.mat'); 


cd(resultDir);
load abaqusInputData;
cd(workingDir);

endoNodes = abaqusInputData.endoNodes; 
epiNodes = abaqusInputData.epiNodes;

node = abaqusInputData.node(:,1:3);

nodes_x = node(endoNodes,1);
nodes_y = node(endoNodes,2);
nodes_z = node(endoNodes,3);

DT =  DelaunayTri(nodes_x,nodes_y,nodes_z);
[~, vol_endo] = convexHull(DT)

nodes_x = node(epiNodes,1);
nodes_y = node(epiNodes,2);
nodes_z = node(epiNodes,3);
DT =  DelaunayTri(nodes_x,nodes_y,nodes_z);
[~, vol_epi] = convexHull(DT)

vol_LV_wall = vol_epi - vol_endo
