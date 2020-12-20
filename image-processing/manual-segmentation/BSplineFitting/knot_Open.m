function x = knot_Open(n,c,minV, maxV)
% c    Subroutine to generate a B-spline open knot vector without multiplicity at the ends
%  the usable parameter range is x(c) x(n+1)
% c	
% c    c            = order of the basis function (order=degree+1)
% c    n            = the number of defining polygon vertices
% c    nplus2       = index of x() for the first occurence of the maximum knot vector value
% c    nplusc       = maximum value of the knot vector -- $n + c$
% c    x()          = array containing the knot vector

x(1: n+c) = 0.0;

step=(maxV-minV)/(n+1-c);
t0=minV-step*(c-1);
for i = 1:n+c
    x(i) = t0 + step*(i-1);
end
