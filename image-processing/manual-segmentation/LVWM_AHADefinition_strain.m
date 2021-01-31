clear all;
close all;
clc;

% LVWM_config;
LVWM_config;

cd(resultDir);
load imDesired;
load rotationConfig; %%this is from segmentation part
cd(workingDir);

timeInstanceSelectedDiastole = 1;
SASlicePositonMiddle = 2;
SASlicePositonApex = 6;

for positionIndex = 1 : 2
    if positionIndex == 1
        imInfo1 = imDesired.SXSlice(1,SASlicePositonMiddle).SXSlice(timeInstanceSelectedDiastole,1).imInfo;
        imInfo = infoExtract(imInfo1);
        imData = imDesired.SXSlice(1,SASlicePositonMiddle).SXSlice(timeInstanceSelectedDiastole,1).imData;
    else
        imInfo1 = imDesired.SXSlice(1,SASlicePositonApex).SXSlice(timeInstanceSelectedDiastole,1).imInfo;
        imInfo = infoExtract(imInfo1);
        imData = imDesired.SXSlice(1,SASlicePositonApex).SXSlice(timeInstanceSelectedDiastole,1).imData;
    end
    


    h1=figure(); imshow(imData,[]);hold on;pause;
    %%define 6 points or 4 points, starting from inferior septal
    if positionIndex ==1 
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
        centerPoint = [mean(endo_c(1,:)) mean(endo_c(2,:))];
        for i = 1 : size(endo_c,2)
            p = [endo_c(1,i),endo_c(2,i)];
            theta(i) = degreeCalculationPointBased(p,centerPoint)*180/pi; %%in the range of 0-360
        end

        %%%segment region
        MidConfig.InfSeptTheta = degreeReOrder(theta(2),theta(1));
        MidConfig.AntSeptTheta = degreeReOrder(theta(3),theta(2));
        MidConfig.AntTheta = degreeReOrder(theta(4),theta(3));
        MidConfig.AntLatTheta = degreeReOrder(theta(5),theta(4));
        MidConfig.InfLatTheta = degreeReOrder(theta(6),theta(5));
        MidConfig.InfTheta = degreeReOrder(theta(6),theta(1));
        MidConfig.endo_c = endo_c;
        MidConfig.theta = theta;
    else %%this is for the apex slices
        disp('define 4 position for the apical slices');
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
                else
                    plot(x,y,'r.');hold on;
                end
                endo_c(1,n)=x;
                endo_c(2,n)=y;
                n=n+1;
        end

        %%%degree calculation
        centerPoint = [mean(endo_c(1,:)) mean(endo_c(2,:))];
        theta = [];
        for i = 1 : size(endo_c,2)
            p = [endo_c(1,i),endo_c(2,i)];
            theta(i) = degreeCalculationPointBased(p,centerPoint)*180/pi; %%in the range of 0-360
        end

        %%%segment region
        ApexConfig.SeptTheta = degreeReOrder(theta(2),theta(1));
        ApexConfig.AntTheta = degreeReOrder(theta(3),theta(2));
        ApexConfig.Lat = degreeReOrder(theta(4),theta(3));
        ApexConfig.Inf = degreeReOrder(theta(1),theta(4)); 
        ApexConfig.endo_c = endo_c;
        ApexConfig.theta = theta;
    end
    disp('done, to close all figures');
    pause; 
    close all;
end


cd(resultDir)
save DivisionConfig MidConfig ApexConfig;
cd(workingDir);

