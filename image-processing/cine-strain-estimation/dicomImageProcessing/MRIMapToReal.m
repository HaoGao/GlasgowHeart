function imData = MRIMapToReal(im)

im1 = dicomread(im);
info1 = dicominfo(im);
imInfo1 = infoExtract(info1); clear info;
imReal = TransformFromImToRealSpace(im1,imInfo1);

%% save the data structure
imData.imfileName = im;
imData.imImage = im1;
imData.imReal = imReal;
imData.imInfo = info1;