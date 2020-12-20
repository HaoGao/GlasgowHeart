function [px, py]=findCrossLines(ImSA, ImLA, imInfoSA, imInfoLA)

%%ImLA is the image to be projected 
%%ImSA is the image in which to find out the postion of the other image 

[nrow,ncol]=size(ImLA);
p=[ncol/4 ncol*0.75;
   nrow/4 nrow*0.75];
% h2=figure();imshow(ImLA,[]);hold on;
% plot(p(1,:),p(2,:));



imInfoOneChamber = imInfoLA;
pT=TransformCurvesFromImToRealSpace(p,imInfoOneChamber);

[nrow, ncol]=size(ImSA);

p=[ncol/4 ncol*0.75;
   nrow/4 nrow*0.75];      
pTSA=TransformCurvesFromImToRealSpace(p,imInfoSA);
pTProject= Pojection3DpointsToOnePlane(pT, pTSA, imInfoSA);

[rowi ,colj]=TransformRealToImages(pTProject,imInfoSA);
%  h3=figure(); imshow(ImSA,[]);hold on;
%  plot(rowi,colj,'b.');
 
%  pause(5);
%  close(h3);
%  close(h2);
 
 px = rowi;
 py = colj;
 