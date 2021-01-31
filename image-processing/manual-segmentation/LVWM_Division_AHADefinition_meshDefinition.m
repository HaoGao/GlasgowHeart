%%%this is used to divide LV into different regions
clear all; 
close all; 
clc;

% LVWM_config;
LVWM_config;

cd(resultDir);
load imDesired;
load DataSegSAOri;
cd(workingDir); 

totalSXSliceLocation = size(imDesired.SXSlice, 2);
timeInstanceSelected = patientConfigs(patientIndex,1).timeInstanceSelected;
SXSliceSorted = imDesired.SXSlice;
h1 = figure();

slices_with_6regions = [basalSlices middlSlices];
for positionIndex = 1 : length(slices_with_6regions)
    imIndex_sa = slices_with_6regions(positionIndex);
    imData = SXSliceSorted(imIndex_sa).SXSlice(timeInstanceSelected).imData;
    title_str = 'define 6 region, start from inferior rv insert';
    
    endo_bc = DataSegSA(1,imIndex_sa).endo_c;
    epi_bc = DataSegSA(1,imIndex_sa).epi_c;
    
    close(h1);h1=figure(); imshow(imData,[]);title(title_str); hold on;
    plot(endo_bc(1,:),endo_bc(2,:),'b-');
    plot(epi_bc(1,:), epi_bc(2,:), 'b-');
    shapex = mean(endo_bc(1,:));
    shapey = mean(endo_bc(2,:));
    plot(shapex, shapey, 'ro');
    pause;
    
    endo_c=[];
	but = 1;
	n=1;
    while but ==1 && n<=6
		[x, y, but]=ginput(1);
		if n==1 
			plot(x,y,'b.');hold on;
		elseif n==2
			plot(x,y,'r+'); hold on;
		elseif n==3
			plot(x,y,'y*');hold on;
		elseif n==4
			plot(x,y,'b<'); hold on;
		else
			plot(x,y,'r.');hold on;
		end
		endo_c(1,n)=x;
		endo_c(2,n)=y;
		n=n+1;
    end
    
    %%%degree calculation
	theta = [];
	centerPoint =  [shapex, shapey];
    for i = 1 : size(endo_c,2)
		p = [endo_c(1,i),endo_c(2,i)];
	    theta(i) = DegreeCalculationUsingImageCoordinate(centerPoint,p)*180/pi;
%         degreeCalculationPointBased(p,centerPoint)*180/pi; %%in the range of 0-360
	end
    
    %%%segment region
	BaseMidConfig(positionIndex).InfSeptTheta = degreeReOrder(theta(2),theta(1));
	BaseMidConfig(positionIndex).AntSeptTheta = degreeReOrder(theta(3),theta(2));
	BaseMidConfig(positionIndex).AntTheta = degreeReOrder(theta(4),theta(3));
	BaseMidConfig(positionIndex).AntLatTheta = degreeReOrder(theta(5),theta(4));
	BaseMidConfig(positionIndex).InfLatTheta = degreeReOrder(theta(6),theta(5));
	BaseMidConfig(positionIndex).InfTheta = degreeReOrder(theta(6),theta(1));
	BaseMidConfig(positionIndex).endo_c = endo_c;
	BaseMidConfig(positionIndex).theta = theta;
end

for positionIndex = 1 : length(apicaSlices)
    imIndex_sa = apicaSlices(positionIndex);
    imData = SXSliceSorted(imIndex_sa).SXSlice(timeInstanceSelected).imData;
    title_str = 'define 4 region, start from inferior rv insert';
    
    endo_bc = DataSegSA(1,imIndex_sa).endo_c;
    epi_bc = DataSegSA(1,imIndex_sa).epi_c;
    
    close(h1);h1=figure(); imshow(imData,[]); title(title_str); hold on;
    plot(endo_bc(1,:),endo_bc(2,:),'b-');
    plot(epi_bc(1,:), epi_bc(2,:), 'b-');
    shapex = mean(endo_bc(1,:));
    shapey = mean(endo_bc(2,:));
    plot(shapex, shapey, 'ro');
    pause;
    
    endo_c=[];
	but = 1;
	n=1;
    while but ==1 && n<=4
		[x, y, but]=ginput(1);
		if n==1 
			plot(x,y,'b.');hold on;
		elseif n==2
			plot(x,y,'r+'); hold on;
		elseif n==3
			plot(x,y,'y*');hold on;
        elseif n==4
			plot(x,y,'b<'); hold on;
		end
		endo_c(1,n)=x;
		endo_c(2,n)=y;
		n=n+1;
    end
    
    %%%degree calculation
	theta = [];
	centerPoint =  [shapex, shapey];
    for i = 1 : size(endo_c,2)
		p = [endo_c(1,i),endo_c(2,i)];
	    theta(i) = DegreeCalculationUsingImageCoordinate(centerPoint,p)*180/pi;
%         degreeCalculationPointBased(p,centerPoint)*180/pi; %%in the range of 0-360
	end
    
    %%%segment regio  
    ApexConfig(positionIndex).SeptTheta = degreeReOrder(theta(2),theta(1));
	ApexConfig(positionIndex).AntTheta = degreeReOrder(theta(3),theta(2));
	ApexConfig(positionIndex).Lat = degreeReOrder(theta(4),theta(3));
	ApexConfig(positionIndex).Inf = degreeReOrder(theta(1),theta(4)); 
	ApexConfig(positionIndex).endo_c = endo_c;
	ApexConfig(positionIndex).theta = theta;
end

cd(resultDir);
save AHADefinition ApexConfig BaseMidConfig;
cd(workingDir);
















