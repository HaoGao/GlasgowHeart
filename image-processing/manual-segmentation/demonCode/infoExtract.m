function info = infoExtract(info1)
%%%extract the information from dicomeinfo structure

info.ImagePositionPatient=info1.ImagePositionPatient;
info.ImageOrientationPatient=info1.ImageOrientationPatient;
info.SliceLocation = info1.SliceLocation;
info.Rows = info1.Rows;
info.Columns = info1.Columns;
info.PixelSpacing = info1.PixelSpacing;
info.SliceThickness = info1.SliceThickness;
info.InstanceNumber = info1.InstanceNumber;