function [endoT epiT]= manualSegEndoEpi(im,sampleN)

endoT = [];

imSize = size(im);
imWidth = imSize(2);
imHeight = imSize(1);

ratio_w_h = imWidth/double(imHeight);
%%for figure window control
scrsz = get(0,'ScreenSize');
sizeRatio = 0.8;
if sizeRatio*scrsz(4) <= sizeRatio*scrsz(3)
    figure_w = sizeRatio*scrsz(4);
    figure_h = figure_w;
else
    figure_w = sizeRatio*scrsz(3);
    figure_h = figure_w;
end


h=figure('Position',[(1-sizeRatio)/2*scrsz(3) (1-sizeRatio)/2*scrsz(4) figure_w figure_h]); 

hold on; imshow(im,[], 'InitialMagnification', 'fit');hold on;
title('manually segment boudnaries, left click to start, right click to finish');
 but = 1; n = 1; endo=[];

 while but == 1
                [x y but] = ginputc(1, 'Color', 'y', 'LineWidth',2);
                plot(x,y,'r*');
                endo(n,1)=x;
                endo(n,2)=y;
                n = n+1;
 end
 
 but = 1; n = 1; epi=[];
 while but == 1
                [x y but] = ginputc(1, 'Color', 'y', 'LineWidth',2);
                plot(x,y,'b*');
                epi(n,1)=x;
                epi(n,2)=y;
                n = n+1;
 end
 
 if size(endo,1)>=2
    [endoT, epiT] = samplingBC(im, endo', epi',sampleN);
    endoT = endoT';
    
%     [epiT, epiT] = samplingBC(im, epi', epi',50);
    epiT = epiT';
    
 else
     
 end
 close(h) 