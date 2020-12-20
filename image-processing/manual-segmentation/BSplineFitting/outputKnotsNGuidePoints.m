function AH = outputKnotsNGuidePoints(NH, Nx, QCon, xguess, ...
                                      uknot, vknot, nptsu, nptsv, kS, ...
                                      resultDir, Endo_FitparameterFileName)

workingDir = pwd();
cd(resultDir);
fid = fopen(Endo_FitparameterFileName, 'w');
cd(workingDir);


  ling=0.0;

	for H=1 :NH
	   s=ling;
	   for k=1 :Nx
		s=s+QCon(H,k)*xguess(k);
       end
	   AH(H)=s;
    end
    
fprintf(fid, 'nptsu \t nptsv\t kS\n');    
fprintf(fid, '%d\t %d\t %d\n', nptsu, nptsv, kS);
fprintf(fid, '%d\t knots in u direction \n', nptsu+kS);
for i = 1 : nptsu+kS
    fprintf(fid, '%d\t %f\n', i, uknot(i));
end

fprintf(fid, '%d\t  knots in v direction\n', nptsv+kS);
for i = 1 : nptsv+kS
    fprintf(fid, '%d\t %f\n', i, vknot(i));
end
    
fprintf(fid, 'Control points are: \n');
fprintf(fid, '%d \t in u direction \n', nptsu);
fprintf(fid, '%d \t in v direction \n', nptsv);
fprintf(fid, 'Iu \t Jv \t A_IJ \n');

H = 0;
for i = 1 : nptsu
    for j = 1 : nptsv
        H = H+1;
        fprintf(fid, '%d\t %d\t %f\n', i, j, AH(H));
    end
end

fclose(fid);