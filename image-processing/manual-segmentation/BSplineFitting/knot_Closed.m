function x = knot_Closed(n,c,minV,maxV)
% subroutine to generate a B-spline close knot vector 
%  the usable parameter range is x(c) x(n+1)
% c	
% c    c            = order of the basis function (order=degree+1)
% c    n            = the number of defining polygon vertices
% c    nplus2       = index of x() for the first occurence of the maximum knot vector value
% c    nplusc       = maximum value of the knot vector -- $n + c$
% c    x()          = array containing the knot vector
x(1:n+c) = 0.0;
h = (maxV-minV)/(n+1-c);
t0 = minV-h*(c-1);
x(1) = t0;

for i = 2: n+c
    x(i) = h + x(i-1);
end
