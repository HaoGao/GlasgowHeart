function x = knot_Clamped(n, c, minV, maxV)
% the generated curve will concide with the starting and ending control points
% c    Subroutine to generate a B-spline open knot vector with multiplicity
% c    equal to the order at the ends.c
% c	
% c    c            = order of the basis function (order=degree+1)
% c    n            = the number of defining polygon vertices
% c    nplus2       = index of x() for the first occurence of the maximum knot vector value
% c    nplusc       = maximum value of the knot vector -- $n + c$
% c    x()          = array containing the knot vector
% the usable parameter range is x(c) x(n+1);
x = zeros([1 n+c]);

for i = 1 : c
    x(i) = minV;
end

for i = n+1 : n+c
    x(i) = maxV;
end

step = (maxV-minV)/(n+1-c);

for i = c+1: n
    x(i) = x(i-1) + step;
end

