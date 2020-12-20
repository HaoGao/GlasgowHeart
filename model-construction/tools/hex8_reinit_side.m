function eleShape_face = hex8_reinit_side(ksi, eta, xcoor, ycoor, zcoor, side)
faces = [1 4 3 2; ...
         1 2 6 5; ...
         2 3 7 6; ...
         3 4 8 7; ...
         4 1 5 8; ...
         5 6 7 8; ...
         ];
TotalNodes = length(xcoor);
%%currently this is for 2dimensional linear triangle
if side >=1 && side<=8
    nid = faces(side,:);
    phi(1:TotalNodes) = 0;
    xcoor_side = xcoor(nid);
    ycoor_side = ycoor(nid);
    zcoor_side = zcoor(nid);
    
    phi(nid(1)) = 1/4*(1-ksi)*(1-eta);
    phi(nid(2)) = 1/4*(1+ksi)*(1-eta);
    phi(nid(3)) = 1/4*(1+ksi)*(1+eta);
    phi(nid(4)) = 1/4*(1-ksi)*(1+eta);
else
    disp('the side nubmer is wrong, should be from 1 to 8');
end

% gaussianCoefs = GaussIntegrationPoints('Line2',5); 
% ksi = gaussianCoefs.ksi ; 
% weights = gaussianCoefs.weights ;

area_1 = area_triangle(xcoor_side([1,2,3]),ycoor_side([1,2,3]),zcoor_side([1,2,3]));
area_2 = area_triangle(xcoor_side([1,4,3]),ycoor_side([1,4,3]),zcoor_side([1,4,3]));
area_total = area_1 + area_2;


eleShape_face.phi = phi;
eleShape_face.Jdet = area_total/4;



