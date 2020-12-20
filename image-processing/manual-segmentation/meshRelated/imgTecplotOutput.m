%%%tecplot image generation
function imgTecplotOutput(imData,fileName,resultDir)

workingDir = pwd();
cd(resultDir);
fid = fopen(fileName, 'w');
cd(workingDir);


xcor = imData.imReal.X';
ycor = imData.imReal.Y';
zcor = imData.imReal.Z';
imImage = im2double(imData.imImage);
maxIntensity = max(max(imImage));

row = size(imImage,1);
col = size(imImage,2);

EleRow = row-1;
EleCol = col-1;

% totalNodes = row*col;
% totalElement = EleRow*EleCol;

for i = 1 : row
    for j = 1 : col
        nodeIndex = (i-1)*col + j;
        nodes(nodeIndex,2) = xcor(i,j);
        nodes(nodeIndex,3) = ycor(i,j);
        nodes(nodeIndex,4) = zcor(i,j);
        nodes(nodeIndex,5) = imImage(i,j)/maxIntensity*8;
    end
end

for i = 1 : EleRow
    for j = 1 : EleCol
        eleIndex = (i-1)*EleCol+j;
        nodeIndex = (i-1)*col+j;
        nodeIndex1 = nodeIndex + 1;
        nodeIndex2 = nodeIndex + 1 + col;
        nodeIndex3 = nodeIndex + col;
        elem(eleIndex,1:5) = [eleIndex, nodeIndex, nodeIndex1, nodeIndex2, nodeIndex3];
    end
end

fprintf(fid, 'TITLE = "IMG MESH maped with pixel intensity" \n');
fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
fprintf(fid, 'ZONE T="TotalMesh", N = %d, E=%d, F=FEPOINT, ET=quadrilateral \n', size(nodes, 1), size(elem,1));


for i = 1 : size(nodes,1)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',nodes(i,2),nodes(i,3),nodes(i,4),nodes(i,5),nodes(i,5),0);
end

for i = 1 : size(elem,1)
    fprintf(fid,'%d\t%d\t%d\t%d\n', elem(i,2),elem(i,3),elem(i,4),elem(i,5));
end

fclose(fid);


    