
function [MidConfig, ApexConfig] = AHADefinitionManual(imData, midPosition)

%%%initiate the structure for segments
ApexConfig.SeptTheta = [];
ApexConfig.AntTheta = [];
ApexConfig.Lat = [];
ApexConfig.Inf = []; 
ApexConfig.endo_c = [];
ApexConfig.theta = [];


MidConfig.InfSeptTheta = [];
MidConfig.AntSeptTheta = [];
MidConfig.AntTheta = [];
MidConfig.AntLatTheta = [];
MidConfig.InfLatTheta = [];
MidConfig.InfTheta = [];
MidConfig.endo_c = [];
MidConfig.theta = [];





h1=figure(); imshow(imData,[]);hold on;
if midPosition
    titleStr = sprintf('Non apical slice, 3 lines, left click 6 points, starting from inferior insertion, to anterior insertion');
        title(titleStr);
else
    titleStr = sprintf('apical slice, 2 lines,  left click 4 points, starting from inferior insertion, to anterior insertion ');
                title(titleStr);
end

hold on;pause;
		%%define 6 points or 4 points 
		%%%starting from inferior insertion go through anterior insertion
    if midPosition  %%this is for the regions above apecial slice
        
                endo_c=[];
                but = 1;
                n=1;
                while but ==1 && n<=6
                        [x y but]=ginputc(1, 'Color', 'y', 'LineWidth',2);
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
                
                endo_c=[];
                but = 1;
                n=1;
                while but ==1 && n<=4
                        [x y but]=ginputc(1, 'Color', 'y', 'LineWidth',2);
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


close(h1);




