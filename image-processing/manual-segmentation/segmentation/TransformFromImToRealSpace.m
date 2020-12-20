function [imReal]=TransformFromImToRealSpace(im,info)
%%% this will store the information of the image plane mesh in order to
%%% display it properly in 3D context

[imRow imCol]=size(im);

%%%mesh grid in image coordinate
% [X Y] = meshgrid([1:imCol],[1:imRow]);
% Z = ones(size(X));


for i = 1 : size(im,2)
    for j = 1 : size(im,1)
        di = info.PixelSpacing(1);
        dj = info.PixelSpacing(2);
        Xxyz = info.ImageOrientationPatient(1:3);
        Yxyz = info.ImageOrientationPatient(4:6);
        Sxyz = info.ImagePositionPatient;
        X(i,j) = Xxyz(1)*di*(i-1) + Yxyz(1)*dj*(j-1) + Sxyz(1);
        Y(i,j) = Xxyz(2)*di*(i-1) + Yxyz(2)*dj*(j-1) + Sxyz(2);
        Z(i,j) = Xxyz(3)*di*(i-1) + Yxyz(3)*dj*(j-1) + Sxyz(3);
    end
end

imReal.X = X;
imReal.Y = Y;
imReal.Z = Z;