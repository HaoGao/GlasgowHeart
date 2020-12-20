function [endo_cT]=TransformCurvesFromImToRealSpace(endo_c,info)
%%% this will store the information of the image plane mesh in order to
%%% display it properly in 3D context


%%%mesh grid in image coordinate
% [X Y] = meshgrid([1:imCol],[1:imRow]);
% Z = ones(size(X));


for i = 1 : length(endo_c(1,:))
        di = info.PixelSpacing(1);
        dj = info.PixelSpacing(2);
        Xxyz = info.ImageOrientationPatient(1:3);
        Yxyz = info.ImageOrientationPatient(4:6);
        Sxyz = info.ImagePositionPatient;
        endo_cT(1,i)=Xxyz(1)*di*(endo_c(1,i)-1) + Yxyz(1)*dj*(endo_c(2,i)-1) + Sxyz(1);
        endo_cT(2,i)=Xxyz(2)*di*(endo_c(1,i)-1) + Yxyz(2)*dj*(endo_c(2,i)-1) + Sxyz(2);
        endo_cT(3,i)=Xxyz(3)*di*(endo_c(1,i)-1) + Yxyz(3)*dj*(endo_c(2,i)-1) + Sxyz(3);
end
