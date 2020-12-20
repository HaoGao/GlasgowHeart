function LVWM_LASegManual(imSelected,projectConfig_dir,projectConfig_name)

%%%SA segmentation
close all; 
clc;
workingDir = pwd();

% LVWM_config;
if ~exist('imSelected', 'var')
    LVWM_config;
    list = {'1', '2', '3'};
    [imSelected, ~] = listdlg('ListString', list, 'SelectionMode', 'single',...
    'ListSize', [80,50], 'InitialValue',1);
else
    cd(projectConfig_dir);
    run(projectConfig_name);
    cd(workingDir);
end


segB = 1;

fresh_seg = 0;
cd(resultDir);
load imDesired;
if ~exist('DataSegLA.mat', 'file') 
    disp('create a new database for segmentation results');
    fresh_seg = 1;
else
    fresh_sge = 0;
    load DataSegLA;
    disp('use existed database for segmentation results');
end
cd(workingDir);




totalSXSliceLocation = size(SXSliceSorted,2);
timeInstanceSelected = patientConfigs.timeInstanceSelected;
sampleN = patientConfigs.sampleN;
totalLASliceLocation = size(LVOTSliceSorted,2);


    

% imSelected=3; %%normally there is only 3 slices to seg


    %%%now only consider one slice per position, usually the first one
    if segB == 1
       %%%initialize 
       if fresh_seg
            for imIndex = 1 : totalLASliceLocation
                data.rect = [];
                data.endo_c = [];
                data.epi_c = [];
                DataSegLA(imIndex)=data; %this will save the long-axis data
            end
            clear data;
       end


        %%%then do the segmentation 
        for imIndex = imSelected : imSelected
            imData =  LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imData;
            imInfo1 = LVOTSliceSorted(1,imIndex).LXSlice(timeInstanceSelected).imInfo;
            imInfo = infoExtract(imInfo1);
            DataSeg = LAManualSegFunction(imData, imInfo, ...
                resultDir, workingDir, imIndex);


            DataSegLA(imIndex).endo_c = DataSeg.endo_c;
            DataSegLA(imIndex).epi_c = DataSeg.epi_c;
            DataSegLA(imIndex).endo_cReal = DataSeg.endo_cReal;
            DataSegLA(imIndex).epi_cReal = DataSeg.epi_cReal ;




        end
        cd(resultDir);
        save DataSegLA DataSegLA;
        save DataSegLAOri DataSegLA;
        cd(workingDir); 

    else
        cd(resultDir);
        load DataSegLA;
        cd(workingDir);    
    end
    


%%%to show the boundaries in 3D with short axis views
imData = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imData;
imInfo1 = SXSliceSorted(1,4).SXSlice(timeInstanceSelected).imInfo;
imInfo = infoExtract(imInfo1);
imData = MRIMapToRealWithImageAndHeadData(imData, imInfo);

scrSize = get(0,'ScreenSize');
h3D = figure('Position', scrSize/2); hold on;
DicomeRealDisplay(h3D, imData);

for imIndex = 1 : totalLASliceLocation
% for imIndex = 3:3
    endo_c = DataSegLA(imIndex).endo_cReal;
    epi_c = DataSegLA(imIndex).epi_cReal;
    %%%%plot 3D curves
    if ~isempty(endo_c) && ~isempty(epi_c)
        plot3(endo_c(1,:),endo_c(2,:), endo_c(3,:),'LineStyle', '-', 'Color', 'b', 'LineWidth',2);
        plot3(epi_c(1,:),epi_c(2,:), epi_c(3,:),'LineStyle', '-', 'Color', 'r', 'LineWidth',2);
    end
end


cd (resultDir);
if ~exist('LAslice3Tec.dat', 'file')
    cd(workingDir);
    imgTecplotOutput(imData,'LAslice3Tec.dat',resultDir);
end
cd(workingDir);

%%%this is for apex info





    

function DataSegSA = LAManualSegFunction(imData, imInfo, ... 
                     resultDir, workingDir, imIndex)
%     imData = Slice(TimeInstanceSelected,1).imData;
%     imInfo1 = Slice(TimeInstanceSelected,1).imInfo;
%     imInfo = infoExtract(imInfo1);
        disp('.............................................');
        disp('drag a rect region for defining region of interest');    
        [imCropData, rect] = imcrop(imData,[]);

%         h1=figure();
%         imshow(imCropData,[]);hold on;
        %%double press space key (acutally any key) to return from defineBoundaryByimpoint
        disp('.............................................');
        disp('define points in the boundary by click points')
        disp('press stop, then click the last point');
        disp('press replot to generate the curve');
        disp('whenever change the point position, using replot to regenerate the curve');
        disp('double press space key to return from boudnary definition');
        [xycoor, hpts_endo]=defineBoundaryByimpoint(imCropData,[], 0);

        endo_c=[];
        epi_c=[];
        endo_cc=[];
        epi_cc=[];
        endo_sample=[];
        epi_sample=[];

        endo_c = xycoor;
        ni=[];nni=[];
        ni=1:length(endo_c(1,:));
        nni=1:0.5:length(endo_c(1,:));
        endo_cc(1,:)=spline(ni,endo_c(1,:) , nni);
        endo_cc(2,:)=spline(ni,endo_c(2,:) , nni);

        disp('.............................................');
        disp('predefined boundaries are plotted in red');
        disp('define points in the boundary by click points')
        disp('press stop, then click the last point');
        disp('press replot to generate the curve');
        disp('whenever change the point position, using replot to regenerate the curve');
        disp('double press space key to return from boudnary definition');
        [xycoor, hpts_epi]=defineBoundaryByimpoint(imCropData,endo_cc, 0);
        epi_c = xycoor;
        nei=[];nnei=[];
        nei=1:length(epi_c(1,:));
        nnei=1:0.5:length(epi_c(1,:));
        epi_cc(1,:)=spline(nei,epi_c(1,:), nnei);
        epi_cc(2,:)=spline(nei,epi_c(2,:) , nnei);

%         [endo_sample, epi_sample] = samplingBCWithoutIm(endo_cc, epi_cc,sampleN);

        endo_sample(1,:) = endo_cc(1,:) +rect(1);
        endo_sample(2,:) = endo_cc(2,:) +rect(2);
        epi_sample(1,:) = epi_cc(1,:) +rect(1);
        epi_sample(2,:) = epi_cc(2,:) +rect(2);

        h1=figure();
        imshow(imData,[]); hold on;
        plot(endo_sample(1,:),endo_sample(2,:),'b');
        plot(epi_sample(1,:),epi_sample(2,:),'r');

        
        cd(resultDir);
        figure_name = sprintf('LA-%d.png',imIndex);
        print(h1,figure_name, '-dpng', '-r300');
        cd(workingDir);

%         disp('press any key to move to next step');
%         pause;
%         close all;

        endo_cReal = TransformCurvesFromImToRealSpace(endo_sample,imInfo);
        epi_cReal = TransformCurvesFromImToRealSpace(epi_sample,imInfo);


        DataSegSA.endo_c = endo_sample;
        DataSegSA.epi_c = epi_sample;
        DataSegSA.endo_cReal = endo_cReal;
        DataSegSA.epi_cReal = epi_cReal;
        







