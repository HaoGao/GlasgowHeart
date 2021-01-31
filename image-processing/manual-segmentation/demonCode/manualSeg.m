function endoT = manualSeg(im)

endoT = [];
h=figure(); hold on; imshow(im,[]);hold on;
 but = 1; n = 1; endo=[];
 while but == 1
                [x y but] = ginput(1);
                plot(x,y,'r*');
                endo(n,1)=x;
                endo(n,2)=y;
                n = n+1;
 end
 if size(endo,1)>=2
    [endoT, endoT] = samplingBC(im, endo', endo',50);
    endoT = endoT';
 else
     
 end
 close(h) 