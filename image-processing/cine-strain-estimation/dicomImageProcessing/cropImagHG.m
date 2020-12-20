function cropConfig = cropImagHG(imData)

    h = figure();
    imshow(imData,[]); 
    titleStr= sprintf('zoom into LV and drag a region of interest!');
    title(titleStr);
    [I1Crop rect] = imcrop(h);
    
    %%close figure;
    if exist('h','var')
    close(h);
    end
    
    cropConfig.I1Crop = I1Crop;
    cropConfig.rect = rect;
    
% else
%     cd(ResDefDir);
%     load imgDeformedBsplineRe;
%     clear imgDeformed;
%     cd(workingDir);
% end