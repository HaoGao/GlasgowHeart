function [xnew, ynew, znew] = interp_hg(x, y, z, NLayers)

 delta_x = (x(2) - x(1))/NLayers;
 delta_y = (y(2) - y(1))/NLayers;
 delta_z = (z(2) - z(1))/NLayers;
 
 NNodes = NLayers + 1;
 for i = 1 : NNodes
     xnew(i) = x(1) + delta_x*(i-1);
     ynew(i) = y(1) + delta_y*(i-1);
     znew(i) = z(1) + delta_z*(i-1);
 end