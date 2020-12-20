function abaqusInputData = FittedLVMeshWithOutPut(w1, w2, alpha0, umax, NwMesh, NuMesh, NvMesh, NNode, Nelement,ElementNode, ...
                      uvnode,  nptsu, nptsv, uknot, vknot, kS, AIJ_Epi, AIJ_Endo, neRegular, fid)
Nw = NwMesh; 
Nu = NuMesh;
Nv = NvMesh;

node = zeros([NNode*(Nw+1) 6]);
elem = zeros([Nw*Nelement 8]);
nodeIndex = 0; 
elemIndex = 0;
endofaces=[];
endofacesIndex = 0;
epifaces = [];
epifacesIndex = 0;
basefaces = [];

baseNodes=[];
for i = 1 : NwMesh+1
    for j = 1 : NvMesh
        baseNodeIndex = (i-1)*NNode + j;
        baseNodes = [baseNodes, baseNodeIndex];
    end
end
endoNodes = 1:NNode;
epiNodes = NNode*Nw+1:NNode*(Nw+1);
%%%for base surface
basefaces(:,1) = [1:NvMesh*NwMesh]';
basefaces(:,2) = 1;

fprintf(fid, 'ZONE T="Fitted LV Mesh", N=%d, E=%d, F=FEPOINT, ET=BRICK\n', NNode*(Nw+1), Nw*Nelement );

                  
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

      fprintf(fid, '%f    %f     %f    %f      %f     %f\n', x*10,y*10,z*10,u*180/pi,v*180/pi,p);
      
      %%for abaqus data
      nodeIndex = nodeIndex + 1;
      node(nodeIndex, 1 : 6) = [x,y,z,u*180/pi,v*180/pi,p];
      distance_to_endo(nodeIndex,1) = (w-w_endo)/(w_epi-w_endo);
      
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
         
        %%for abaqus data
            %%%convex hull test
%             xx = [node(n1,1), node(n2,1), node(n3,1), node(n4,1), node(n5,1), node(n6,1), node(n7,1), node(n8,1)];
%             yy = [node(n1,2), node(n2,2), node(n3,2), node(n4,2), node(n5,2), node(n6,2), node(n7,2), node(n8,2)];
%             zz = [node(n1,3), node(n2,3), node(n3,3), node(n4,3), node(n5,3), node(n6,3), node(n7,3), node(n8,3)];
%             xyz = [xx', yy', zz'];
%             tess = convhulln(xyz);
%             tess = unique(tess(:));
%             if length(tess)==8 %%if the eight nodes is in a convex hull, then output
               elemIndex = elemIndex + 1;
%             if i <= neRegular
%                 apexEleStartNo = 26401;
                   apexEleStartNo = neRegular;
                if elemIndex <apexEleStartNo
                    elem(elemIndex, 1 : 8) = [n1,n2,n6,n5,n4,n3,n7,n8]; %%26401 needs to find by importing the first initial mesh into abaqus for generating
                    %%%endo faces 
                    if j == 1
                        endofacesIndex = endofacesIndex + 1;
                        endofaces(endofacesIndex,:) = [elemIndex, 3];  
%                         endoNodes = [endoNodes, n1, n2, n3, n4, n5, n6, n7, n8];
                    end
                    if j == Nw
                        epifacesIndex = epifacesIndex + 1;
                        epifaces(epifacesIndex,:) = [elemIndex, 5];
                    end
                    
                else
                    elem(elemIndex, 1 : 8) = [n1, n2, n3, n4, n5, n6, n7, n8];
                    if j == 1
                        endofacesIndex = endofacesIndex + 1;
                        endofaces(endofacesIndex,:) = [elemIndex, 1];  
%                         endoNodes = [endoNodes, n1, n2, n3, n4, n5, n6, n7, n8];
                    end
                    if j == Nw
                        epifacesIndex = epifacesIndex + 1;
                        epifaces(epifacesIndex,:) = [elemIndex, 2];
                    end
                end
                
%             else
%                 elem(elemIndex, 1 : 8) = [n1,n2,n6,n5,n4,n3,n7,n8];
% %             end
%             end

            %%%endo faces 
            
                


         end
end


abaqusInputData.node = node;
abaqusInputData.elem = elem;
abaqusInputData.endofaces = endofaces;
abaqusInputData.epifaces = epifaces;
abaqusInputData.basefaces = basefaces;
abaqusInputData.distance_to_endo = distance_to_endo;

endoNodes = sort(unique(endoNodes));
abaqusInputData.endoNodes = endoNodes;
abaqusInputData.baseNodes = baseNodes;
abaqusInputData.epiNodes=epiNodes;
abaqusInputData.apexEleStartNo = apexEleStartNo;
abaqusInputData.distance_to_endo = distance_to_endo;



function p = interpolate(w,w1,w2,p1,p2)
	L0=w2-w1;
	L1=(w2-w)/L0;
	L2=(w-w1)/L0;
	p=p1*L1+p2*L2;
	