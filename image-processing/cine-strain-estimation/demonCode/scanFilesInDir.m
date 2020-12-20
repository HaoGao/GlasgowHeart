%%%function scan the files in a folder
%%%only the files will be included, but not the folder
function fileList = scanFilesInDir(dicomDir)

imageList = dir(dicomDir);
imageList = imageList(3:end,:);
imTotalNo = size(imageList,1);


%%need to get rid of the folder if there is any
fileIndex = 0;
for imgIndex = 1 : imTotalNo
    %fileName = imageList(imgIndex).name;
    if imageList(imgIndex).isdir
        %%do not copy
    else
        fileIndex = fileIndex + 1;
        fileList(fileIndex) = imageList(imgIndex);
    end
        
    
end





