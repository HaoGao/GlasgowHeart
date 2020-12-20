% function SAManualSegmentationCorrection()
clear all; close all; clc;
resultDir = 'C:\Users\Hao_2\Google Drive\paper_writing\LV_material_parameters\bSplineStrainAnalysis\sampleResults\LVModelGeneration\MR-IMR-201-24hours';
workingDir = pwd();


cd(resultDir);
if exist('imDesired.mat', 'file')
    load imDesired;
    SXSlice = imDesired.SXSlice;
    clear imDesired;
else
    errordlg('imDesired has not been loaded properly, please check!');
end
cd(workingDir);

cd(resultDir);
if exist('DataSegSACardiacCycle.mat', 'file')
    load DataSegSACardiacCycle;
else
    errordlg('DataSegSACardiacCycle has not been loaded properly, please check!');
end
cd(workingDir);

totalSXSliceLocation = size(SXSlice,2);
TotalTimeInstance =  size(SXSlice(1,1).SXSlice, 1);
sampleN = 50;

TimeSelected = sprintf('%d', 15);
sliceNoToBeCorrected = sprintf('%d', 1);

prompt = {'select the time for segmentation','select the position'};
dlg_title = 'select the slice for correction';
num_lines = 1;
def = {TimeSelected,sliceNoToBeCorrected};
answer = inputdlg(prompt,dlg_title,num_lines,def);

TimeSelected = str2num(answer{1});
sliceNoToBeCorrected = str2num(answer{2});


%%%now work on the correction 
DataSegSA = DataSegSACardiacCycle(TimeSelected).DataSegSA;
upperSlice = sliceNoToBeCorrected-1;
lowerSlice = sliceNoToBeCorrected+1;

imData = SXSlice(1,sliceNoToBeCorrected).SXSlice(TimeSelected,1).imData;
imInfo1 = SXSlice(1,sliceNoToBeCorrected).SXSlice(TimeSelected,1).imInfo;
imInfo = infoExtract(imInfo1);

[imCropData rect] = imcrop(imData,[]); 

h1=figure();
imshow(imCropData,[]);hold on;

%%%current bc
endo_current = DataSegSA(sliceNoToBeCorrected).endo_c;
plot(endo_current(1,:)-rect(1), endo_current(2,:)-rect(2),'w-');

%%%correct for the endo part
if (lowerSlice>0 && lowerSlice<=totalSXSliceLocation)
    endo_lower = DataSegSA(lowerSlice).endo_c;
    plot(endo_lower(1,:)-rect(1),endo_lower(2,:)-rect(2),'b-.');
end

%%%correct for the endo part
if (upperSlice>0 && upperSlice<=totalSXSliceLocation)
    endo_upper = DataSegSA(upperSlice).endo_c;
    plot(endo_upper(1,:)-rect(1),endo_upper(2,:)-rect(2),'y-.');
end

endo_c=[];
epi_c=[];
endo_cc=[];
epi_cc=[];
endo_sample=[];
epi_sample=[];


but = 1;
n=1;
while but ==1 
            [x y but]=ginput(1);
            plot(x,y,'b.');hold on;
            endo_c(1,n)=x;
            endo_c(2,n)=y;
            n=n+1;
end
ni=[];nni=[];
ni=1:length(endo_c(1,:))+1;
nni=1:0.1:length(endo_c(1,:))+1;
endo_cc(1,:)=spline(ni,[endo_c(1,:) endo_c(1,1)], nni);
endo_cc(2,:)=spline(ni,[endo_c(2,:) endo_c(2,1)], nni);

[endo_sample, ~] = samplingBCWithoutIm(endo_cc, endo_cc,sampleN);
endo_sample(1,:) = endo_sample(1,:) +rect(1);
endo_sample(2,:) = endo_sample(2,:) +rect(2);
endo_cReal = TransformCurvesFromImToRealSpace(endo_sample,imInfo);

DataSegSA(sliceNoToBeCorrected).endo_c = endo_sample;
DataSegSA(sliceNoToBeCorrected).endo_cReal = endo_cReal;

%%%close all; correction for the epi part
msgbox('correction for epi boundary');
figure(h1); hold off;
imshow(imCropData,[]);hold on;
%%%correct for the epi part
if (lowerSlice>0 && lowerSlice<=totalSXSliceLocation)
    epi_lower = DataSegSA(lowerSlice).epi_c;
    plot(epi_lower(1,:)-rect(1),epi_lower(2,:)-rect(2),'b-.');
end

%%%correct for the epi part
if (upperSlice>0 && upperSlice<=totalSXSliceLocation)
    epi_upper = DataSegSA(upperSlice).epi_c;
    plot(epi_upper(1,:)-rect(1),epi_upper(2,:)-rect(2),'y-.');
end
plot(endo_c(1,:), endo_c(2,:),'r-');


n=1;but=1;
while but==1
            [x y but]=ginput(1);
            plot(x,y,'r.');hold on;
            epi_c(1,n)=x;
            epi_c(2,n)=y;
            n=n+1;
end
nei=[];nnei=[];
nei=1:length(epi_c(1,:))+1;
nnei=1:0.1:length(epi_c(1,:))+1;
epi_cc(1,:)=spline(nei,[epi_c(1,:) epi_c(1,1)], nnei);
epi_cc(2,:)=spline(nei,[epi_c(2,:) epi_c(2,1)], nnei);

[~, epi_sample] = samplingBCWithoutIm(endo_cc, epi_cc,sampleN);
epi_sample(1,:) = epi_sample(1,:) +rect(1);
epi_sample(2,:) = epi_sample(2,:) +rect(2);
epi_cReal = TransformCurvesFromImToRealSpace(epi_sample,imInfo);

DataSegSA(sliceNoToBeCorrected).epi_c = epi_sample;
DataSegSA(sliceNoToBeCorrected).epi_cReal = epi_cReal;


%%%update the database 
DataSegSACardiacCycle(TimeSelected).DataSegSA = DataSegSA;
cd(resultDir);
save DataSegSACardiacCycle DataSegSACardiacCycle;
cd(workingDir);







