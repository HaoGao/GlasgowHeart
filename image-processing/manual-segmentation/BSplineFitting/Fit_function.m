function [pEpi, pEndo] = Fit_function(nptsu, nptsv, uknot, vknot, u, v, kS, AIJ_Epi, AIJ_Endo)

Nu = basisFunction(kS, u, nptsu, uknot);
Nv = basisFunction(kS, v, nptsv, vknot);

pEpi = 0; 
pEndo = 0;
for I= 1: nptsu
    for J = 1 : nptsv
        pEpi=pEpi+AIJ_Epi(I,J)*Nu(I)*Nv(J);
	    pEndo=pEndo+AIJ_Endo(I,J)*Nu(I)*Nv(J);
    end
end
