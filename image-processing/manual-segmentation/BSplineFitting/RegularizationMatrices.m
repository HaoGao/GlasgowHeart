function [Hreg, breg, H0] = RegularizationMatrices(w0, uRegul, vRegul, NReg, uknot, vknot, nptsu, nptsv, kS,...
                               NH, wt_rr, wt_ru, wt_rv, wt_ruu, wt_rvv, wt_ruv)

r0 = w0;
err=0.0000000001;
breg=zeros([1,NH]);
Hreg = zeros(NH, NH);
H0 = 0.0;

for n=1: NReg
      
	u=uRegul(n);
	v=vRegul(n);
% c	w=wRegul(n)

      [Nu,du1,du2]= DbasisFunctions(kS,u,nptsu,uknot);
      [Nv,dv1,dv2] = DbasisFunctions(kS,v,nptsv,vknot);
% c     Call DbasisFunctions(kS,w,nptsw,wknot,Nw,dw1,dw2)

		bb=zeros([1,NH]);
		bu=zeros([1,NH]);
		buu=zeros([1,NH]);
		bv=zeros([1,NH]);
		bvv=zeros([1,NH]);
		buv=zeros([1,NH]);

          H=0;

	for I=1: nptsu
	    ru=Nu(I);
		ru1=du1(I);
		ru2=du2(I);
        if(ru < err && abs(ru1)< err && abs(ru2)< err)
			H=H+nptsv;
% 			goto 100
        else
% 	   endif
            for J=1:nptsv

	        H=H+1;

		    rv=Nv(J);
		    rv1=dv1(J);
		    rv2=dv2(J);

                if(rv < err && abs(rv1)< err &&abs(rv2)<err)

                else

                    bb(H)=ru*rv;

                    bu(H)=du1(I)*rv;
                    buu(H)=du2(I)*rv;

                    bv(H)=ru*rv1;
                    bvv(H)=ru*rv2;

                    buv(H)=ru1*rv1;
                end

            end
        end
	end

          breg=breg+wt_rr*r0*bb;
          H0=H0+wt_rr*r0*r0;

          Hreg = bxb(Hreg,wt_rr,bb, NH);
          Hreg = bxb(Hreg,wt_ru,bu, NH);
          Hreg = bxb(Hreg,wt_rv,bv, NH);
          Hreg = bxb(Hreg,wt_ruu,buu, NH);
          Hreg = bxb(Hreg,wt_rvv,bvv, NH);
          Hreg = bxb(Hreg,wt_ruv,buv, NH);

end


for I=2: NH
	for J=1: I-1
	  Hreg(I,J)=Hreg(J,I);
    end
end

          Hreg=Hreg/NReg;
          breg=breg/NReg;
          H0=H0/NReg;




function H = bxb(H, wt, b, N)

err=0.00000000001;
for I=1 :N
	      bi=b(I);
        if(abs(bi)<err)
%             goto 200
	      
        else
              bi=bi*wt;
            for J=I:N
		          bj=b(J);
                  if(abs(bj)<err)
%                       goto 201
                  else
                      
                        H(I,J)=H(I,J)+bi*bj;
                  end
            end
        end
end
