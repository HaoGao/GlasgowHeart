function FF = finiteStrainHex(nodeCurx, nodeCury, nodeCurz, ...
                           nodeRefx, nodeRefy, nodeRefz)
                       
x(1,:) = nodeCurx' - nodeCurx(1);
x(2,:) = nodeCury' - nodeCury(1);
x(3,:) = nodeCurz' - nodeCurz(1);

X(1,:) = nodeRefx' - nodeRefx(1);
X(2,:) = nodeRefy' - nodeRefy(1);
X(3,:) = nodeRefz' - nodeRefz(1);

FF = x/X;