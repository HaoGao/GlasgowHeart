function nodeMatMRI = rotationBackToMRICoordinateSystemt(nodeMat,resultDir)

workingDir = pwd();
cd(resultDir);
load rotationConfig;
cd(workingDir);

%%%LVUpperCenter LVApexCenter RotationMatrix
RotationMatrixBack = inv(RotationMatrix);
nodeT(1,:)=nodeMat(:,2)';
nodeT(2,:)=nodeMat(:,3)';
nodeT(3,:)=nodeMat(:,4)';

nodeTR = RotationMatrixBack*nodeT;

nodeTR(1,:) = nodeTR(1,:)+ LVUpperCenter(1);
nodeTR(2,:) = nodeTR(2,:)+ LVUpperCenter(2);
nodeTR(3,:) = nodeTR(3,:)+ LVUpperCenter(3);

nodeMatMRI(:,1) = nodeMat(:,1);
nodeMatMRI(:,2) = nodeTR(1,:)';
nodeMatMRI(:,3) = nodeTR(2,:)';
nodeMatMRI(:,4) = nodeTR(3,:)';
