function ErrsTemp(x, NH, Nx, QCon, Herr, berr, Hreg, breg, S0, H0);



 ling=0.0;

 for I=1:NH
	for J=1:Nx
	   s=ling;
		for k=1:NH
            s=s+Herr(I,k)*QCon(k,J);
        end
		temp(I,J)=s;
    end
 end

 for I=1: Nx
	for J=1 : Nx
	   s=ling;
		for k=1:NH
            s=s+QCon(k,I)*temp(k,J);
        end
		Herr_x(I,J)=s;
    end
 end

for I=1:Nx
	   s=ling;
		for k=1:NH
            s=s+QCon(k,I)*berr(k);
        end
		berr_x(I)=s;
end
      
       Err=S0;
for I=1 : Nx
	 Err=Err-2*x(I)*berr_x(I);
end

for I=1: Nx
	   s=ling;
	   for k=1:Nx
            s=s+Herr_x(I,k)*x(k);
       end
         t1(I)=s;
end

for I=1:Nx
	 Err=Err+x(I)*t1(I);
end

       Err=Err/2;

	tline = sprintf('Err= %f\n',Err);
    disp(tline);



for I=1:NH
	for J=1:Nx
	   s=ling;
		for k=1:NH
		s=s+Hreg(I,k)*QCon(k,J);
        end
		temp(I,J)=s;
    end
end

for I=1:Nx
	for J=1:Nx
	   s=ling;
		for k=1:NH
		s=s+QCon(k,I)*temp(k,J);
        end
		Hreg_x(I,J)=s;
    end
end


for I=1:Nx
	   s=ling;
	   for k=1 : Nx
	    s=s+Hreg_x(I,k)*x(k);
       end
         t1(I)=s;
end

       Ereg=H0;
for I=1 : Nx
	 Ereg=Ereg+x(I)*t1(I);
end

for I=1 : Nx
	   s=ling;
		for k=1 : NH
		s=s+QCon(k,I)*breg(k);
        end
		breg_x(I)=s;
end
      
for I=1:Nx
	 Ereg=Ereg-2*x(I)*breg_x(I);
end

	Ereg=Ereg/2;

	tline = sprintf('Ereg= %f\n',Ereg);
    disp(tline);

	tline = sprintf('Err+Ereg= %f\n',Err+Ereg);
    disp(tline);


% c	read(*,*)



% 	return
	end