function [xy, Enode, NNode, NElement, Na] = DiskMesh(N,R0,R1)

xyOuter = zeros([2, N+1]);
nVouter = zeros([2,N+1]);

xyInner = zeros([2, N+1]); 
nVinner = zeros([2,N+1]);

xyArch = zeros([2,4*N]);
nArch = zeros([2,4*N]);

Archcenters = zeros([2,4]);
inxy = zeros([2,4*N]);
inn = zeros([2,4*N]);

yi=1.0;
ling=0.0;
Pi=acos(-yi);

t1=60.0;
t0=90.0;

length=sqrt(2.0)*R1/N;
Na=int16((R0-R1)/length)-10;
if( Na<3)
    Na=3;
end
    
dr=(R0-R1)/Na;
dt=(t0-t1)/Na;

pn=0;
for ii=0:Na
	   theta=t0-dt*ii;
	   R=R0-dr*ii;
% 	Call partitionArch(xyArch, nArch, Archcenters, R, theta, N)
      [xyArch, nArch, Archcenters] = partitionArch(R, theta, N);
    if(ii == Na)
	  inxy=xyArch;
	  inn=nArch;
    end
    for i=1:4*N
	      pn=pn+1;
			xy(1,pn)=xyArch(1,i);
			xy(2,pn)=xyArch(2,i);
    end
end

pe=0;
for ii=0:Na-1
	j1=4*N*ii;
	j2=4*N*(ii+1);
    for i=1: 4*N-1
			pe=pe+1;
			Enode(1,pe)=i+j1;
			Enode(2,pe)=i+1+j1;
			Enode(3,pe)=i+1+j2;
			Enode(4,pe)=i+j2;
    end
			pe=pe+1;
			Enode(1,pe)=4*N+j1;
			Enode(2,pe)=1+j1;
			Enode(3,pe)=1+j2;
			Enode(4,pe)=4*N+j2;
end

      pn0=pn-4*N;
      xysq = zeros([2,(N+1)*(N+1)]);
      eNodesq = zeros([4,N*N]);
      [xysq, eNodesq] = innerSquareMesh(inxy,Archcenters, N);
%       Call innerSquareMesh(xysq, eNodesq, inxy,Archcenters, N)


      for i=4*N+1:(N+1)*(N+1)
         pn=pn+1;
			xy(1,pn)=xysq(1,i);
			xy(2,pn)=xysq(2,i);
      end

    for i=1: N*N
	  n1=eNodesq(1,i)+pn0;
	  n2=eNodesq(2,i)+pn0;
	  n3=eNodesq(3,i)+pn0;
	  n4=eNodesq(4,i)+pn0;
			pe=pe+1;
			Enode(1,pe)=n1;
			Enode(2,pe)=n2;
			Enode(3,pe)=n3;
			Enode(4,pe)=n4;
    end

	NNode=pn;
	NElement=pe;
    
    
    
    
    



%%%%%%%%%%%%%%functions 
function [xyArch, nArch, Archcenters] = partitionArch(R, theta, N)
   Pi=acos(-1);
	a2=sqrt((2));

	theta=theta*Pi/180;
    alpha=Pi/2-theta;
	beta=theta-Pi/4;
	R2=R/(a2*sin(beta));
	xc=R-R2*cos(alpha);
	yc= -R2*sin(alpha);

	ht=2*beta/N;
for i=1:N
	  t=alpha+ht*(i-1);
		cs=cos(t);
		ss=sin(t);
		x=xc+R2*cs;
		y=yc+R2*ss;
		vx=cs;
		vy=ss;

        if(i==1)
           vx=1.0;
           vy=0.0;
        end

        xyArch(1,i)=x;
        xyArch(2,i)=y;
        nArch(1,i)=vx;
        nArch(2,i)=vy;

          j=i+N;
        xyArch(1,j)=-y;
        xyArch(2,j)= x;
        nArch(1,j)=-vy;
        nArch(2,j)= vx;

          j=i+2*N;
        xyArch(1,j)=-x;
        xyArch(2,j)=-y;
        nArch(1,j)=-vx;
        nArch(2,j)=-vy;

          j=i+3*N;
        xyArch(1,j)= y;
        xyArch(2,j)=-x;
        nArch(1,j)= vy;
        nArch(2,j)=-vx;

end

	    t=Pi/4;
		cs=cos(t);
		ss=sin(t);
		xa=xc+R2*cs;
		ya=yc+R2*ss;

		Archcenters(1,1)=xa;
		Archcenters(2,1)=ya;

		Archcenters(1,2)=-xa;
		Archcenters(2,2)=ya;

		Archcenters(1,3)=-xa;
		Archcenters(2,3)=-ya;

		Archcenters(1,4)=xa;
		Archcenters(2,4)=-ya;


function [xysq, eNodesq] = innerSquareMesh( xy,Archcenters, N)
st= zeros([2, (N+1)*(N+1)]);
xysq= zeros([2,(N+1)*(N+1)]);
eNodesq = zeros([4,N*N]);
eNode = zeros([4,N*N]);

% Call StandardSquaremesh(st,eNode,N)
[st,eNode] = StandardSquaremesh(N);

eNodesq=eNode;
	for i=1: 4*N
	  xysq(1,i)=xy(1, i);
	  xysq(2,i)=xy(2, i);
    end

	xcenter(1)=Archcenters(1,1);
	xcenter(2)=Archcenters(1,2);
	xcenter(3)=Archcenters(1,3);
	xcenter(4)=Archcenters(1,4);

	ycenter(1)=Archcenters(2,1);
	ycenter(2)=Archcenters(2,2);
	ycenter(3)=Archcenters(2,3);
	ycenter(4)=Archcenters(2,4);

	xcorner(1)=xy(1,1);
	ycorner(1)=xy(2,1);

	xcorner(2)=xy(1,1+N);
	ycorner(2)=xy(2,1+N);

	xcorner(3)=xy(1,1+2*N);
	ycorner(3)=xy(2,1+2*N);

	xcorner(4)=xy(1,1+3*N);
	ycorner(4)=xy(2,1+3*N);


% c----------------This is a mapping--------------------------------
for i=4*N+1:(N+1)*(N+1)
	  x=0.0;
	  y=0.0;
		s=st(1,i);
		t=st(2,i);
          Ncorner(1)=(1-t)*(1+s)*(-1+s-t)/4;
          Ncorner(2)=(1+t)*(1+s)*(-1+s+t)/4;
          Ncorner(3)=(1+t)*(1-s)*(-1-s+t)/4;
          Ncorner(4)=(1-t)*(1-s)*(-1-s-t)/4;

		Ncenter(1)=(1-t*t)*(1+s)/2;
		Ncenter(2)=(1-s*s)*(1+t)/2;
		Ncenter(3)=(1-t*t)*(1-s)/2;
		Ncenter(4)=(1-s*s)*(1-t)/2;

        x=0.0;
	    y=0.0;
		for j=1:4
		  x=x+Ncorner(j)*xcorner(j);
		  y=y+Ncorner(j)*ycorner(j);
        end
		for j=1:4
		  x=x+Ncenter(j)*xcenter(j);
		  y=y+Ncenter(j)*ycenter(j);
        end

        xysq(1,i)=x;
	    xysq(2,i)=y;

end


function [st,eNode] = StandardSquaremesh(N)

	hs=2.0/N;
	ht=2.0/N;

	for i=1: N+1
	   s=1.0;
	   t=-1+ht*(i-1);
		st(1,i)=s;
		st(2,i)=t;
    end

	for i=N+2: 2*N+1
	   t=1.0;
	   s=1-hs*(i-(N+1));
		st(1,i)=s;
		st(2,i)=t;
    end

	for i=2*N+2: 3*N+1
	   t=1-ht*(i-(2*N+1));
	   s=(-1.0);
		st(1,i)=s;
		st(2,i)=t;
    end

	for i=3*N+2: 4*N
	   t=(-1.0);
	   s=-1+hs*(i-(3*N+1));
		st(1,i)=s;
		st(2,i)=t;
    end
% c=========Internal points
      k=4*N;
      for i=2: N
	    for j=2:N
	     s=1-hs*(i-1);
	     t=-1+ht*(j-1);
	     k=k+1;
		 st(1,k)=s;
		 st(2,k)=t;
        end
      end
% c==========Element nodes ====================
      k=4*N;
      ne=0;
	for j=1: N-2
	  Nj=(j-1)*(N-1)+k;
	  for i=1: N-2
	   ne=ne+1;
          eNode(1,ne)=i+Nj;
          eNode(2,ne)=i+(N-1)+Nj;
          eNode(3,ne)=i+N+Nj;
          eNode(4,ne)=i+1+Nj;
      end
    end
	
	for i=1: N-1
	   ne=ne+1;
          eNode(1,ne)=i;
          eNode(2,ne)=4*N+i-1;
          eNode(3,ne)=4*N+i;
          eNode(4,ne)=i+1;
    end

	   ne=ne+1;
          eNode(1,ne)=N;
          eNode(2,ne)=4*N+(N-1);
          eNode(3,ne)=N+2;
          eNode(4,ne)=N+1;

	for i=N+2: 2*N-1
	   ne=ne+1;
	    j=i-(N+1);
          eNode(1,ne)=i;
          eNode(2,ne)=4*N+j*(N-1);
          eNode(3,ne)=4*N+(j+1)*(N-1);
          eNode(4,ne)=i+1;
    end

	   ne=ne+1;
          eNode(1,ne)=2*N;
          eNode(2,ne)=(N+1)*(N+1);
          eNode(3,ne)=2*N+2;
          eNode(4,ne)=2*N+1;

	for i=2*N+2: 3*N-1
	   ne=ne+1;
	    j=i-(2*N+2);
	    M=N+1;
          eNode(1,ne)=i;
          eNode(2,ne)=M*M-j;
          eNode(3,ne)=M*M-j-1;
          eNode(4,ne)=i+1;
    end

	   ne=ne+1;
          eNode(1,ne)=3*N;
          eNode(2,ne)=(N+1)*(N+1)-(N-2);
          eNode(3,ne)=3*N+2;
          eNode(4,ne)=3*N+1;

	for i=3*N+2: 4*N-1
	   ne=ne+1;
	    j=i-(3*N+1);
	    M=4*N+(N-2)*(N-1)+1;
          eNode(1,ne)=i;
          eNode(2,ne)=M-(j-1)*(N-1);
          eNode(3,ne)=M-j*(N-1);
          eNode(4,ne)=i+1;
    end



