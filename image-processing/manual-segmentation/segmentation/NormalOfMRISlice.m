function normalV = NormalOfMRISlice(info)

Xxyz = info.ImageOrientationPatient(1:3);  
Yxyz = info.ImageOrientationPatient(4:6);       
Sxyz = info.ImagePositionPatient;

normalV=cross(Xxyz,Yxyz);
