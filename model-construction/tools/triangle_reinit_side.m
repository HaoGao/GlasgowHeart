function eleShape_face = triangle_reinit_side(ksi, xcoor, ycoor, side)

%%currently this is for 2dimensional linear triangle
if side == 1
    xcoor_side = [xcoor(1) xcoor(2)];
    ycoor_side = [ycoor(1) ycoor(2)];
    phi(1) = 0.5*(1-ksi);
    phi(2) = 0.5*(1+ksi);
    phi(3) = 0.0;
elseif side == 2
    xcoor_side = [xcoor(2) xcoor(3)];
    ycoor_side = [ycoor(2) ycoor(3)];
    phi(1) = 0.0;
    phi(2) = 0.5*(1-ksi);
    phi(3) = 0.5*(1+ksi);
elseif side == 3
    xcoor_side = [xcoor(3) xcoor(1)];
    ycoor_side = [ycoor(3) ycoor(1)];
    phi(1) = 0.5*(1+ksi);
    phi(2) = 0.0;
    phi(3) = 0.5*(1-ksi);
else
    disp('the side nubmer is wrong, should be from 1 to 3');
end



eleShape = ele_triangle_iso(0,0,xcoor, ycoor);
dphidx_n1 = eleShape.dphidx;
dphidy_n1 = eleShape.dphidy;
    
eleShape = ele_triangle_iso(1,0,xcoor, ycoor);
dphidx_n2 = eleShape.dphidx;
dphidy_n2 = eleShape.dphidy;
    
eleShape = ele_triangle_iso(0,1,xcoor, ycoor);
dphidx_n3 = eleShape.dphidx;
dphidy_n3 = eleShape.dphidy;

% gaussianCoefs = GaussIntegrationPoints('Line2',5); 
% ksi = gaussianCoefs.ksi ; 
% weights = gaussianCoefs.weights ;

%%line orientation;
vec_x = [xcoor_side(2)-xcoor_side(1) ycoor_side(2)-ycoor_side(1)];
[vec_x_n, Lmag] = vecNormalization(vec_x);
%%line length

eleShape_face.phi = phi;
eleShape_face.Jdet = Lmag/2;



