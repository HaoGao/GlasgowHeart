function nbasis = basisFunction(c, t, npts, x)
% c	C code for An Introduction to NURBS
% c	by David F. Rogers. Copyright (C) 2000 David F. Rogers,
% c	All rights reserved.
% c	
% c	Name: dbasisu.c
% c	Language: C
% c	Subroutines called: none
% c	Book reference: Section 3.10

% n[p1]       = array containing the basis functions
% npts        = number of defining polygon vertices (including overlapping control points for closed b-spline)
% nplusc    = constant -- npts + c -- maximum knot value
% t         = parameter value (sometimes it is u)
% temp[]    = temporary array
% x[]       = knot vector


nplusc = npts + c;

for i = 1 : nplusc-1
    if (t>=x(i) && t<x(i+1))
        temp(i) = 1.0;
    else
        temp(i) = 0.0;
    end
end

% pick up last point
if abs(t-x(nplusc))<=1.0e-6
    temp(npts) = 1.0;
end

% % calculate the hihger order basis functions
for k = 2 : c
    for i = 1: nplusc-k
%       c:      if the lower order basis function is zero skip the calculation  
        
         
         g1=temp(i);
         g2=temp(i+1);
         b1=0.0;
         b2=0.0;
         
       	 if abs(g1) >= 1.0e-6
              x1=1/(x(i+k-1)-x(i));
              w1=(t-x(i))*x1;
              b1 = w1*g1;
         end

    	 if abs(g2) > 1.0e-6
             x2=1/(x(i+k)-x(i+1));
             w2=(x(i+k)-t)*x2;
	    	 b2 = w2*g2;
         end
	        	
          temp(i)  = b1 + b2;     
    end
end

nbasis = zeros([1, npts]);
% nbasis = temp(1:npts);
for i = 1 : npts
    nbasis(i) = temp(i);
end


