function [rowi, colj]=TransformRealToImages(pT,info)
for i = 1 : length(pT(1,:))
        di = info.PixelSpacing(1);
        dj = info.PixelSpacing(2);
        Xxyz = info.ImageOrientationPatient(1:3);
        Yxyz = info.ImageOrientationPatient(4:6);
        Sxyz = info.ImagePositionPatient;
        A = [Xxyz(1)*di Yxyz(1)*dj Sxyz(1);
             Xxyz(2)*di Yxyz(2)*dj Sxyz(2);
             Xxyz(3)*di Yxyz(3)*dj Sxyz(3)];
        c = A\[pT(1,i), pT(2,i),pT(3,i)]';
        rowi(i)=c(1); 
        colj(i)=c(2);
end