function [uRegul, vRegul] = RegularizationPoints(umax, Nureg, Nvreg)

Pi = pi;

hu=(umax+Pi/2)/(Nureg-1);
      hv=(Pi*2)/Nvreg;

      k=0;
	for i=1:Nureg
	   u=hu*(i-1)-Pi/2;
	   for j=1 :Nvreg
            v=hv*(j-1);
            k=k+1;
            uRegul(k)=u;
            vRegul(k)=v;
       end
    end