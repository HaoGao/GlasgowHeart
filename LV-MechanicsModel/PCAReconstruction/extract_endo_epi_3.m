function [sendo, sepi] = extract_endo_epi_3(abaqusInputData)

node = abaqusInputData.node;
%%%%%%%% node has entries
sendo = reshape(node(abaqusInputData.endoNodes,1:3)',1,numel(node(abaqusInputData.endoNodes,1:3)));
sepi =  reshape(node(abaqusInputData.epiNodes,1:3)',1,numel(node(abaqusInputData.epiNodes,1:3)));  