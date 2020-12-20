function vol = elem_vol(elem_xyz)


DT_endo =  DelaunayTri(elem_xyz(:,1),elem_xyz(:,2),elem_xyz(:,3));
[~, vol] = convexHull(DT_endo);

