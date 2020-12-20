function WriteAbaqusNodesSet(baseNodes,fileName,abaqusFiberDir,workingDir)

cd(abaqusFiberDir);
fid = fopen(fileName, 'w');
cd(workingDir);

rows = floor(length(baseNodes)/16);

for i = 1 : rows
    for j = 1 : 15
        nodeIndex = (i-1)*16 + j;
        fprintf(fid, '%d,\t', baseNodes(nodeIndex));
    end
        nodeIndex = i*16;
        fprintf(fid, '%d\n', baseNodes(nodeIndex));
end

if nodeIndex < length(baseNodes)
    if length(baseNodes)-nodeIndex>1
        for i = nodeIndex+1 : length(baseNodes)-1
            fprintf(fid, '%d,\t', baseNodes(i));
        end
        fprintf(fid, '%d\n', baseNodes(end));
    else
        fprintf(fid, '%d\n', baseNodes(end));
    end
end

fclose(fid);
