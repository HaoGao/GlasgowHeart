function eL = getLineMesh(N)

eL = zeros([2,N]);
for i=1: N-1
	 eL(1,i)=i;
	 eL(2,i)=i+1;
end
	  eL(1,N)=N;
	  eL(2,N)=1;