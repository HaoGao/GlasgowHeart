function [Hessian, bterm] = OverallMatrices(NH, Nx, Hreg, Herr, berr, breg, QCon)

err=0.0000000001;

Ht=Hreg+Herr;
bt=berr+breg;
temp = zeros([NH, Nx]);
ling = 0.0;
% c     cancle the constrain
% c      QCon = Dfloat(1);
for I=1 :NH
	for J=1 :Nx
	   s=ling;
		for k=1:NH
          t=QCon(k,J);
          if(abs(t)<err)
%               goto 1001
          else
    		s=s+Ht(I,k)*t;
% 		s = s+ Ht(I,k);
% 1001      Continue
          end
        end
		temp(I,J)=s;
% 1000  Continue
    end
end

for I=1:Nx
	for J=I:Nx
	   s=ling;
		for k=1:NH
          t=QCon(k,I);
          if(abs(t)<err)
%               goto 2001
          else
    		s=s+t*temp(k,J);
%           s=s+temp(k,J)
% 2001      Continue
          end
        end
		Hessian(I,J)=s;
% 2000  Continue
    end
end


for I=2:Nx
	 for J=1:I-1
        Hessian(I,J)=Hessian(J,I);
     end
end
% 3020   Continue



for I=1:Nx
	   s=ling;
	   for k=1:NH
          t=QCon(k,I);
          if(abs(t)<err)
%               goto 3001
          else
    		s=s+t*bt(k);
%           s=s+bt(k)
% 3001      Continue
          end
       end
		bterm(I)=s;
% 3000  Continue
end


% c	write(*,*)'Hessian=',Hessian(1:10,1:10)
% c	write(*,*)'bterm=',bterm
% c      read(*,*)
% 
%       return
% 	end