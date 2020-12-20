function eleShape_face = ele_quadrilateral_reinit_side(ksi, xcoor, ycoor, side)

%%currently this is for 2dimensional linear triangle
if side == 1
    xcoor_side = [xcoor(1) xcoor(2)];
    ycoor_side = [ycoor(1) ycoor(2)];
    phi(1) = 0.5*(1-ksi);
    phi(2) = 0.5*(1+ksi);
    phi(3) = 0.0;
    phi(4) = 0.0;
elseif side == 2
    xcoor_side = [xcoor(2) xcoor(3)];
    ycoor_side = [ycoor(2) ycoor(3)];
    phi(1) = 0.0;
    phi(2) = 0.5*(1-ksi);
    phi(3) = 0.5*(1+ksi);
    phi(4) = 0.0;
elseif side == 3
    xcoor_side = [xcoor(3) xcoor(4)];
    ycoor_side = [ycoor(3) ycoor(4)];
    phi(1) = 0.0;
    phi(2) = 0.0;
    phi(3) = 0.5*(1-ksi);
    phi(4) = 0.5*(1+ksi);
elseif side == 4
    xcoor_side = [xcoor(4) xcoor(1)];
    ycoor_side = [ycoor(4) ycoor(1)];
    phi(1) = 0.5*(1+ksi);
    phi(2) = 0.0;
    phi(3) = 0.0;
    phi(4) = 0.5*(1-ksi);
   
else
    disp('the side nubmer is wrong, should be from 1 to 3');
end


% gaussianCoefs = GaussIntegrationPoints('Line2',5); 
% ksi = gaussianCoefs.ksi ; % weights = gaussianCoefs.weights ;

%%line orientation;
vec_x = [xcoor_side(2)-xcoor_side(1) ycoor_side(2)-ycoor_side(1)];
[vec_x_n, Lmag] = vecNormalization(vec_x);
%%line length

eleShape_face.phi = phi;
eleShape_face.Jdet = Lmag/2;



