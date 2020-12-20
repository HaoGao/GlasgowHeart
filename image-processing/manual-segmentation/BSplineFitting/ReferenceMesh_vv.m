function ReferenceMesh(NwMesh, NuMesh, NvMesh, NNode,uvnode, Nelement, ElementNode, ...
                      w1, w2,alpha0,umax,fid, Xdis, Ydis, disMax)
               
                  
Nw=NwMesh;
Nu=NuMesh;
Nv=NvMesh;

fprintf(fid, 'ZONE T="Reference Mesh", N=%d, E=%d, F=FEPOINT, ET=BRICK\n',NNode*(Nw+1),Nw*Nelement);

    w_endo=w1;
	w_epi=w2;

	Pi=acos((-1));

	hw=(w_epi-w_endo)/Nw;
	u0=-Pi/2;
	hu=(umax-u0)/Nu;
	hv=2*Pi/Nv;

	for iw=0:Nw
	   w=hw*iw+w_endo;
	   cw=cosh(w);
	   sw=sinh(w);
      for i=1: NNode
	  u=uvnode(1,i);
	  v=uvnode(2,i);
		x1=alpha0*cos(u)*cos(v);
		y1=alpha0*cos(u)*sin(v);
		z1=alpha0*sin(u);
        
        z=z1*cw;
        x=x1*sw - abs(z1)/disMax*Xdis;
		y=y1*sw + abs(z1)/disMax*Xdis;
				
		fprintf(fid, '%f   %f    %f    %f    %f    %f\n', x,y,z,u*180/Pi,v*180/Pi,w);
% 903				format(6(f16.8,2x))
% 1000  COntinue
      end
    end
% 2000  Continue

for i = 1 : Nelement
        e1=ElementNode(1,i);
		e2=ElementNode(2,i);
		e3=ElementNode(3,i);
		e4=ElementNode(4,i);
	     for j=1:Nw
			k1=(j-1)*NNode;
			k2=j*NNode;
	       n1=e1+k1;
	       n2=e2+k1;
	       n3=e3+k1;
	       n4=e4+k1;
	       n5=e1+k2;
	       n6=e2+k2;
	       n7=e3+k2;
	       n8=e4+k2;
             fprintf(fid, '%d   %d    %d    %d    %d    %d     %d    %d\n', n1,n2,n3,n4,n5,n6,n7,n8);
% 904          format(8(i8,2x))
%            enddoR
         end
end
% 2100  Continue
%       return
%       end



