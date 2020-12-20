function TecplotLVMeshWriteWithCentreData(tecfid,abaqusInputData,FF_f, FF_s, FF_n,FF_c,FF_r,FF_l)
NNode = size(abaqusInputData.node, 1);
NElem = size(abaqusInputData.elem,1);

fprintf(tecfid, 'TITLE = " 3D Mesh of a LV reconstructed from MR slices"\n');
fprintf(tecfid, 'VARIABLES = "x","y","z","FFf","FFs","FFn","FFc","FFr","FFl" \n');
fprintf(tecfid, 'ZONE\n');
fprintf(tecfid, 'T="Fitted Mesh"\n');
fprintf(tecfid, 'DataPacking=Block\n');
fprintf(tecfid,'ZoneType=FEBrick\n');
fprintf(tecfid, 'N=%d E=%d\n', NNode, NElem);
fprintf(tecfid, 'VarLocation=([4-9]=CellCentered)\n');

% fprintf(tecfid, '#Xdata\n');
fprintf(tecfid, '\n');
for i = 1 : NNode
   fprintf(tecfid, '%f   ', abaqusInputData.node(i,1)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Ydata\n');
fprintf(tecfid, '\n');
for i = 1 : NNode
   fprintf(tecfid, '%f   ', abaqusInputData.node(i,2)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Zdata\n');
fprintf(tecfid, '\n');
for i = 1 : NNode
   fprintf(tecfid, '%f   ', abaqusInputData.node(i,3)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Udata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_f(i));
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Vdata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_s(i)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Wdata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_n(i)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Wdata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_c(i)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Wdata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_r(i)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Wdata\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%f   ', FF_l(i)); 
   if mod(i,8)==0
       fprintf(tecfid, '\n');
   end
end
fprintf(tecfid, '\n');

% fprintf(tecfid, '#Connectivity\n');
fprintf(tecfid, '\n');
for i = 1 : NElem
   fprintf(tecfid, '%d %d %d %d %d %d %d %d\n', abaqusInputData.elem(i,1), abaqusInputData.elem(i,2), abaqusInputData.elem(i,3), abaqusInputData.elem(i,4), ...
                                                abaqusInputData.elem(i,5), abaqusInputData.elem(i,6), abaqusInputData.elem(i,7), abaqusInputData.elem(i,8)); 
end
fprintf(tecfid, '\n');

























