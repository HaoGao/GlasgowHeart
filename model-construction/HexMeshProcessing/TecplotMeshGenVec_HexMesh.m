function TecplotMeshGenVec_HexMesh(Ver, Mesh,Dis, filename, resultDir)

workingDir = pwd();


fullfilename=sprintf('TecplotHex%s.dat',filename);
cd(resultDir);
fid = fopen(fullfilename,'w');
cd(workingDir);

fprintf(fid, 'TITLE = "Heart MESH maped with distance" \n');
fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
fprintf(fid, 'ZONE T="TotalMesh", N = %d, E=%d, F=FEPOINT, ET=BRICK \n', size(Ver, 1), size(Mesh,1));


for i = 1 : size(Ver,1)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',Ver(i,2),Ver(i,3),Ver(i,4),Dis(i,1),Dis(i,2),Dis(i,3));
end

for i = 1 : size(Mesh,1)
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', Mesh(i,2),Mesh(i,3),Mesh(i,4),Mesh(i,5), ...
                                                    Mesh(i,6),Mesh(i,7),Mesh(i,8),Mesh(i,9));
end



fclose(fid);