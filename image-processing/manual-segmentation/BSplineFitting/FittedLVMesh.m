function FittedLVMesh(w1, w2, alpha0, umax, NwMesh, NuMesh, NvMesh, NNode, Nelement,ElementNode, ...
                      uvnode,  nptsu, nptsv, uknot, vknot, kS, AIJ_Epi, AIJ_Endo, fid)
Nw = NwMesh; 
Nu = NuMesh;
Nv = NvMesh;

fprintf(fid, 'ZONE T="Fitted LV Mesh", N=%d, E=%d, F=FEPOINT, ET=BRICK\n', NNode*(Nw+1), Nw*Nelement);

                  
w_endo = w1;
w_epi = w2;

Pi = -pi;
hw = (w_epi-w_endo)/Nw;
u0 = -pi/2;
hu = (umax-u0)/Nu;
hv = 2*Pi/Nv;

for i=1: NNode
	  u=uvnode(1,i);
	  v=uvnode(2,i);
      [pEpi_t, pEndo_t] = Fit_function(nptsu, nptsv, uknot, vknot, u, v, kS,AIJ_Epi, AIJ_Endo);
      pEpi(i) = pEpi_t;
      pEndo(i)=pEndo_t;
end


      np=0;

for iw=0:Nw
	w=hw*iw+w_endo;
    for i=1: NNode
	p = interpolate(w,w_endo,w_epi,pEndo(i),pEpi(i));
		cw=cosh(p);
		sw=sinh(p);
		u=uvnode(1,i);
		v=uvnode(2,i);
		x1=alpha0*cos(u)*cos(v);
		y1=alpha0*cos(u)*sin(v);
		z1=alpha0*sin(u);
				x=x1*sw;
				y=y1*sw;
				z=z1*cw;

      fprintf(fid, '%f    %f     %f    %f      %f     %f\n', x,y,z,u*180/Pi,v*180/Pi,p);
    end
end


%%%write out the mesh
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


function p = interpolate(w,w1,w2,p1,p2)
	L0=w2-w1;
	L1=(w2-w)/L0;
	L2=(w-w1)/L0;
	p=p1*L1+p2*L2;
	