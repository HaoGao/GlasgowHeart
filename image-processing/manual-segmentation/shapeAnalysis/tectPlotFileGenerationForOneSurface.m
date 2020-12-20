function tectPlotFileGenerationForOneSurface(abaqusInputData,w_allEndoNodes, alpha0,surfaceName, fid)


node = abaqusInputData.node;
faces = [];
if strcmp(surfaceName, 'endo')
    faces = abaqusInputData.endofaces;
elseif strcmp(surfaceName, 'epi')
    faces = abaqusInputData.epifaces;
else
    disp('not support seleted face name');
end

NNode = size(node, 1);
Nelement = size(faces,1);
fprintf(fid, 'TITLE = "Fitted Surface"\n');   
fprintf(fid, 'VARIABLES = "x","y","z","u","v","w" \n');
fprintf(fid, 'ZONE T="fitted Endo Surface", N=%d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', NNode, Nelement);


%%we will need to update the endo_node w
endoNodes = abaqusInputData.endoNodes;
if ~isempty(w_allEndoNodes)
    for i = 1 : length(endoNodes)
        node_index = endoNodes(i);
        node(node_index,6) = w_allEndoNodes(i);
    end
end
    
Pi = -pi;
for ni = 1 : NNode
      u =  node(ni,4)*Pi/180;
	  v =  node(ni,5)*Pi/180;
      w =  node(ni,6);     
      cw=alpha0*cosh(w);
	  sw=alpha0*sinh(w);         	  
		cu=cos(u);
		su=sin(u);
		cv=cos(v);
		sv=sin(v);
		x=sw*cu*cv;
		y=sw*cu*sv;
		z=cw*su;
      fprintf(fid, '%f  %f   %f   %f   %f   %f \n', x,y,z,u,v,w);
end


%%now output the surface
for i=1: Nelement
    elemID = faces(i,1);
    faceID = faces(i,2);
    elem_node_ID = abaqusInputData.elem(elemID,:);
    if faceID == 1
        face_node_id = [1 2 3 4];
    elseif faceID == 2
        face_node_id = [5 8 7 6];
    elseif faceID == 3
        face_node_id = [1 5 6 2];
    elseif faceID == 4
        face_node_id = [2 6 7 3];
    elseif faceID == 5
        face_node_id = [3 7 8 4];
    elseif faceID == 6
        face_node_id = [4 8 5 1];
    end
    
    
	       n1=elem_node_ID(face_node_id(1));
	       n2=elem_node_ID(face_node_id(2));
	       n3=elem_node_ID(face_node_id(3));
	       n4=elem_node_ID(face_node_id(4));
           fprintf(fid, '%d   %d   %d   %d \n', n1,n2,n3,n4);
end










