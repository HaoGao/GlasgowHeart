% Clean
clc; clear all; close all;


% % Read two images
% I1=im2double(rgb2gray(imread('images/circ2.png')));  
% I2=im2double(rgb2gray(imread('images/circ_static.png'))); 
% I1 = 255*I1;
% I2 = 255*I2;


 I1=im2double((imread('images/lenag2.png')));  
 I2=im2double((imread('images/lenag1.png')));

 movingImg = I1;
 staticImg = I2;
 [M, Tx, Ty] = demonDeform(movingImg, staticImg);
 
% % Set static and moving image
% S=I2; M=I1;
% 
% % Alpha (noise) constant
% alpha=2.5;
% 
% % Velocity field smoothing kernel
% Hsmooth=fspecial('gaussian',[60 60],10);
% 
% % The transformation fields
% Tx=zeros(size(M)); Ty=zeros(size(M));
% 
% [Sy,Sx] = gradient(S);
% for itt=1:200
% 	    % Difference image between moving and static image
%         Idiff=M-S;
% 
%         % Default demon force, (Thirion 1998)
%         %Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2)+Idiff.^2);
%         %Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2)+Idiff.^2);
% 
%         % Extended demon force. With forces from the gradients from both
%         % moving as static image. (Cachier 1999, He Wang 2005)
%         [My,Mx] = gradient(M);
%         Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(Mx./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
%         Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(My./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
%  
%         % When divided by zero
%         Ux(isnan(Ux))=0; Uy(isnan(Uy))=0;
% 
%         % Smooth the transformation field
%         Uxs=3*imfilter(Ux,Hsmooth);
%         Uys=3*imfilter(Uy,Hsmooth);
% 
%         % Add the new transformation field to the total transformation field.
%         Tx=Tx+Uxs;
%         Ty=Ty+Uys;
%         M=movepixels(I1,Tx,Ty); 
% end




subplot(1,3,1), imshow(movingImg,[]); title('image 1: moving image'); 
subplot(1,3,2), imshow(staticImg,[]); title('image 2: static image');
subplot(1,3,3), imshow(M,[]);  title('Registered image 1');

% %%%to show the displacement vector
% figure;
% imshow(I1,[]); title('image 1'); hold on;
% quiver(-Ty,-Tx);




