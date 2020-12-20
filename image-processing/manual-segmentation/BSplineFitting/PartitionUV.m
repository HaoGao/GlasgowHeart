function [uvnode, NNode,Nelement,ElementNode, neRegular,nnRegular, Na] = PartitionUV(umax, w0, alpha0, Nu, Nv)
%%Nu is the number along the long axial direction 
%%Nv is the number in the 
%%here there is a need for global variable used to set when the apical
%%region start 
Pi = pi;
global u_apex; 
if ~isempty(u_apex)
    u_apex_degree = u_apex;
    disp('manually defined u at apical region!');
else
    u_apex_degree = -Pi/2.5;
end

if((4*(Nv/4)-Nv)~= 0)
	disp('Nv must be 4 x N. The current Nv is not');
	pause;
end 

hu=(umax+Pi/2)/Nu;
hv=2*Pi/Nv;

cw=alpha0*cosh(w0);
sw=alpha0*sinh(w0);

k=0;
for i=1:Nu+1
	   u=umax-hu*(i-1);
	       for j=1:Nv
	          v=hv*(j-1);
	               k=k+1;
	               uvnode(1,k)=u;
	               uvnode(2,k)=v;
           end
	       
	   dx=2*Pi*sw*cos(u)/Nv;
	   t1=cw*(cos(u)-cos(u-hu));
	   t2=sw*(sin(u)-sin(u-hu));
	   dy=sqrt(t1*t1+t2*t2);
% 	   if(u < -Pi/2.5)
       if u < u_apex_degree
	      z0=cw*sin(u);
	      R0=sw*cos(u);
          kRegular=k;
          iRegular=i;
          break;
% 	      goto 788
       end
end
    
%     kRegular=k
%     iRegular=i

%%%c=======regular mesh================================   
ne=0;
eLine = getLineMesh(Nv);
for i=1 :iRegular-1
	  k1=(i-1)*Nv;
	  k2=    i*Nv;
        for j=1:Nv
	       n1=eLine(1,j)+k1;
	       n2=eLine(2,j)+k1;
	       n3=eLine(2,j)+k2;
	       n4=eLine(1,j)+k2;
	       ne=ne+1;
	       ElementNode(1,ne)=n1;
	       ElementNode(2,ne)=n2;
	       ElementNode(3,ne)=n3;
	       ElementNode(4,ne)=n4	;       	       	       
         end
end
nnRegular = size(uvnode,2);

% c=======mesh for the rest part=============================
% c      R1=0.3*R0
[xy, ENode, NnDisk, NeDisk, Na] = DiskMesh(Nv/4,R0,0.5*R0);


k=kRegular;
for i=Nv+1: NnDisk
	   x=xy(1,i);
	   y=xy(2,i);
	   z=z0;
% c           write(*,*)'x=', x, 'y=', y, 'z=', z
% 		 Call inverseproCoordinate(u, v, w, alpha0, x, y, z)
[u, v, w] = inverseproCoordinate_alpha0(alpha0, x, y, z);
% c           write(*,*)'u=', u, 'v=', v, 'w=', w
	        k=k+1;
	        uvnode(1,k)=u;
	        uvnode(2,k)=v;
end
	
nd=kRegular-Nv;

%from neRegular to ne, the meshes are in disk region (apex)
neRegular = ne;
%%only exludig the most square mesh close to the apex


for j=1: NeDisk
	       n1=ENode(1,j)+nd;
	       n2=ENode(2,j)+nd;
	       n3=ENode(3,j)+nd;
	       n4=ENode(4,j)+nd;
	       ne=ne+1;
	       ElementNode(1,ne)=n1;
	       ElementNode(2,ne)=n2;
	       ElementNode(3,ne)=n3;
	       ElementNode(4,ne)=n4;
end
	
        NNode=k;
        Nelement=ne;


    