function LVMeshDivisionAHA(resultDir,MidConfig, ApexConfig, SASlicePositionApex, SASliceDistance,usuableSXSlice)
%%%
workingDir = pwd();
cd(resultDir);
load DivisionConfig;
load abaqusInputData;
cd(workingDir);

nodeMat = abaqusInputData.node;
elemMat = abaqusInputData.elem;

nodeMatT = nodeMat(:,1:3);
clear nodeMat;
nodeMat(:,2:4) = nodeMatT;
clear nodeMatT;
nodeMat(:,2) = nodeMat(:,2)*abaqusInputData.scaleTomm;
nodeMat(:,3) = nodeMat(:,3)*abaqusInputData.scaleTomm;
nodeMat(:,4) = nodeMat(:,4)*abaqusInputData.scaleTomm;

elemT(:,2:9) = elemMat;
clear eleMat;
elemMat = elemT;

%%%the first slice location will be from zMax to zMax-5;
%%%the next slice location will be from (sliceLocation-1)*10-5 to (sliceLocation-1)*10+5
%%%the cener point always will be (0 0)
%%%also provides another way for define the regions with less than 10mm
%%%thickness in order to compare with b-spline recovered strain
sliceThkRatio = 4;
for sliceIndex = 1 : SASlicePositionApex-1
    if sliceIndex == 1
        zUpper = SASliceDistance/2;
        zLower = -SASliceDistance/2;
        zUpperSlice = SASliceDistance/sliceThkRatio;
        zLowerSlice = -SASliceDistance/sliceThkRatio;
    else
        zUpper = -(sliceIndex-1)*SASliceDistance + SASliceDistance/2;
        zLower = -(sliceIndex-1)*SASliceDistance - SASliceDistance/2;
        zUpperSlice = -(sliceIndex-1)*SASliceDistance + SASliceDistance/sliceThkRatio;
        zLowerSlice = -(sliceIndex-1)*SASliceDistance - SASliceDistance/sliceThkRatio;
    end
    centerPoint = [0 0];
    segRegions = MiddleSliceDivision(nodeMat,zUpper,zLower,centerPoint, MidConfig);
    segRegionsSlicesPlane = MiddleSliceDivision(nodeMat,zUpperSlice,zLowerSlice,centerPoint, MidConfig);
    sliceRegions(sliceIndex).segRegions = segRegions;
    sliceRegions(sliceIndex).segRegionsSlicesPlane = segRegionsSlicesPlane;
    %%%this is for regions just in the slice with 5 mm thickness
    
end

%%%this is for apex region
for sliceIndex = SASlicePositionApex : usuableSXSlice
    zUpper = -(sliceIndex-1)*SASliceDistance + SASliceDistance/2;
    zLower = -(sliceIndex-1)*SASliceDistance - SASliceDistance/2;
    zUpperSlice = -(sliceIndex-1)*SASliceDistance + SASliceDistance/sliceThkRatio;
    zLowerSlice = -(sliceIndex-1)*SASliceDistance - SASliceDistance/sliceThkRatio;
    centerPoint = [0 0];
    segRegions = ApexSliceDivision(nodeMat,zUpper,zLower,centerPoint, ApexConfig);
    segRegionsSlicesPlane = ApexSliceDivision(nodeMat,zUpperSlice,zLowerSlice,centerPoint, ApexConfig);
    sliceRegions(sliceIndex).segRegions = segRegions;
    sliceRegions(sliceIndex).segRegionsSlicesPlane = segRegionsSlicesPlane;
end

%%%for apex point
segRegions = zeros([1 size(nodeMat,1)]);
for nodeIndex = 1 : size(nodeMat,1)
    if nodeMat(nodeIndex,4)<zLower
        segRegions(nodeIndex)=7;
        segRegionsSlicesPlane(nodeIndex) = 7;
    end
end
sliceRegions(usuableSXSlice+1).segRegions = segRegions;
sliceRegions(usuableSXSlice+1).segRegionsSlicesPlane = segRegionsSlicesPlane;

%%%now combine segRegions
segRegions = zeros([1 size(nodeMat,1)]);
segRegionsSlicesPlane = zeros([1 size(nodeMat,1)]);
for sliceIndex = 1 : usuableSXSlice+ 1
    segRegionsT = sliceRegions(sliceIndex).segRegions;
    segRegionsSlicesPlaneT = sliceRegions(sliceIndex).segRegionsSlicesPlane;
    for nodeIndex = 1 : length(segRegionsT)
        if segRegionsT(nodeIndex)>0
            segRegions(nodeIndex) = segRegionsT(nodeIndex);
        end
        if segRegionsSlicesPlaneT(nodeIndex)>0
            segRegionsSlicesPlane(nodeIndex) = segRegionsSlicesPlaneT(nodeIndex);
        end
        
    end    
end

cd(resultDir)
save LVMeshSegDivisions sliceRegions segRegions segRegionsSlicesPlane;
cd(workingDir);

%%%output the regions
cd(resultDir)
fid_regions = fopen('sliceSegments.dat','w');
cd(workingDir);
TecplotMeshRegionsHex(nodeMat, elemMat, segRegions,fid_regions);
fclose(fid_regions);


%%%need to plot with images to make sure they are right
%%rotate the nodeMatrx to the MRI coordinate system
nodeMatMRI = rotationBackToMRICoordinateSystemt(nodeMat,resultDir, workingDir);
cd(resultDir)
fid_regions = fopen('sliceSegments_MRICoor.dat','w');
cd(workingDir);
TecplotMeshRegionsHex(nodeMatMRI, elemMat, segRegionsSlicesPlane,fid_regions);
fclose(fid_regions);


% %%%now need to get the 3D dicom image
% cd(resultDir);
% load imDesired;
% cd(workingDir);
% %%one middle short axis
% %one short aixs
% imFileName = SXSliceSorted(3).Time(timeInstanceSelectedDiastile).name;
% imFileName = sprintf('%s/%s',dicomDir,imFileName);
% imDataSA = MRIMapToReal(imFileName);








