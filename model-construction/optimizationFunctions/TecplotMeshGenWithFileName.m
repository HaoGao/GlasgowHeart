function TecplotMeshGenWithFileName(Ver, Mesh, dis,fid)

% fileName = sprintf('TecplotHex%s.dat',filename);
% fid = fopen(fileName,'w');

fprintf(fid, 'TITLE = "LV mesh" \n');
fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
fprintf(fid, 'ZONE T="TotalMesh", N = %d, E=%d, F=FEPOINT, ET=BRICK \n', size(Ver, 1), size(Mesh,1));


for i = 1 : size(Ver,1)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',Ver(i,1),Ver(i,2),Ver(i,3),dis(i,2),0,0);
end

for i = 1 : size(Mesh,1)
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', Mesh(i,1),Mesh(i,2),Mesh(i,3),Mesh(i,4),Mesh(i,5),Mesh(i,6),Mesh(i,7),Mesh(i,8));
end


