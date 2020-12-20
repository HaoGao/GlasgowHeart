function pT = project3DPointOnAPlaneDefOrignNormal(p,orig,normal)
%project a  3D points into a general plane defiend by orig and normal
v = p - orig;
dis = dot(v,normal);
pT = p - dis*normal;
