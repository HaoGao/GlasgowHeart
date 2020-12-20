 function  p = FitFuncArbitary(u,v, nptsu, nptsv, uknot, vknot, kS, AH)
% % Subroutine 
% %       Include 'SetParameters.f'
% %       Include 'comFitting.f'
% % 	Include 'ComBSPlineKnots.f'
% 
% 	Real*8 p,b(NH),u,v,w
% 	Integer I,J,H
%       Real*8 Nu(nptsu),Nv(nptsv),Nw(nptsw)
    NH = length(AH);

     Nu =  basisFunction(kS,u,nptsu,uknot);
     Nv =  basisFunction(kS,v,nptsv,vknot);
% c     Call basisFunctions(kS,w,nptsw,wknot,Nw)
          H=0;

	    for I=1:nptsu
            for J=1:nptsv
                H=H+1;
                b(H)=Nu(I)*Nv(J);
            end
        end

		p=0.0;
        for i=1:NH
            p=p+b(i)*AH(i);
        end