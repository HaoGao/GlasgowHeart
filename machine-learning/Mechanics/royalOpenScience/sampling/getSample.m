clc,clear;
addpath('./lhs_sampling');
% Latin hypercube sampling from uniform distribution.
% Get 10000 samples.
samples = lhsu(ones(1,4)*0.1, ones(1,4)*5, 10000);
% save('sample.mat','sample')
xlswrite('samples.xlsx', samples)