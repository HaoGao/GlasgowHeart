clear all; close all; clc;
workingDir = pwd();

EndoSurfaceNodes = [];
SubjecIndex = 0;



%%load the data
[sendo, sepi, ~] = load_LVGeoData('C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\PCALVModelAnalysis\Results\HV01\earlyDiastole', ...
                      workingDir);
SubjecIndex = SubjecIndex + 1;
EndoSurfaceNodes(SubjecIndex,:) = sendo;


[sendo, sepi, ~] = load_LVGeoData('C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\PCALVModelAnalysis\Results\HV02\earlyDiastole', ...
                      workingDir);
SubjecIndex = SubjecIndex + 1;
EndoSurfaceNodes(SubjecIndex,:) = sendo;

[sendo, sepi, abaqusInputData] = load_LVGeoData('C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\PCALVModelAnalysis\Results\HV03\earlyDiastole', ...
                      workingDir);
SubjecIndex = SubjecIndex + 1;
EndoSurfaceNodes(SubjecIndex,:) = sendo;



%%data load finished



%%calculate average shape
EndoSurfaceNodes_ave = mean(EndoSurfaceNodes);

%%minus the average shape from EndoSurfaceNodes
for row = 1 : size(EndoSurfaceNodes,1)
    for col = 1 : size(EndoSurfaceNodes,2)
        EndoSurfaceNodes_standardize(row, col) = EndoSurfaceNodes(row, col) -  EndoSurfaceNodes_ave(col);
    end
end

%%calculate the covariance matrix 
N = size(EndoSurfaceNodes,1);
C = EndoSurfaceNodes_standardize'*EndoSurfaceNodes_standardize;

%%that is coming from http://mghassem.mit.edu/pcasvd/
[u, d, v] = svd(C, 0);
% Pull out eigen values and vectors
eigVals = diag(d);
eigVecs = u;

%%the cumulative energy content for the m'th eigenvector is the sum of the
%%energy content across eigenvalues 1: m
for i = 1 : N
    energy(i) = sum(eigVals(1:i));
end
propEnergy = energy./energy(end);

%%determin the number of principal components required to model 90% of data
%%variance
% percentMark = min(find(propEnergy > 0.99));
percentMark = 1;
eigVecsSelected = u(:,1:percentMark);

%%we can calculate all the weights 
Nweights = (EndoSurfaceNodes_standardize)*eigVecsSelected;

%%next one we will need to output the mesh using tecplot
alpha0 = 7.04;
tecFid = fopen('mean_mesh.dat','w');
tectPlotFileGenerationForOneSurface(abaqusInputData,EndoSurfaceNodes_ave, alpha0,'endo', tecFid);
fclose(tecFid);

tecFid = fopen('ori_mesh.dat','w');
tectPlotFileGenerationForOneSurface(abaqusInputData,[], alpha0,'endo', tecFid);
fclose(tecFid);

%%let us reconstruct the endo face with percentMark eigen vectors
endoFaceSample = EndoSurfaceNodes(end,:);
endoFaceSample = endoFaceSample - EndoSurfaceNodes_ave;
faceWeight = eigVecsSelected'*(endoFaceSample');
mapped_endo = zeros(size(eigVecsSelected(:,1)));
for i = 1 : percentMark
      mapped_endo = mapped_endo-2*std(Nweights(:,1))*eigVecsSelected(:,i);
%      mapped_endo = mapped_endo+faceWeight(i).*eigVecsSelected(:,i);
end

tecFid = fopen('reconstructed_mesh.dat','w');
tectPlotFileGenerationForOneSurface(abaqusInputData,mapped_endo+EndoSurfaceNodes_ave', alpha0,'endo', tecFid);
fclose(tecFid);




figure;
subplot(231);
plot(Nweights(:,1),'.');
subplot(232);
plot(Nweights(:,2),'.');
subplot(233);
plot(Nweights(:,3),'.');
subplot(234);
plot(Nweights(:,4),'.');
subplot(235);
plot(Nweights(:,5),'.');

k = find(baseline_scan==1);
k2 = find(baseline_scan==0);


figure;
subplot(231);
plot(Nweights(k,1),'.'); hold on;plot(Nweights(k2,1),'r+'); hold on;
subplot(232);
plot(Nweights(k,2),'.'); hold on;plot(Nweights(k2,2),'r+'); hold on;
subplot(233);
plot(Nweights(k,3),'.'); hold on;plot(Nweights(k2,3),'r+'); hold on;
subplot(234);
plot(Nweights(k,4),'.'); hold on;plot(Nweights(k2,4),'r+'); hold on;
subplot(235);
plot(Nweights(k,5),'.'); hold on;plot(Nweights(k2,5),'r+'); hold on;



% % Do something with them; for example, project each of the neutral and smiling faces onto the corresponding eigenfaces
% neurtalFaces = faces(:, neutral); smileFaces = faces(:, smile);
% neutralWeights = eigenVecs' * neutralFaces;
% smileWeights = eigenVecs' * smileFaces;
% 
% % Use the coefficients of these projections to classify each smiling face
% for i = 1:numFaces
% weightDiff = repmat(smileWeights(:, i), 1, numFaces) - neutralWeights;
% [val, ind] = min(sum(abs(weightDiff), 1));
% bestMatch(i) = ind;
% end














