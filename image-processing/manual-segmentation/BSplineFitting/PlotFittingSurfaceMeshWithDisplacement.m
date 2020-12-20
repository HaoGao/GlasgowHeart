function PlotFittingSurfaceMeshWithDisplacement(uvnode, NNode, Nelement, ElementNode ,...
                                 nptsu, nptsv, uknot, vknot, kS,alpha0, AH_d, AH, ...
                                 resultDir, xyzGuide, Endo_PlotFittedEndoSurfaceFileName, ...
                                 endoSurfBool)
% c========================================================================
% c========================================================================
% c                         fitted surface
% c========================================================================

Pi = pi;
workingDir = pwd();
cd(resultDir);
fid = fopen(Endo_PlotFittedEndoSurfaceFileName,'w'); 
cd(workingDir);

fprintf(fid, 'TITLE = "Fitted Surface with guided points"\n');   
fprintf(fid, 'VARIABLES = "x","y","z","u","v","dis" \n');
if endoSurfBool == 1
     fprintf(fid, 'ZONE T="fitted Endo Surface", N=%d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', NNode, Nelement);
else
    fprintf(fid, 'ZONE T="fitted Epi Surface", N=%d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', NNode, Nelement);
end
% fitted_w = load('fitted_w.dat');

for i=1 : NNode
	  u=uvnode(1,i);
	  v=uvnode(2,i);
% 	  Call FitFuncArbitary(w,u,v)
      w = FitFuncArbitary(u,v, nptsu, nptsv, uknot, vknot, kS, AH);
      d = FitFuncArbitary(u,v, nptsu, nptsv, uknot, vknot, kS, AH_d);
% 	  w = fitted_w(i,2);
      cw=alpha0*cosh(w);
	  sw=alpha0*sinh(w);         	  
		cu=cos(u);
		su=sin(u);
		cv=cos(v);
		sv=sin(v);
		x=sw*cu*cv;
		y=sw*cu*sv;
		z=cw*su;
      fprintf(fid, '%f  %f   %f   %f   %f   %f \n', x,y,z,u*180/Pi,v*180/Pi,d);

end

% c======= FEM Mesh==================================
for j=1: Nelement
	       n1=ElementNode(1,j);
	       n2=ElementNode(2,j);
	       n3=ElementNode(3,j);
	       n4=ElementNode(4,j);
           fprintf(fid, '%d   %d   %d   %d \n', n1,n2,n3,n4);
end

%%%guided points
if endoSurfBool == 1
    fprintf(fid, 'ZONE T="Guide Points Endo", N= %d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', size(xyzGuide,2), 1);
else
    fprintf(fid, 'ZONE T="Guide Points Epi", N= %d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', size(xyzGuide,2), 1);
end
for i = 1 : size(xyzGuide,2)
    fprintf(fid, '%f    %f    %f    %f    %f   %f\n', xyzGuide(1,i), xyzGuide(2,i), xyzGuide(3,i),...
                                                      xyzGuide(4,i), xyzGuide(5,i), xyzGuide(6,i));
end
fprintf(fid, '1    1     1    1\n');


fclose(fid);      
      
      