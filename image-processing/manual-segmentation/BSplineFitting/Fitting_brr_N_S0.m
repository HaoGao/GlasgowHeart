function [berr, S0]= Fitting_brr_N_S0(weightGP, pGuide, NPoints, NH, bN)

% 	berr=ling
berr = zeros([1 NH]);
S0=0.0;

	for n=1 :NPoints
	  wt=weightGP(n);
	  sn=pGuide(n);
	  S0=S0+wt*sn*sn;
	  b(1:NH)=bN(1:NH,n);
	  berr=berr+wt*sn*b;
    end

    S0=S0/NPoints;
	berr=berr/NPoints;

