function imData = MRIMapToRealWithImageAndHeadData(imdata, imInfo)

imReal = TransformFromImToRealSpace(imdata,imInfo);

%% save the data structure
imData.imfileName = 'nan';
imData.imImage = imdata;
imData.imReal = imReal;
imData.imInfo = imInfo;