function [Herr, bN]=FittingErrParameters(nptsu, nptsv, kS, NH, uGuide, vGuide, weightGP, NPoints, uknot, vknot)
% Htt = zeros([NH, NH]);
% ling = 0.0;
err=0.0000000001;
% b = zeros([NH,1]);
bN = [];
% berr = [];
Herr = zeros([NH, NH]);

for n=1 :NPoints
      
	u=uGuide(n);
	v=vGuide(n);
% c	w=wGuide(n)

    Nu = basisFunction(kS,u,nptsu,uknot);
    Nv = basisFunction(kS,v,nptsv,vknot);
% c     Call basisFunctions(kS,w,nptsw,wknot,Nw)
%           b=ling;
          b = zeros([NH,1]);
          H=0;
        for I=1: nptsu
	        su=Nu(I);
            if(su < err)
			   H=H+nptsv;
            else   
               for J = 1 : nptsv
                   H = H+1;
                   sv= Nv(J);
                   if (sv < err)
                       
%                        continue;
                   else
                       s = sv*su;
                       b(H) = s;
                   end
               end
            end
        end
        
               
%                continue; 
% % 			   goto 100
%             end
%             for J=1 : nptsv
%                 H=H+1;
%                 sv=Nv(J); 
%                 if(sv < err)
%                      continue;
% %                goto 101
%                 end
% 	            s=sv*su;
% 	             b(H)=s;
% % 101       Continue
%             end
% % 100       Continue
%         end
	    bN(1:NH,n)=b(1:NH);

        wt=weightGP(n)/NPoints;
    for I=1:NH
	     bi=b(I);
		 if(bi<err)
%              goto 200
%             continue;
         else
            for J=I: NH
	           bj=b(J);
		       if(bj<err)
%                  goto 201
%                 continue;
               else
                    Herr(I,J)=Herr(I,J)+wt*bi*bj;
               end
            end
         end
    end
end

for I=2:NH
	 for J=1:I-1
        Herr(I,J)=Herr(J,I);
     end
end
