function PlotInitialSurfaceMesh(NuMesh, NvMesh, uvnode, ElementNode, NNode,Nelement, w0, alpha0, resultDir, Endo_PlotFitSurfaceFileName)
      

	Pi=acos((-1.0));
	Nu=NuMesh;
	Nv=NvMesh;
   
    workingDir = pwd();
    cd(resultDir);
    fid = fopen(Endo_PlotFitSurfaceFileName, 'w');
    cd(workingDir);
    
    
%       write(30,922)
  fprintf(fid, 'VARIABLES = "x","y","z","u","v","w" \n');
  fprintf(fid, 'ZONE T="Initial Surface", N= %d, E= %d, F=FEPOINT, ET=QUADRILATERAL\n', NNode, Nelement);
 

% c======= FEM Nodes==================================
	cw=alpha0*cosh(w0);
	sw=alpha0*sinh(w0);
for i=1:NNode
	  u=uvnode(1,i);
	  v=uvnode(2,i);
		cu=cos(u);
		su=sin(u);
		cv=cos(v);
		sv=sin(v);
		x=sw*cu*cv;
		y=sw*cu*sv;
		z=cw*su;
      fprintf(fid, '%f  %f  %f  %f  %f  %f\n', x,y,z,u*180/Pi,v*180/Pi,w0);
%         write(30, 903)x,y,z,u*180/Pi,v*180/Pi,w0
% 903   format(6(f16.8,2x))
% 1000  Continue
end

% c======= FEM Mesh==================================
for j=1: Nelement
	       n1=ElementNode(1,j);
	       n2=ElementNode(2,j);
	       n3=ElementNode(3,j);
	       n4=ElementNode(4,j);
           fprintf(fid, '%d  %d  %d  %d\n', n1, n2, n3, n4);
%              write(30,904)n1,n2,n3,n4
% 904          format(4(i8,2x))
% 2100  Continue    
%       return
end


fclose(fid);
	end  